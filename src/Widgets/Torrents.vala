public class TorrentialRemote.Torrents : Gtk.Grid {
    public Models.Server server;
    public Models.Client client;
    public List<Json.Node> torrents;

    construct {
        server = new Models.Server ("192.168.100.101", 9091, null, null);
        client = new Models.Client (server);
    }

    public Torrents () {
        
        Gtk.Box box = new Gtk.Box (Gtk.Orientation.VERTICAL, 12);
        box.expand = true;
        
        torrents = client.all();

        foreach(Json.Node node in torrents) {
            var torrent = node.get_object();
            TorrentRow row = new TorrentRow();
            box.add(row.getRow(torrent));
        }
                
        add(box);
    }
}
