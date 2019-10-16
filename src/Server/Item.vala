public class Server.Item : Granite.Widgets.SourceList.Item {
	Gtk.Menu  menu = new Gtk.Menu ();
	public Server.Model server;

	public Item (Server.Model server) {
		this.server = server;
		icon = new ThemedIcon("network-server");
		name = server.name;
		buildMenu(server);
	}

	public override Gtk.Menu? get_context_menu () {
		return menu;
	}

	public void buildMenu (Server.Model server) {
		
		Gtk.MenuItem edit = new Gtk.MenuItem ();
		edit.set_label ("Edit");
		edit.activate.connect (() => {
			GLib.Application.get_default().send_notification(null, new Notification ("TODO: NOT YET IMPLEMENTED"));
		});
		menu.add (edit);

		Gtk.MenuItem remove = new Gtk.MenuItem ();
		remove.set_label ("Delete");
		remove.activate.connect (() => {
			Server.Controller serverController = new Server.Controller ();
			serverController.delete (server);
		});

		menu.add (remove);
		menu.show_all ();
    }
}