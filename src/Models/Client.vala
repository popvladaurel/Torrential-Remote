public class TorrentialRemote.Models.Client : Object {

    Json.Node root;
    Json.Object body;
    Soup.Message message;
    Json.Generator generator;
    Json.Object arguments ;
    Json.Parser parser;
    Json.Array fields;
    string sessionId;
    Soup.Session session;

    /* List of mandatory fields needed to render the Torrents Widget */
    public static string[] mandatory = {
        "id", "name", "eta", "status", "recheckProgress", "percentDone",
        "haveValid", "uploadedEver", "peersConnected", "rateDownload",
        "rateUpload", "sizeWhenDone", "files"
    };

    public Client (Models.Server server) {
        session = new Soup.Session();
        generator = new Json.Generator ();
        message = new Soup.Message ("POST", server.url);
        body = new Json.Object ();
        arguments = new Json.Object ();
        parser = new Json.Parser ();
        root = new Json.Node (Json.NodeType.OBJECT);
        fields = new Json.Array ();
        sessionId = server.sessionId;
    }

    public GLib.List<weak Json.Node> all () {
        foreach (string field in mandatory) 
            fields.add_string_element(field);
        
        return send("torrent-get", null, fields);
    }


    private GLib.List<weak Json.Node> send (string method, Json.Array? ids, Json.Array? fields) {
        root.set_object (body);
        generator.set_root (root);

        if (ids != null) 
            arguments.set_array_member("ids", ids);
        
        if (fields != null && fields.get_length() > 0) 
            arguments.set_array_member("fields", fields);
        
        body.set_string_member ("method", method);
        body.set_object_member ("arguments", arguments);
        message.set_request("text/html", Soup.MemoryUse.COPY, generator.to_data(null).data);
        message.request_headers.append("X-Transmission-Session-Id", sessionId);
        session.send_message(message);
        parser.load_from_data((string) message.response_body.flatten().data, -1);

        return parser.get_root().get_object().get_object_member("arguments").get_array_member("torrents").get_elements();
    }
}