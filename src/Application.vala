public class Application : Gtk.Application {

	public Application () {
        Object (
            application_id: "com.github.popvladaurel.torrential-remote",
            flags: ApplicationFlags.FLAGS_NONE
        );
	}

	protected override void activate () {
		Window window = new Window ();

		add_window (window);
	}
}
