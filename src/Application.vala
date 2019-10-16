public class Application : Gtk.Application {
	private Main.Window? window = null;
	private Server.Controller serverController = new Server.Controller ();
	public Gee.ArrayList<Server.Model> serversList;


	public Application () {
        Object (
            application_id: "com.github.popvladaurel.torrential-remote",
			flags: ApplicationFlags.HANDLES_OPEN
        );
	}

	construct {
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
		serversList = serverController.all ();
		if (serversList.size == 0) {
			Server.View dialog = new Server.View (serversList);
			dialog.set_parent (window);
			serversList = serverController.all ();
		}
		
		Main.Window window = new Main.Window (serversList);
		add_window (window);
	}

	public override void open (File[] files, string hint) {
		//  Server.Model server = new Server.Model ("192.168.100.101", 9091, null, null);

        foreach (File file in files) {
            try {
                uint8[] contents;
                string etag_out;
				file.load_contents (null, out contents, out etag_out);
				//  Client.Model client = new Client.Model(server);
				//  client.addFromFile (contents);
            } catch (Error e) {
				GLib.Application.get_default().send_notification(null, new Notification ("COULD NOT ADD TORRENT"));
            }
        }

        activate ();
    }
}
