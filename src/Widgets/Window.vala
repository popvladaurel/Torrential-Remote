public class Window : Gtk.ApplicationWindow {

	public Settings settings;
	public Widgets.HeaderBar headerBar;
	private Gtk.Box box;
	private Gtk.ScrolledWindow scroll;

	construct {
		headerBar = new Widgets.HeaderBar (this);
		scroll = new Gtk.ScrolledWindow(null, null);
		box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
		settings = new Settings ("com.github.popvladaurel.torrential-remote");

		move (settings.get_int ("window-pos-x"), settings.get_int ("window-pos-y"));
		resize (settings.get_int ("window-width"), settings.get_int ("window-height"));

		delete_event.connect (e => {
	 		return before_destroy ();
		});
	}

	public Window () {
		Widgets.Torrents torrents = new Widgets.Torrents();
		
		box.add(torrents);
		scroll.add(box);
		add(scroll);
		set_titlebar(headerBar);
		show_all();

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
