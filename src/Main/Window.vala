public class Main.Window : Gtk.ApplicationWindow {

	public Settings settings;
	public Main.HeaderBar headerBar;
	private Gtk.Box box;
	private Gtk.ScrolledWindow scroll;
	public Server.Model server;
	public bool dark_theme { get; set; }

	construct {
		scroll = new Gtk.ScrolledWindow(null, null);
		box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
		settings = new Settings ("com.github.popvladaurel.torrential-remote");

		move (settings.get_int ("window-pos-x"), settings.get_int ("window-pos-y"));
		resize (settings.get_int ("window-width"), settings.get_int ("window-height"));
		dark_theme = settings.get_boolean ("dark-theme");
		headerBar = new Main.HeaderBar (this);

		delete_event.connect (e => {
	 		return before_destroy ();
		});
	}

	public Window (Gee.ArrayList<Server.Model> serversList) {
		Gtk.Paned paned = new Gtk.Paned(Gtk.Orientation.HORIZONTAL);

		Gtk.Box box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
		Granite.Widgets.SourceList servers = new Granite.Widgets.SourceList ();
		servers.vexpand = true;
		servers.set_margin_start(5);

		//TODO generate an item for each server
		foreach (Server.Model server in serversList) {
			Granite.Widgets.SourceList.Item serverEntry = new Granite.Widgets.SourceList.Item (server.name);
			serverEntry.icon = new ThemedIcon("network-server");
			servers.root.add(serverEntry);
		}
		
		box.pack_start(servers, true, true, 0);

		Gtk.ActionBar actions = new Gtk.ActionBar();
		Gtk.Button plus = new Gtk.Button.from_icon_name ("list-add", Gtk.IconSize.SMALL_TOOLBAR);

		plus.clicked.connect (() => {
			Server.Controller serverController = new Server.Controller ();
			Server.View dialog = new Server.View (serversList);
			//  serversList = serverController.all ();
		});

		Gtk.Button minus = new Gtk.Button.from_icon_name ("list-remove", Gtk.IconSize.SMALL_TOOLBAR);

		minus.clicked.connect (() => {
			//Remove the selected server
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
					
		Main.Torrents torrents = new Main.Torrents(serversList.get (0));
		scroll.add(torrents);
		paned.pack2(scroll, false, false);
		set_titlebar(headerBar);
		add(paned);
		show_all();
		Gtk.Settings.get_default ().gtk_application_prefer_dark_theme = dark_theme;


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
		settings.set_boolean ("dark-theme", dark_theme);

		return false;
	}
}
