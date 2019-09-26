using Soup;
using Json;

public class TorrentialRemote.Transmission {
   private Session session;
   private string user;
   private string password;
   private string path;
   private string sessionid;
   private static string[] std_fields = { "id","name","eta","status","percentDone","haveValid", "uploadedEver","peersConnected","rateDownload","rateUpload","sizeWhenDone","files"};
   private static int[] std_ids = {42, 66};

   public Transmission(string host, int port, string? user, string? password) {
      if(user != null && password != null) {
         this.user = user; this.password = password;
      }
      path = @"http://$host:$port/transmission/rpc";
      session = new Session();
      //In case you setup Transmission with authentication this sets a callback for handling it
      session.authenticate.connect(auth);

      //Newer Transmission versions require a sessionid to be carried with each request. Get one!
      var msg = new Message("GET", path);
      session.send_message(msg);
      sessionid = msg.response_headers.get_one("X-Transmission-Session-Id");
      if(sessionid == null)
         error("Transmission version to old or not configured on that port");
   }

   public Json.Parser getTorrents() {

      Message msg = new Message("POST", path);
      //Start a Generator and setup some fields for it
      Generator gen = new Generator();
      var root = new Json.Node(NodeType.OBJECT);
      var object = new Json.Object();
      root.set_object(object);
      gen.set_root(root);

      var args = new Json.Object();
      object.set_object_member("arguments", args);
      object.set_string_member("method", "torrent-get");

      var fields = new Json.Array();
      foreach (string s in std_fields)
         fields.add_string_element(s);
      args.set_array_member("fields", fields);


      var ids = new Json.Array();
      foreach (int i in std_ids)
         ids.add_int_element(i);
      args.set_array_member("ids", ids);

      //Send the request json to the server and carry the sessionid along with the request
      // json = gen.to_data(null);

      msg.set_request("text/html", MemoryUse.COPY, gen.to_data(null).data);
      msg.request_headers.append("X-Transmission-Session-Id", sessionid);
      session.send_message(msg);

     
     //Setup a Parser and load the data from the transmission response
     var parser = new Json.Parser();
     parser.load_from_data((string) msg.response_body.flatten().data, -1);
     return parser;
         
         
   }
   private void auth(Message msg, Auth auth, bool retry) {
      if(user != null && password != null)
         auth.authenticate(user, password);
      else if(retry)
         error("Wrong username/password");
      else
         error("Transmission server requires authentication");

   }
}
