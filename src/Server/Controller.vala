class Server.Controller : Object {
    File serversFile;
    File configFolder;
    string configLocation;

    construct {
        configLocation = GLib.Environment.get_user_config_dir() + "/com.github.popvladaurel.torrential-remote";
        configFolder = File.new_for_path(configLocation);
        if (!configFolder.query_exists ()) {
            configFolder.make_directory(); 
        }
        
        serversFile = configFolder.get_child ("servers.json");
        if (!serversFile.query_exists ()) {
            serversFile.create (FileCreateFlags.NONE);
        }
    }

    public Gee.ArrayList<Server.Model> all () {
        return readServers ();
    }

    public void show () {

    }

    public void create () {

    }

    public bool save (Server.Model newServer) {
        Gee.ArrayList<Server.Model> serversList = readServers ();
        serversList.add (newServer);
        return writeServers (serversList);
    }

    public void edit () {

    }

    public void update () {

    }

    private Gee.ArrayList<Server.Model> readServers () {
        Gee.ArrayList<Server.Model> serversList = new Gee.ArrayList<Server.Model> ();

        try {
            Json.Parser jsonParser = new Json.Parser ();
            jsonParser.load_from_stream (serversFile.read ());
            Json.Node? jsonNode = jsonParser.get_root ();
            Json.Array? jsonArray = jsonNode.get_array ();
            foreach (Json.Node serverJson in jsonArray.get_elements ()) {
                Server.Model server = new Server.Model ();
                Json.Reader jsonReader = new Json.Reader (serverJson);
                foreach (string serverProperty in jsonReader.list_members ()) {
                    switch (serverProperty) {
                        case "name":
                        case "host":
                        case "post":
                        case "path":
                        case "user":
                        case "pass":
                        case "url":
                            if (jsonReader.read_member (serverProperty) == true && jsonReader.is_value ()) {
                                server.@set (serverProperty, jsonReader.get_string_value ());
                                jsonReader.end_member ();
                            }
                            break;
                    default:
                        break;
                    }
                }
                jsonReader.end_member ();
                serversList.add (server);
            }   
        } catch (Error e) {
            warning ("Unable to parse `%s': %s\n", serversFile.get_basename (), e.message);
        }

        return serversList;
    }

    private bool writeServers (Gee.ArrayList<Server.Model> serversList) {
        Json.Builder builder = new Json.Builder ();
        builder.begin_array ();

        serversList.foreach ((server) => {
            Json.Node node = Json.gobject_serialize (server);
            builder.add_value (node);
            return true;
        });

        builder.end_array ();

        Json.Generator generator = new Json.Generator ();
        generator.set_root (builder.get_root ());
        generator.pretty = true;

        return generator.to_file (serversFile.get_path ());
    }
}