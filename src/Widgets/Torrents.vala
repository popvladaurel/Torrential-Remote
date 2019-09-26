public class TorrentialRemote.Torrents : Gtk.Grid {
    public TorrentialRemote.Window window { set; get;}

    public Torrents (Window window) {
        Object (
            window: window
        );
    }

    construct {
        Gtk.Box box = new Gtk.Box (Gtk.Orientation.VERTICAL, 12);
        Gtk.ScrolledWindow scroll = new Gtk.ScrolledWindow(null, null);
        box.expand = true;
        
        Transmission client = new Transmission("192.168.100.101", 9091, "transmission", null);
        Json.Parser torrents = client.getTorrents();
        GLib.List<weak Json.Node> nodes = torrents.get_root().get_object().get_object_member("arguments").get_array_member("torrents").get_elements();

       foreach(var node in nodes) {
           var obj = node.get_object();
           TorrentRow row = new TorrentRow();
           box.add(row.getRow(obj));
        }
                
        scroll.add(box);
        add(scroll);
    }
}
