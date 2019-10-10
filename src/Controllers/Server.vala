class Controllers.Server : Object {
    string location;
    File folder;
    File file;
    FileOutputStream stream;
    DataOutputStream data;

    public Server() {
        
        
    }

    construct {
        location = GLib.Environment.get_user_config_dir() + "/com.github.popvladaurel.torrential-remote";
        folder = File.new_for_path(location);
        if (!folder.query_exists ())
            folder.make_directory();
        file = folder.get_child ("servers.json");
        if (!file.query_exists ()) {
            stream = file.create (FileCreateFlags.NONE);
            //  data = new DataOutputStream (stream);
            //  data.put_string("SOME DATA HERE");
        }
    }

    public void all () {
        
    }

    public void show () {

    }

    public void create () {

    }

    public void save () {

    }

    public void edit () {

    }

    public void update () {

    }
}