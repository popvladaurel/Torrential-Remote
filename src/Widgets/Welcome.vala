public class TorrentialRemote.Welcome : Gtk.Grid {
    public TorrentialRemote.Window window { set; get;}

    public Welcome (Window window) {
        Object (
            window: window
        );
    }

    construct {
        Granite.Widgets.Welcome welcome = new Granite.Widgets.Welcome ("Torrential Remote", "Remote Torrent Manager");
        welcome.append ("document-new", "Connect to server...", "Start by adding a server to Torrential Remote");
        Gtk.Button button = welcome.get_button_from_index(0);
        button.clicked.connect (e => {
            window.showConnection();
        });

        add (welcome);
    }
}
