public class Server.Model : Object {

   public string name { get; set; default = "Default"; }
   public string host { get; set; default = "xxxxx"; }
   public string port { get; set; default = "9091"; }
   public string path { get; set; default = "/transmission/rpc"; }
   public string user { get; set; default = "transmission"; }
   public string pass { get; set; default = ""; }
   public bool auto { get; set; default = false; }
   public int number = 5;

   public string url { get; set; }
   public string sessionId { get; set; }

   public Model () {
      Soup.Session session = new Soup.Session();
      Soup.Message message = new Soup.Message("GET", "http://192.168.100.101:9091/transmission/rpc");
      session.authenticate.connect(auth);
      session.send_message(message);
      sessionId = message.response_headers.get_one("X-Transmission-Session-Id");
   }

   public Model.for_saving (string? newName, string? newHost, string? newPort, string? newPath, string? newUser, string? newPass, bool newAuto) {
      name = newName;
      host = newHost;
      port = newPort;
      path = newPath;
      user = newUser;
      pass = newPass;
      auto = newAuto;
      url = @"http://$host:$port$path";

   }

   private void auth (Soup.Message msg, Soup.Auth auth, bool retry) {
      if (user != null && pass != null)
         auth.authenticate(user, pass);
      else if (retry)
         stdout.printf ("Wrong username/password");
      else
         stdout.printf ("Transmission server requires authentication");
   }
}