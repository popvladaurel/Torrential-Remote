public class TorrentialRemote.Connection : Gtk.Grid {
    public TorrentialRemote.Window window { get; construct;}

    public Connection (Window window) {
         Object (
             window: window
         );
     }

     construct {
        Gtk.Box box = new Gtk.Box (Gtk.Orientation.VERTICAL, 12);
        box.expand = true;
        box.margin = 100;
        box.margin_left = 200;
        box.margin_right = 200;

        // Save and Cancel buttons
        Gtk.ButtonBox buttonBox = new Gtk.ButtonBox(Gtk.Orientation.HORIZONTAL);
        Gtk.Button save = new Gtk.Button.with_label("Save");
        Gtk.Button cancel = new Gtk.Button.with_label("Cancel");
        cancel.clicked.connect(e => {
            window.showWelcome();
        });
        buttonBox.add(save);
        buttonBox.add(cancel);

        // Server name field
        Gtk.Entry nameEntry = new Gtk.Entry();
        nameEntry.set_placeholder_text("Name:");


        // Server address field
        Gtk.Entry addressEntry = new Gtk.Entry();
        addressEntry.set_placeholder_text("Address:");


        // Server port field
        Gtk.Entry portEntry = new Gtk.Entry();
        portEntry.set_placeholder_text("Port");


        box.add(nameEntry);
        box.add(addressEntry);
        box.add(portEntry);
        box.add(buttonBox);

        add(box);
    }
}
