public class TorrentialRemote.Window : Gtk.ApplicationWindow {

	public Settings settings;
	public HeaderBar headerBar;

	public Window (Application application) {
		Object (
			application: application
		);
	}

	construct {
		settings = new Settings ("com.github.popvladaurel.torrential-remote");
		headerBar = new HeaderBar ();

		set_titlebar(headerBar);
		move (settings.get_int ("window-pos-x"), settings.get_int ("window-pos-y"));
		resize (settings.get_int ("window-width"), settings.get_int ("window-height"));

		delete_event.connect (e => {
	 		return before_destroy ();
	 	});

	 	show_all ();
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
}
