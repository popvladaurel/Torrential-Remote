public class Window : Gtk.ApplicationWindow {

	public Settings settings;
	public Widgets.HeaderBar headerBar;
	private Gtk.Box box;
	private Gtk.ScrolledWindow scroll;
	public Models.Server server;
	public bool dark_theme { get; set; }

	construct {
		scroll = new Gtk.ScrolledWindow(null, null);
		box = new Gtk.Box (Gtk.Orientation.HORIZONTAL, 0);
		settings = new Settings ("com.github.popvladaurel.torrential-remote");

		move (settings.get_int ("window-pos-x"), settings.get_int ("window-pos-y"));
		resize (settings.get_int ("window-width"), settings.get_int ("window-height"));
		dark_theme = settings.get_boolean ("dark-theme");
		headerBar = new Widgets.HeaderBar (this);

		delete_event.connect (e => {
	 		return before_destroy ();
		});

		server = new Models.Server ("192.168.100.101", 9091, null, null);
	}

	public Window () {
		Gtk.Paned paned = new Gtk.Paned(Gtk.Orientation.HORIZONTAL);

		Gtk.Box box = new Gtk.Box (Gtk.Orientation.VERTICAL, 0);
		Granite.Widgets.SourceList servers = new Granite.Widgets.SourceList ();
		servers.vexpand = true;
		servers.set_margin_start(5);

		//TODO generate an item for each server
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
			Gtk.DialogFlags flags = Gtk.DialogFlags.MODAL | Gtk.DialogFlags.DESTROY_WITH_PARENT;
 			Gtk.Dialog dialog = new Gtk.Dialog.with_buttons (
				null,
				this,
				flags,
				"Cancel",
				Gtk.ResponseType.CANCEL,
				"Save",
				Gtk.ResponseType.ACCEPT,
				null
			);

			Gtk.Grid grid = new Gtk.Grid ();
			grid.set_column_spacing (10);
			grid.set_row_spacing (10);

			Gtk.Image icon = new Gtk.Image.from_icon_name ("application-default-icon", Gtk.IconSize.DIALOG);
			icon.set_halign(Gtk.Align.END);
			icon.set_pixel_size (64);
			grid.attach(icon, 0, 0, 1, 1);

			Gtk.Label welcome = new Gtk.Label ("");
			welcome.set_markup ("<span size=\"larger\"><b>Welcome to Torrential Remote!</b>\n</span><span>Start by connecting to a server.</span>");
			welcome.set_halign(Gtk.Align.START);
			grid.attach(welcome, 1, 0, 3, 1);

			Gtk.Entry nameEntry = new Gtk.Entry ();
			nameEntry.set_hexpand (true);
			Gtk.Label nameLabel = new Gtk.Label ("Name:");
			nameLabel.set_halign(Gtk.Align.END);
			grid.attach(nameLabel, 0, 1, 1, 1);
			grid.attach(nameEntry, 1, 1, 3, 1);

			Gtk.Entry hostEntry = new Gtk.Entry ();
			hostEntry.set_hexpand (true);
			Gtk.Label hostLabel = new Gtk.Label ("Host:");
			hostLabel.set_halign(Gtk.Align.END);;
			grid.attach(hostLabel, 0, 2, 1, 1);
			grid.attach(hostEntry, 1, 2, 3, 1);

			Gtk.SpinButton portEntry = new Gtk.SpinButton.with_range (0, 9999999, 1);
			portEntry.set_hexpand (true);
			portEntry.set_value(9091);
			Gtk.Label portLabel = new Gtk.Label ("Port:");
			portLabel.set_halign(Gtk.Align.END);;
			grid.attach(portLabel, 0, 3, 1, 1);
			grid.attach(portEntry, 1, 3, 3, 1);

			Gtk.Entry pathEntry = new Gtk.Entry ();
			pathEntry.set_hexpand (true);
			pathEntry.set_text ("/transmission/rpc");
			Gtk.Label pathLabel = new Gtk.Label ("Path:");
			pathLabel.set_halign(Gtk.Align.END);;
			grid.attach(pathLabel, 0, 4, 1, 1);
			grid.attach(pathEntry, 1, 4, 3, 1);

			Gtk.Entry usernameEntry = new Gtk.Entry ();
			usernameEntry.set_hexpand (true);
			Gtk.Label usernameLabel = new Gtk.Label ("Username:");
			usernameLabel.set_halign(Gtk.Align.END);;
			grid.attach(usernameLabel, 0, 5, 1, 1);
			grid.attach(usernameEntry, 1, 5, 3, 1);

			Gtk.Entry passwordEntry = new Gtk.Entry ();
			passwordEntry.set_hexpand (true);
			passwordEntry.set_visibility (false);
			Gtk.Label passwordLabel = new Gtk.Label ("Password:");
			passwordLabel.set_halign(Gtk.Align.END);;
			grid.attach(passwordLabel, 0, 6, 1, 1);
			grid.attach(passwordEntry, 1, 6, 3, 1);

			dialog.get_content_area ().pack_start (grid);
			dialog.get_content_area ().set_center_widget (grid);
			
			dialog.width_request = 500;
        	dialog.get_content_area ().spacing = 10;
        	dialog.get_content_area ().border_width = 25;
			dialog.get_widget_for_response (Gtk.ResponseType.OK).can_default = true;
			dialog.set_default_response (Gtk.ResponseType.ACCEPT);
			dialog.show_all();
			
			GLib.Application.get_default().send_notification(null, new Notification ("TODO: NOT YET IMPLEMENTED"));
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
					
		Widgets.Torrents torrents = new Widgets.Torrents(this);
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
