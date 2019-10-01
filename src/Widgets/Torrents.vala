public class Widgets.Torrents : Gtk.Grid {
    public Models.Server server;
    public Models.Client client;
    public List<Json.Node> torrents;
    public List<TorrentRow> rows;

    construct {
        server = new Models.Server ("192.168.100.101", 9091, null, null);
        client = new Models.Client (server);
    }

    public Torrents () {
        

        // move this to an async method to improve start-up time
        Gtk.Box box = new Gtk.Box (Gtk.Orientation.VERTICAL, 12);
        rows = new List<TorrentRow> ();
        box.expand = true;
        
        torrents = client.all();

        foreach (Json.Node node in torrents) {
            Models.Torrent torrent = new Models.Torrent(node.get_object());
            TorrentRow row = new TorrentRow(torrent);

            row.pause.clicked.connect (() => {
                GLib.Application.get_default().send_notification(null, new Notification ("TODO: NOT YET IMPLEMENTED"));
            });
            rows.append(row);
            box.add(row);
        }
                
        add(box);

        var loop = new MainLoop();
        TimeoutSource time = new TimeoutSource (2000);
        var count = 0;
        time.set_callback (() => {
            do_calc_in_bg.begin(0.001, rows, (obj, res) => {
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

    async double do_calc_in_bg(double val, List<TorrentRow> rows) throws ThreadError {
        SourceFunc callback = do_calc_in_bg.callback;
        double[] output = new double[1];
        List<weak Json.Node> torrents2 = new List<weak Json.Node>();
        torrents2 = client.all();

    
        // Hold reference to closure to keep it from being freed whilst
        // thread is active.
        ThreadFunc<bool> run = () => {

            foreach (Json.Node node in torrents2) {
                Models.Torrent torrent2 = new Models.Torrent(node.get_object());
                foreach (TorrentRow row in rows) {
                    if (row.id == torrent2.id) {
                        row.stats.set_text(torrent2.stats());
                        row.state.set_text(torrent2.state());
                        row.progress.fraction = torrent2.percentDone;
                        //TODO Also change the pause button's icon
                    }
                }
                torrents2.remove(node);
            }

            
            output[0] = torrents2.length();
            Idle.add((owned) callback);
            return true;
        };
        Thread<bool> thread = new Thread<bool>("thread-example", run);
    
        // Wait for background thread to schedule our callback
        yield;
        Thread.usleep(1000);

        return output[0];
    }
    
}