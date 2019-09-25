public class TorrentialRemote.TorrentRow : Gtk.ListBoxRow {
    // private Torrent torrent;
    private Gtk.ProgressBar progress;
    private Gtk.Label completeness;
    private Gtk.Label status;
    private Gtk.Label torrent_name;
    private Gtk.Button pause_button;

    private Gtk.CssProvider green_progress_provider;

    private const string PAUSE_ICON_NAME = "media-playback-pause-symbolic";
    private const string RESUME_ICON_NAME = "media-playback-start-symbolic";

    public signal void torrent_removed ();

    // public bool multi_file_torrent {
    //     get {
    //         return torrent.file_count > 1;
    //     }
    // }


    public TorrentRow() {
        // this.torrent = torrent;

        // green_progress_provider = new Gtk.CssProvider ();
        // try {
        //     green_progress_provider.load_from_data ("@define-color selected_bg_color @success_color;");
        // } catch (Error e) {
        //     warning ("Failed to load custom CSS to make green progress bars. Error: %s", e.message);
        // }

         
    }
    
    public Gtk.Grid getRow(unowned Json.Object torrent) {
    var grid = new Gtk.Grid ();
         grid.margin = 12;
         grid.margin_bottom = grid.margin_top = 6;
         grid.column_spacing = 12;
         grid.row_spacing = 3;

        // add (grid);

         Icon icon;
         // if (torrent.file_count > 1) {
             icon = ContentType.get_icon ("inode/directory");
        // } else {
        //     var files = torrent.files;
        //     if (files != null && files.length > 0) {
        //         bool certain = false;
        //         var content_type = ContentType.guess (files[0].name, null, out certain);
        //         icon = ContentType.get_icon (content_type);
        //     } else {
        //         icon = ContentType.get_icon ("application/x-bittorrent");
        //     }
        // }
         var icon_image = new Gtk.Image.from_gicon (icon, Gtk.IconSize.DIALOG);
         grid.attach (icon_image, 0, 0, 1, 4);

         torrent_name = new Gtk.Label (torrent.get_string_member("name"));
         torrent_name.halign = Gtk.Align.START;
         torrent_name.get_style_context ().add_class ("h3");
         grid.attach (torrent_name, 1, 0, 1, 1);

         completeness = new Gtk.Label ("<small>%s</small>".printf ("completeness"));
         completeness.halign = Gtk.Align.START;
         completeness.use_markup = true;
         grid.attach (completeness, 1, 1, 1, 1);

        // progress = new Gtk.ProgressBar ();
        // progress.hexpand = true;
        // progress.fraction = torrent.progress;
        // if (torrent.seeding) {
        //     progress.get_style_context ().add_provider (green_progress_provider, Gtk.STYLE_PROVIDER_PRIORITY_USER);
        // }
        // grid.attach (progress, 1, 2, 1, 1);

        // if (!torrent.paused) {
             pause_button = new Gtk.Button.from_icon_name (PAUSE_ICON_NAME);
             pause_button.tooltip_text = "Pause torrent";
        // } else {
        //     pause_button = new Gtk.Button.from_icon_name (RESUME_ICON_NAME);
        //     pause_button.tooltip_text = _("Resume torrent");
        // }

         pause_button.get_style_context ().add_class ("flat");
         pause_button.clicked.connect (() => {
		        // application.send_notification(null, new Notification ("showing torrents"));
         });
         grid.attach (pause_button, 2, 1, 1, 4);

        status = new Gtk.Label ("<small>%s</small>".printf ("TODO"));
        status.halign = Gtk.Align.START;
        status.use_markup = true;
        grid.attach (status, 1, 3, 1, 1);
        
        return grid;
    }
}
