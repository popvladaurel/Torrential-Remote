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
        Gtk.Button open = new Gtk.Button.from_icon_name("document-open", Gtk.IconSize.LARGE_TOOLBAR );
        open.clicked.connect (() => { this.file (); });
        Gtk.Button magnet = new Gtk.Button.from_icon_name("open-magnet", Gtk.IconSize.LARGE_TOOLBAR );
        magnet.clicked.connect (() => { this.magnet (); });
        pack_start(open);
        pack_start(magnet);
    }

    private void file () {
        File file = null;
        
        Gtk.FileChooserDialog chooser = new Gtk.FileChooserDialog (
            "Select a file to edit", this.window, Gtk.FileChooserAction.OPEN,
            "_Cancel",
            Gtk.ResponseType.CANCEL,
            "_Open",
            Gtk.ResponseType.ACCEPT);
        chooser.set_select_multiple (false);
        chooser.run ();
        chooser.close ();
        if (chooser.get_file () != null) {
            file = chooser.get_file ();

            try {
                uint8[] contents;
                string etag_out;
                file.load_contents (null, out contents, out etag_out);
                Models.Client client = new Models.Client(window.server);
                client.addFromFile (contents);
            } catch (Error e) {
                stdout.printf ("Error: %s\n", e.message);
            }
        }
    }

    private void magnet () {
        
        Gtk.Dialog dialog = new Gtk.Dialog.with_buttons (
            null, 
            this.window,
            Gtk.DialogFlags.MODAL,
            Gtk.Stock.CANCEL,
            Gtk.ResponseType.CANCEL,
            Gtk.Stock.OK,
            Gtk.ResponseType.OK, 
            null
        );

        Gtk.Entry entry = new Gtk.Entry ();
        entry.changed.connect (() => {
            // Only allow OK when there's text in the box.
            dialog.set_response_sensitive (Gtk.ResponseType.OK, entry.text.strip () != "");
        });

        dialog.width_request = 500;
        dialog.get_content_area ().spacing = 7;
        dialog.get_content_area ().border_width = 10;
        dialog.get_content_area ().pack_start (new Gtk.Label ("Magnet URL:"));
        dialog.get_content_area ().pack_start (entry);
        dialog.get_widget_for_response (Gtk.ResponseType.OK).can_default = true;
        dialog.set_default_response (Gtk.ResponseType.OK);

        dialog.show_all ();

        var clipboard = Gtk.Clipboard.get (Gdk.SELECTION_CLIPBOARD);
        string? contents = clipboard.wait_for_text ();
        if (contents != null || contents != "") {
            entry.text = contents;
        }

        entry.activates_default = true;
        entry.select_region (0, -1);

        dialog.set_response_sensitive (Gtk.ResponseType.OK, entry.text.strip () != "");

        int response = dialog.run ();
        if (response == Gtk.ResponseType.OK) {
            //TODO torrent from link
            Models.Client client = new Models.Client(window.server);
            client.addFromMagnet (entry.text);
        }

        dialog.destroy ();
    }
}
