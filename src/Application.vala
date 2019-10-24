public class Application : Gtk.Application {
	private Main.Window? window = null;
	private Server.Controller serverController;
	public Gee.ArrayList<Server.Model> serversList;


	public Application () {
        Object (
            application_id: "com.github.popvladaurel.torrential-remote",
			flags: ApplicationFlags.HANDLES_OPEN
        );
	}

	construct {
		serverController = new Server.Controller ();
		serversList = serverController.all ();

		DesktopAppInfo appinfo = new DesktopAppInfo (get_application_id () + ".desktop");
		try {
			appinfo.set_as_last_used_for_type ("x-scheme-handler/magnet");
		} catch (Error e) {
			warning ("Unable to set self as default for magnet links: %s", e.message);
		}
	
		try {
			appinfo.set_as_last_used_for_type ("application/x-bittorrent");
		} catch (Error e) {
			warning ("Unable to set self as default for torrent files: %s", e.message);
		}      
	}

	protected override void activate () {
		if (serversList.size == 0) {
			Server.Dialog dialog = new Server.Dialog (serversList);
			dialog.set_parent (window);
			serversList = serverController.all ();
		}
		
		Main.Window window = new Main.Window (serversList);
		add_window (window);
	}

	public override void open (File[] files, string hint) {
		serversList = serverController.all ();

		if (serversList.size == 0) {
			Server.Dialog dialog = new Server.Dialog (serversList);
			dialog.set_parent (window);
			serversList = serverController.all ();
		}

        foreach (File file in files) {
            try {
                uint8[] contents;
                string etag_out;
				file.load_contents (null, out contents, out etag_out);
				Client.Model client = new Client.Model(serversList[0]);
				client.addFromFile (contents);
            } catch (Error e) {
				GLib.Application.get_default().send_notification(null, new Notification ("COULD NOT ADD TORRENT"));
            }
        }

        activate ();
    }
}
