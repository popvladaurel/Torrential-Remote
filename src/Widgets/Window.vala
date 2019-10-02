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
		Gtk.Paned paned = new Gtk.Paned(Gtk.Orientation.HORIZONTAL);

		Gtk.Box box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
		Granite.Widgets.SourceList servers = new Granite.Widgets.SourceList ();
		servers.vexpand = true;
		servers.margin_left = 5;


		//TODO generate an item for each server
		Granite.Widgets.SourceList.Item  server1 = new Granite.Widgets.SourceList.Item ("Server1");

		int i = 1;
		while (i < 5) {
			Granite.Widgets.SourceList.Item server = new Granite.Widgets.SourceList.Item ("Server %i".printf(i));
			server.icon = new ThemedIcon("network-server");
			servers.root.add(server);
			i++;
		}
		
		box.pack_start(servers, true, true, 0);

		Gtk.ActionBar actions = new Gtk.ActionBar();
		//  Gtk.Box actions = new Gtk.Box(Gtk.Orientation.HORIZONTAL, 0);
		Gtk.Button plus = new Gtk.Button.from_icon_name ("list-add", Gtk.IconSize.SMALL_TOOLBAR);

		plus.clicked.connect (() => {
			GLib.Application.get_default().send_notification(null, new Notification ("TODO: NOT YET IMPLEMENTED"));
		});

		Gtk.Button minus = new Gtk.Button.from_icon_name ("list-remove", Gtk.IconSize.SMALL_TOOLBAR);

		minus.clicked.connect (() => {
			GLib.Application.get_default().send_notification(null, new Notification ("TODO: NOT YET IMPLEMENTED"));
		});

		actions.pack_start(plus);
		actions.pack_start(minus);

		//  action.add(actions);

		box.pack_end(actions, false, true, 0);


		//TODO restore pane position from gsettings
		paned.position = 150;
		paned.wide_handle = true;
		paned.pack1 (box, false, false);
					
		Widgets.Torrents torrents = new Widgets.Torrents();
		scroll.add(torrents);
		paned.pack2(scroll, false, false);
		set_titlebar(headerBar);
		add(paned);
		show_all();

	}

	public bool before_destroy () {
		int width, height, x, y;

		get_size (out width, out height);
		get_position (out x, out y);
		//TODO get pane position and save it

		settings.set_int ("window-pos-x", x);
		settings.set_int ("window-pos-y", y);
		settings.set_int ("window-width", width);
		settings.set_int ("window-height", height);

		return false;
	}
}
