public class Widgets.HeaderBar : Gtk.HeaderBar {
    public Window window { get; construct;}

    public HeaderBar (Window window) {
         Object (
             window: window
         );
     }

    construct {
        title = "Torrential Remote";
        subtitle = "Manage your remote torrents!";
        show_close_button = true;
        Gtk.Button add = new Gtk.Button.from_icon_name("document-new", Gtk.IconSize.LARGE_TOOLBAR );
    }
}
