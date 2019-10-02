public class Widgets.TorrentRow : Gtk.ListBoxRow {
    public int64 id;
    public Gtk.Grid grid;
    public Gtk.Image icon;
    public Gtk.Label title;
    public Gtk.Label stats;
    public Gtk.ProgressBar progress;
    public Gtk.Button pause;
    public Gtk.Label state;


    public Models.Torrent torrent;

    private Gtk.CssProvider green_progress_provider;
    private Gtk.CssProvider red_progress_provider;

    private const string PAUSE_ICON_NAME = "media-playback-pause-symbolic";
    private const string RESUME_ICON_NAME = "media-playback-start-symbolic";

    public signal void torrent_removed ();

    construct {
        green_progress_provider = new Gtk.CssProvider ();
        red_progress_provider = new Gtk.CssProvider ();
        try {
           green_progress_provider.load_from_data ("@define-color selected_bg_color @success_color;");
           red_progress_provider.load_from_data ("@define-color selected_bg_color @error_color;");
        } catch (Error e) {
           warning ("Failed to load custom CSS to make green progress bars. Error: %s", e.message);
        }
    }

    public TorrentRow (Models.Torrent torrent) {
        id = torrent.id;

        grid = new Gtk.Grid ();
        grid.margin = 12;
        grid.margin_bottom = margin_top = 6;
        grid.column_spacing = 12;
        grid.row_spacing = 3;
       
        icon = new Gtk.Image.from_gicon (torrent.icon(), Gtk.IconSize.DIALOG);
        
        title = new Gtk.Label (torrent.title());
        title.halign = Gtk.Align.START;
        title.get_style_context ().add_class ("h3");
        
        stats = new Gtk.Label ("<small>%s</small>".printf (torrent.stats()));
        stats.halign = Gtk.Align.START;
        stats.use_markup = true;
        
        progress = new Gtk.ProgressBar ();
        progress.hexpand = true;
        progress.fraction = torrent.progress();

        

        if (torrent.status == Enums.Statuses.CHECK) {
            progress.fraction = torrent.recheckProgress;
            double progresssss = progress.fraction;
            stderr.printf(@"Thread error: $progresssss\n");
        }

        if (torrent.status == Enums.Statuses.SEED)
            progress.get_style_context ().add_provider (green_progress_provider, Gtk.STYLE_PROVIDER_PRIORITY_USER);

        if (torrent.error > 0)
            progress.get_style_context ().add_provider (red_progress_provider, Gtk.STYLE_PROVIDER_PRIORITY_USER);

        pause = new Gtk.Button.from_icon_name (PAUSE_ICON_NAME);
        pause.tooltip_text = "Pause torrent";
        pause.get_style_context ().add_class ("flat");
        
        if (torrent.status != Enums.Statuses.STOPPED) {
            pause = new Gtk.Button.from_icon_name (PAUSE_ICON_NAME);
            pause.tooltip_text = "Pause torrent";
        } else {
            pause = new Gtk.Button.from_icon_name (RESUME_ICON_NAME);
            pause.tooltip_text = "Resume torrent";
        }

        state = new Gtk.Label ("<small>%s</small>".printf (torrent.state()));
        state.halign = Gtk.Align.START;
        state.use_markup = true;
        
        grid.attach (icon, 0, 0, 1, 4);
        grid.attach (title, 1, 0, 1, 1);
        grid.attach (stats, 1, 1, 1, 1);
        grid.attach (pause, 2, 1, 1, 4);
        grid.attach (progress, 1, 2, 1, 1);
        grid.attach (state, 1, 3, 1, 1);
        add(grid);

        torrent.bind_property ("name", title, "label", BindingFlags.DEFAULT, null, (binding, srcval, ref targetval) => {
            targetval.set_string(torrent.title());
            return true;
        });
             
        show_all();
    }
}
