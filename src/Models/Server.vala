public class Models.Server : Object {

   public string name { get; set; default = "Default"; }
   public string host { get; set; default = "localhost"; }
   public string port { get; set; default = "9091"; }
   public string path { get; set; default = "/transmission/rpc"; }
   public string user { get; set; default = "transmission"; }
   public string pass { get; set; default = null; }
   public bool auto { get; set; default = false; }
   public int number = 5;

   private string _url;
   private string _sessionId;

   public Server () {
      //  url = @"http://$host:$port$path";
      Soup.Session session = new Soup.Session();
      Soup.Message message = new Soup.Message("GET", url);
      session.authenticate.connect(auth);
      session.send_message(message);
      sessionId = message.response_headers.get_one("X-Transmission-Session-Id");
   }

   public Server.for_saving (string? newName, string? newHost, string? newPort, string? newPath, string? newUser, string? newPass, bool newAuto) {
      name = newName;
      host = newHost;
      port = newPort;
      path = newPath;
      user = newUser;
      pass = newPass;
      auto = newAuto;
   }

   private void auth (Soup.Message msg, Soup.Auth auth, bool retry) {
      if (user != null && pass != null)
         auth.authenticate(user, pass);
      else if (retry)
         stdout.printf ("Wrong username/password");
      else
         stdout.printf ("Transmission server requires authentication");
   }

   public string sessionId {
      get { return _sessionId; }
      set { _sessionId = value; }
   }

   public string url {
      get { return _url; }
      set { _url = value; }
      default = "http://localhost:9091/transmission/rpc";
   }
}