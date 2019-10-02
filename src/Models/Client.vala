public errordomain MyError {
    INVALID_DATA
}

public class Models.Client : Object {

    private Json.Node root = new Json.Node (Json.NodeType.OBJECT);
    private Json.Object body = new Json.Object ();
    private Json.Generator generator = new Json.Generator ();
    private Json.Object arguments = new Json.Object ();
    private Json.Parser parser = new Json.Parser ();
    private Json.Array fields = new Json.Array ();
    private Soup.Session session = new Soup.Session();

    private Soup.Message message;
    private string sessionId;

    /* List of mandatory fields needed to render the Torrents Widget */
    private static string[] mandatory = {
        "id", "name", "eta", "status", "recheckProgress", "percentDone", "haveValid", "uploadedEver", "peersConnected",
        "peersSendingToUs", "peersGettingFromUs",  "rateDownload","rateUpload", "sizeWhenDone", "files", "error", "errorString",
    };

    public Client (Models.Server server) {
        this.message = new Soup.Message ("POST", server.url);
        this.sessionId = server.sessionId;
    }

    public GLib.List<weak Json.Node> all () {
        foreach (string field in mandatory) 
            fields.add_string_element (field);
        
        return send("torrent-get", null, fields);
    }

    private GLib.List<weak Json.Node> send (string method, Json.Array? ids, Json.Array? fields) {
        root.set_object (body);
        generator.set_root (root);

        if (ids != null) 
            arguments.set_array_member ("ids", ids);
        
        if (fields != null && fields.get_length () > 0) 
            arguments.set_array_member ("fields", fields);
        
        body.set_string_member ("method", method);
        body.set_object_member ("arguments", arguments);
        this.message.set_request ("text/html", Soup.MemoryUse.COPY, generator.to_data(null).data);
        this.message.request_headers.append ("X-Transmission-Session-Id", sessionId);
        session.send_message (message);
        //TODO treat Json.Parser errors here
        try {
            parser.load_from_data ((string) message.response_body.flatten ().data, -1);
        } catch (MyError.INVALID_DATA e) {
            stderr.printf("INVALID DATA");
        }

        return parser.get_root ().get_object ().get_object_member ("arguments").get_array_member ("torrents").get_elements ();   
    }
}