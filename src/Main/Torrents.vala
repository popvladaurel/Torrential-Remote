public class Main.Torrents : Gtk.ListBox {
    public Server.Model server;
    public Client.Model client;
    public List<Torrent.View> rows;  

    public Torrents (Server.Model server) {

        // move this to an async method to improve start-up time
        rows = new List<Torrent.View> ();
        client = new Client.Model (server);

        Json.Array torrents = client.all();

        foreach (Json.Node node in torrents.get_elements()) {
            Torrent.Model torrent = new Torrent.Model(node);
            Torrent.View row = new Torrent.View(torrent);

            row.pause.clicked.connect (() => {
                GLib.Application.get_default().send_notification(null, new Notification ("TODO: NOT YET IMPLEMENTED"));
            });
            rows.append(row);
            prepend(row);
        }
                
        var loop = new MainLoop();
        TimeoutSource time = new TimeoutSource (2000);
        var count = 0;
        time.set_callback (() => {
            do_calc_in_bg.begin(rows, (obj, res) => {
                try {
                    count++;
                    double result = do_calc_in_bg.end(res);
                    stderr.printf(@"$count Result: $result\n");
                } catch (ThreadError e) {
                    string msg = e.message;
                    stderr.printf(@"Thread error: $msg\n");
                }
                loop.quit();
            });
            return true;
        });
    
        time.attach (loop.get_context ());

        loop.run();
    }

    async double do_calc_in_bg(List<Torrent.View> rows) throws ThreadError {
        SourceFunc callback = do_calc_in_bg.callback;
        double[] output = new double[1];

        Json.Array torrents2 = client.all();

    
        // Hold reference to closure to keep it from being freed whilst
        // thread is active.
        ThreadFunc<bool> run = () => {

            foreach (Json.Node node in torrents2.get_elements()) {
                Torrent.Model torrent2 = new Torrent.Model(node);
                foreach (Torrent.View row in rows) {
                    if (row.id == torrent2.id) {
                        row.stats.set_text(torrent2.stats());
                        row.state.set_text(torrent2.state());
                        row.progress.fraction = torrent2.percentDone;
                        //TODO Also change the pause button's icon
                        if (torrent2.status == Torrent.Statuses.CHECK) {
                            row.progress.fraction = torrent2.recheckProgress;
                        }
                    }
                }
                //  torrents2.remove(node);
            }

            
            output[0] = torrents2.get_length();
            Idle.add((owned) callback);
            return true;
        };
        
        new Thread<bool>("thread-example", run);
    
        // Wait for background thread to schedule our callback
        yield;
        Thread.usleep(1000);

        return output[0];
    }
    
}