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

    public enum torrentStatus {
        STOPPED        = 0, /* Torrent is stopped */
        CHECK_WAIT     = 1, /* Queued to check files */
        CHECK          = 2, /* Checking files */
        DOWNLOAD_WAIT  = 3, /* Queued to download */
        DOWNLOAD       = 4, /* Downloading */
        SEED_WAIT      = 5, /* Queued to seed */
        SEED           = 6  /* Seeding */
    }

    


    public TorrentRow() {
        // this.torrent = torrent;

        green_progress_provider = new Gtk.CssProvider ();
        try {
           green_progress_provider.load_from_data ("@define-color selected_bg_color @success_color;");
        } catch (Error e) {
           warning ("Failed to load custom CSS to make green progress bars. Error: %s", e.message);
        }

         
    }
    
    public Gtk.Grid getRow(Json.Object torrent) {
    var grid = new Gtk.Grid ();
         grid.margin = 12;
         grid.margin_bottom = grid.margin_top = 6;
         grid.column_spacing = 12;
         grid.row_spacing = 3;

         Icon icon;
         if (torrent.get_array_member("files").get_length() > 1) {
             icon = ContentType.get_icon ("inode/directory");
        } else {
            Json.Array files = torrent.get_array_member("files");
            if (files != null && files.get_length() > 0) {
               bool certain = false;
               var content_type = ContentType.guess (files.get_object_element(0).get_string_member("name"), null, out certain);
               icon = ContentType.get_icon (content_type);
            } else {
               icon = ContentType.get_icon ("application/x-bittorrent");
            }
        }

        var icon_image = new Gtk.Image.from_gicon (icon, Gtk.IconSize.DIALOG);
        grid.attach (icon_image, 0, 0, 1, 4);

        torrent_name = new Gtk.Label (torrent.get_string_member("name"));
        torrent_name.halign = Gtk.Align.START;
        torrent_name.get_style_context ().add_class ("h3");
        grid.attach (torrent_name, 1, 0, 1, 1);

        string completenessText = "completeness";
        switch (torrent.get_int_member("status")) {
            case 0:
                completenessText = "%s of %s".printf (
                    format_size (torrent.get_int_member("haveValid")),
                    format_size (torrent.get_int_member("sizeWhenDone"))
                );
                 break;
            case 4:
                completenessText = "%s of %s — %s remaining".printf (
                    format_size (torrent.get_int_member("rateDownload")),
                    format_size (torrent.get_int_member("sizeWhenDone")),
                    time_to_string ((uint) torrent.get_int_member("eta"))
                );
                break;
            case 6:
                completenessText = "%s uploaded".printf (
                    format_size (torrent.get_int_member("uploadedEver"))
                );
                break;
            default:
                completenessText = "";
            break;
         }
        
        completeness = new Gtk.Label ("<small>%s</small>".printf (completenessText));
        completeness.halign = Gtk.Align.START;
        completeness.use_markup = true;
        grid.attach (completeness, 1, 1, 1, 1);

        progress = new Gtk.ProgressBar ();
        progress.hexpand = true;
        progress.fraction = torrent.get_double_member("percentDone");

        //TODO replace with torrent.isDownloading
        if (torrent.get_int_member("status") == 6) {
           progress.get_style_context ().add_provider (green_progress_provider, Gtk.STYLE_PROVIDER_PRIORITY_USER);
        }
        grid.attach (progress, 1, 2, 1, 1);

        //TODO replace with torrent is paused
         if (torrent.get_int_member("status") != torrentStatus.STOPPED) {
             pause_button = new Gtk.Button.from_icon_name (PAUSE_ICON_NAME);
             pause_button.tooltip_text = "Pause torrent";
        } else {
           pause_button = new Gtk.Button.from_icon_name (RESUME_ICON_NAME);
           pause_button.tooltip_text = "Resume torrent";
        }

         pause_button.get_style_context ().add_class ("flat");
         pause_button.clicked.connect (() => {
		        // application.send_notification(null, new Notification ("showing torrents"));
         });
         grid.attach (pause_button, 2, 1, 1, 4);

         string statusText = "Seeding";

         switch (torrent.get_int_member("status")) {
            case 0:
                statusText = "Paused"; break;
            case 1:
                statusText = "Queued to check files"; break;
            case 2:
                statusText = "Checking files"; break;
            case 3:
                statusText = "Queued to download files"; break;
            case 5:
                statusText = "Queued to seed"; break;
            case 4:
            case 6:
                statusText = "Seeding"; 
                char[40] buf = new char[40];
                var down_speed = format_size(torrent.get_int_member("rateDownload"));
                var up_speed =  format_size(torrent.get_int_member("rateUpload"));
                statusText = "%i  peers connected. \u2b07%s \u2b06%s".printf (
                    (int) torrent.get_int_member("peersConnected"), down_speed, up_speed);
                    break;
         default:
             break;
         }

        status = new Gtk.Label ("<small>%s</small>".printf (statusText));
        status.halign = Gtk.Align.START;
        status.use_markup = true;
        grid.attach (status, 1, 3, 1, 1);
        
        return grid;
    }

    public static string time_to_string (uint totalSeconds) {
        uint seconds = (totalSeconds % 60);
        uint minutes = (totalSeconds % 3600) / 60;
        uint hours = (totalSeconds % 86400) / 3600;
        uint days = (totalSeconds % (86400 * 30)) / 86400;

        var str_days = "%u days".printf (days);
        var str_hours = "%u hours".printf (hours);
        var str_minutes = "%u minutes".printf (minutes);
        var str_seconds = "%u seconds".printf (seconds);

        var formatted = "";
        if (totalSeconds == -1) {
            formatted = "...";
        }
        else if (days > 0) {
            formatted = "%s, %s, %s, %s".printf (str_days, str_hours, str_minutes, str_seconds);
        }
        else if (hours > 0) {
            formatted = "%s, %s, %s".printf (str_hours, str_minutes, str_seconds);
        }
        else if (minutes > 0) {
            formatted = "%s, %s".printf (str_minutes, str_seconds);
        }
        else if (seconds > 0) {
            formatted = str_seconds;
        }
        return formatted;
    }
}
