public class Models.Server : Object {

   public string url { get; set; default = "http://localhost:9091/transmission/rpc";}
   public string path { get; set; default = "/transmission/rpc"; }
   public string host { get; set; default = "localhost"; }
   public int port { get; set; default = 9091; }
   public string user { get; set; default = "transmission"; }
   public string password { get; set; default = null; }
   public string sessionId { get; set; }

   public Server (string? host, int? port, string? user, string? password) {
      url = @"http://$host:$port$path";
      Soup.Session session = new Soup.Session();
      Soup.Message message = new Soup.Message("GET", url);
      session.authenticate.connect(auth);
      session.send_message(message);
      sessionId = message.response_headers.get_one("X-Transmission-Session-Id");
   }

   private void auth (Soup.Message msg, Soup.Auth auth, bool retry) {
      if (user != null && password != null)
         auth.authenticate(user, password);
      else if (retry)
         error("Wrong username/password");
      else
         error("Transmission server requires authentication");
   }
}