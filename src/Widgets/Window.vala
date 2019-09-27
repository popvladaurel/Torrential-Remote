public class TorrentialRemote.Window : Gtk.ApplicationWindow {

	public Settings settings;
	public HeaderBar headerBar;
	private Gtk.Box box;
	private Gtk.ScrolledWindow scroll;

	public Window (Application application) {
		Object (
			application: application
		);
	}

	construct {
		headerBar = new HeaderBar (this);
		set_titlebar(headerBar);

		scroll = new Gtk.ScrolledWindow(null, null);
        box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);

		settings = new Settings ("com.github.popvladaurel.torrential-remote");
		move (settings.get_int ("window-pos-x"), settings.get_int ("window-pos-y"));
		resize (settings.get_int ("window-width"), settings.get_int ("window-height"));

		delete_event.connect (e => {
	 		return before_destroy ();
		 });

		scroll.add(box);
		add(scroll);

	 	if (!serverSaved()) {
			Timeout.add(1000, showTorrents);
	 	}
	}

	public bool before_destroy () {
		int width, height, x, y;

		get_size (out width, out height);
		get_position (out x, out y);

		settings.set_int ("window-pos-x", x);
		settings.set_int ("window-pos-y", y);
		settings.set_int ("window-width", width);
		settings.set_int ("window-height", height);

		return false;
	}

	public bool showTorrents () {
		cleanBox();
		Torrents torrents = new Torrents(this);
		box.add(torrents);
		show_all();
		return true;
	}

	public void showConnection () {
	    cleanBox();
		application.send_notification(null, new Notification ("showing connections"));
		Connection connection = new Connection(this);
		box.add(connection);
		show_all();
	}

	public void showWelcome () {
	    cleanBox();
		application.send_notification(null, new Notification ("showing welcome"));
        Welcome welcome = new Welcome (this);
		box.add(welcome);
		show_all();
	}

	public void cleanBox() {
        List<Gtk.Widget> children = box.get_children();
        foreach (Gtk.Widget element in children) {
            box.remove(element);
        }
    }

    //TODO Implement verifcation for saved torrent settings
    public bool serverSaved () {
        return false;
    }

}
