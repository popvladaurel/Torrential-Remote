public class Client.Model : Object {

    public string sessionId { get; set; }
    public string url { get; set; }

    /* List of mandatory fields needed to render the Torrents Widget */
    private static string[] mandatory = {
        "id", "name", "eta", "status", "recheckProgress", "percentDone", "haveValid", "uploadedEver", "peersConnected",
        "peersSendingToUs", "peersGettingFromUs",  "rateDownload","rateUpload", "sizeWhenDone", "files", "error", "errorString",
    };

    //  private static int[] idx = {23, 42, 74, 75, 76, 77};

    public Model (Server.Model server) {
        Object (
            url: server.url,
            sessionId: server.sessionId
        );
    }

    public Json.Array all () {
        Soup.Session session = new Soup.Session ();
        Soup.Message message = new Soup.Message ("POST", url);
        Json.Node root = new Json.Node (Json.NodeType.OBJECT);
        Json.Generator generator = new Json.Generator ();
        Json.Object arguments = new Json.Object ();
        Json.Object body = new Json.Object ();
        Json.Parser parser = new Json.Parser ();
        root.set_object (body);
        generator.set_root (root);

        Json.Array fields = new Json.Array ();
        foreach (string field in mandatory) 
            fields.add_string_element (field);

        //  Json.Array ids = new Json.Array ();
        //  foreach (int id in idx) 
        //      ids.add_int_element (id);
        
        arguments.set_array_member ("fields", fields);
        //  arguments.set_array_member ("ids", ids);

        body.set_string_member ("method", "torrent-get");
        body.set_object_member ("arguments", arguments);
        message.set_request ("text/html", Soup.MemoryUse.COPY, generator.to_data(null).data);
        message.request_headers.append ("X-Transmission-Session-Id", sessionId);
        session.send_message (message);

        try {
            parser.load_from_data ((string) message.response_body.flatten ().data, -1);
        } catch (Error e) {
            print ("Unable to parse data: %s\n", e.message);
            return new Json.Array();
        }
        
        root = parser.get_root ();
        body = root.get_object ();
        if (body.has_member ("arguments")) {
            arguments = body.get_object_member ("arguments");
            if (arguments.has_member ("torrents")) {
                return arguments.get_array_member ("torrents");
            }
            
        }

        return new Json.Array();
    }

    public void addFromMagnet (string link) {
        Soup.Message message = new Soup.Message ("POST", url);
        Json.Node root = new Json.Node (Json.NodeType.OBJECT);
        Json.Generator generator = new Json.Generator ();
        Soup.Session session = new Soup.Session ();
        Json.Object arguments = new Json.Object ();
        Json.Object body = new Json.Object ();

        root.set_object (body);
        generator.set_root (root);
        
        arguments.set_string_member("filename", link);
        body.set_string_member ("method", "torrent-add");
        body.set_object_member ("arguments", arguments);
        message.set_request ("text/html", Soup.MemoryUse.COPY, generator.to_data(null).data);
        message.request_headers.append ("X-Transmission-Session-Id", sessionId);
        session.send_message (message);
    }

    public void addFromFile (uint8[] file) {
        Soup.Message message = new Soup.Message ("POST", url);
        Json.Node root = new Json.Node (Json.NodeType.OBJECT);
        Json.Generator generator = new Json.Generator ();
        Soup.Session session = new Soup.Session ();
        Json.Object arguments = new Json.Object ();
        Json.Object body = new Json.Object ();

        root.set_object (body);
        generator.set_root (root);
        
        arguments.set_string_member("metainfo", Base64.encode(file));
        body.set_string_member ("method", "torrent-add");
        body.set_object_member ("arguments", arguments);
        message.set_request ("text/html", Soup.MemoryUse.COPY, generator.to_data(null).data);
        message.request_headers.append ("X-Transmission-Session-Id", sessionId);
        session.send_message (message);
    }
}