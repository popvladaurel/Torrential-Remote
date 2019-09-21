public class Application : Gtk.Application {

	public Application () {
        Object (
            application_id: "com.github.popvladaurel.torrential-remote",
            flags: ApplicationFlags.FLAGS_NONE
        );
	}

	protected override void activate () {
		TorrentialRemote.Window window = new TorrentialRemote.Window (this);

		add_window (window);
	}
}
