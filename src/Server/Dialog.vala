public class Server.Dialog : Granite.MessageDialog {

    public Dialog (Gee.ArrayList<Server.Model> serversList) {
        Object (
            primary_text : "Welcome to Torrential Remote!",
            secondary_text : "Start by connecting to a server.",
            image_icon : GLib.Icon.new_for_string ("application-default-icon"),
            buttons : Gtk.ButtonsType.NONE
        );

        set_modal (true);
        set_transient_for (null);
        add_buttons ("Cancel", Gtk.ResponseType.CANCEL, "Save", Gtk.ResponseType.ACCEPT, null);

        Gtk.Grid grid = new Gtk.Grid ();
        grid.set_column_spacing (10);
        grid.set_row_spacing (10);

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

        custom_bin.add (grid);
        
        get_widget_for_response (Gtk.ResponseType.ACCEPT).can_default = true;
        set_default_response (Gtk.ResponseType.ACCEPT);
        grid.show_all();


        int response = run ();
        if (response == Gtk.ResponseType.ACCEPT) {
            string name = nameEntry.text;
            string host = hostEntry.text;
            string port = portEntry.text;
            string path = pathEntry.text;
            string user = usernameEntry.text;
            string pass = passwordEntry.text;

            // TODO SAVE SERVER HERE
            Server.Model newServer = new Server.Model.for_saving (name, host, port, path, user, pass, true);
            Server.Controller serverController = new Server.Controller ();
            bool serverSaved = serverController.save (newServer);
        }

        destroy ();
    }
}


			