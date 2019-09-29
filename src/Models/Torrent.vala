public class TorrentialRemote.Models.Torrent : Object {

    public enum statuses {
        STOPPED        = 0, /* Torrent is stopped */
        CHECK_WAIT     = 1, /* Queued to check files */
        CHECK          = 2, /* Checking files */
        DOWNLOAD_WAIT  = 3, /* Queued to download */
        DOWNLOAD       = 4, /* Downloading */
        SEED_WAIT      = 5, /* Queued to seed */
        SEED           = 6  /* Seeding */
    }
    
    // Torrent name.
    public string name { get; set; }
    
    // Last time of upload or download activity.
    private int64 activityDate { get; set; } 
    
    // The date when this torrent was first added.
    private int64 addedDate { get; set; }  
    
    // Torrent creation date.
    private int64 dateCreated { get; set; } 

    // The date when the torrent finished downloading.   
    private int64 doneDate { get; set; }
    
    // Estimated number of seconds left when downloading or seeding. -1 means not available and -2 means unknown.
    private int64 eta { get; set; }  
    
    // Array of file object containing key, bytesCompleted, length and name.
    private Json.Array files { get; set; } 
    
    // Session unique torrent id.
    private int64 id { get; set; }  
    
    // True if the torrent is finished. Downloaded and seeded.
    private bool isFinished { get; set; }
    
    // True if the torrent has stalled - been idle for a long time.
    private bool isStalled { get; set; }  
    
    // Number of bytes left until the download is done.
    private int64 leftUntilDone { get; set; }
    
    // Array of peer objects.
    private Json.Array peers { get; set; }
    
    // Number of peers we are connected to.
    private int64 peersConnected { get; set; } 
    
    // Number of peers we are sending data to.
    private int64 peersGettingFromUs { get; set; } 

    // Number of peers sending to us
    private int64 peersSendingToUs { get; set; }
    
    // Download progress of selected files. 0.0 to 1.0.
    private double percentDone { get; set; } 
    
    // Download rate in bps.
    private int64 rateDownload { get; set; } 
    
    // Upload rate in bps.
    private int64 rateUpload { get; set; }
    
    // Progress of recheck. 0.0 to 1.0.
    private double recheckProgress { get; set; } 

    // Size of the torrent download in bytes.
    private int64 sizeWhenDone { get; set; } 

    // Number of bytes of checksum verified data.
    private int64 haveValid { get; set; }
    
    // Current status, see source
    public int64 status { get; set; }
    
    public class Torrent(Json.Object torrent) {
        id = torrent.get_int_member("id");
        eta = torrent.get_int_member("eta");
        name = torrent.get_string_member("name");
        files = torrent.get_array_member("files");
        peers = torrent.get_array_member("peers");
        status = torrent.get_int_member("status");
        doneDate = torrent.get_int_member("doneDate");
        addedDate = torrent.get_int_member("addedDate");
        addedDate = torrent.get_int_member("addedDate");
        haveValid = torrent.get_int_member("haveValid");
        rateUpload = torrent.get_int_member("rateUpload");
        isStalled = torrent.get_boolean_member("isStalled");
        rateDownload = torrent.get_int_member("rateDownload");
        sizeWhenDone = torrent.get_int_member("sizeWhenDone");
        percentDone = torrent.get_double_member("percentDone");
        activityDate = torrent.get_int_member("activityDate");
        isFinished = torrent.get_boolean_member("isFinished");
        leftUntilDone = torrent.get_int_member("leftUntilDone");
        peersConnected = torrent.get_int_member("peersConnected");
        peersSendingToUs = torrent.get_int_member("peersSendingToUs");
        recheckProgress = torrent.get_double_member("recheckProgress");
        peersGettingFromUs = torrent.get_int_member("peersGettingFromUs");

        Timeout.add(1000, refresh);
    }

    public string title () {
        return name;
    }

    public string stats () {
        return "stats";
    }

    public double progress () {
        return percentDone;
    }

    public string state () {
        return "state";
    }

    public bool refresh () {
        name = GLib.Uuid.string_random ();
        return true;
    }
}