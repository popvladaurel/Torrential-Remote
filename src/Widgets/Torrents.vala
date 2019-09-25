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
        box.margin = 100;
        box.margin_left = 200;
        box.margin_right = 200;
        
        Transmission client = new Transmission("192.168.100.101", 9091, "transmission", null);
        Json.Parser torrents = client.getTorrents();
        GLib.List<weak Json.Node> nodes = torrents.get_root().get_object().get_object_member("arguments").get_array_member("torrents").get_elements();

       foreach(var node in nodes) {
            var obj = node.get_object();
            stdout.printf("%d: %s - %.2f%% [%.2f/%.2f] %d byte\n",
               (int)obj.get_int_member("id"),
               obj.get_string_member("name"),
               (float)obj.get_double_member("percentDone")*100,
               (float)obj.get_double_member("rateDownload"),
               (float)obj.get_double_member("rateUpload"),
               (int)obj.get_int_member("sizeWhenDone"));
               TorrentRow row = new TorrentRow();
                box.add(row.getRow(obj));
           }
        
        
        scroll.add(box);
        add(scroll);
    }
    
    private void buildBox() {
        try {

         
      }
      catch(Error e) {
         error("%s", e.message);
      }
    }
}
