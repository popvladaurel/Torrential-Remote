public class TorrentialRemote.Welcome : Gtk.Grid {
    construct {
        var welcome = new Granite.Widgets.Welcome ("Torrential Remote", "Remote Torrent Manager");
        welcome.append ("document-new", "Connect to server...", "Start by adding a server to Torrential Remote");

        add (welcome);

        // var button = welcome.get_button_from_index(0);
        // button.action_name = MainWindow.ACTION_PREFIX + MainWindow.ACTION_NEW_CONN;
    }
}
