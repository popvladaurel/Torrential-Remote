public class Models.Torrent : Object {

    // The Json.Object received from the server.
    public Json.Object torrent { get; set; }
    
    // Torrent name.
    public string name { get; set; }
    
    // Last time of upload or download activity.
    private int activityDate { get; set; } 
    
    // The date when this torrent was first added.
    private int addedDate { get; set; }  
    
    // Torrent creation date.
    private int dateCreated { get; set; } 

    // The date when the torrent finished downloading.   
    private int doneDate { get; set; }
    
    // Estimated number of seconds left when downloading or seeding. -1 means not available and -2 means unknown.
    private uint eta { get; set; }  
    
    // Array of file object containing key, bytesCompleted, length and name.
    private Json.Array files { get; set; } 
    
    // Session unique torrent id.
    public int id { get; set; }  
    
    // True if the torrent is finished. Downloaded and seeded.
    private bool isFinished { get; set; }
    
    // True if the torrent has stalled - been idle for a long time.
    private bool isStalled { get; set; }  
    
    // Number of bytes left until the download is done.
    private uint leftUntilDone { get; set; }

    // Number of total bytes uploaded.
    private uint uploadedEver { get; set; }
    
    // Array of peer objects.
    private Json.Array peers { get; set; }
    
    // Number of peers we are connected to.
    private int peersConnected { get; set; } 
    
    // Number of peers we are sending data to.
    private int peersGettingFromUs { get; set; } 

    // Number of peers sending to us
    private int peersSendingToUs { get; set; }
    
    // Download progress of selected files. 0.0 to 1.0.
    public double percentDone { get; set; } 
    
    // Download rate in bps.
    private uint rateDownload { get; set; } 
    
    // Upload rate in bps.
    private uint rateUpload { get; set; }
    
    // Progress of recheck. 0.0 to 1.0.
    public double recheckProgress { get; set; } 

    // Size of the torrent download in bytes.
    private uint sizeWhenDone { get; set; } 

    // Number of bytes of checksum verified data.
    private uint haveValid { get; set; }
    
    // Current status, see source
    public int status { get; set; }

    public int error { get; set; }
    public string errorString { get; set; }
    
    public class Torrent(Json.Object? torrent) {
        this.torrent = torrent;
        id = getInteger ("id");
        eta = getInteger64 ("eta");
        name = getString ("name");
        files = getArray ("files");
        peers = getArray ("peers");
        status = getInteger ("status");
        doneDate = getInteger ("doneDate");
        addedDate = getInteger ("addedDate");
        addedDate = getInteger ("addedDate");
        haveValid = getInteger64 ("haveValid");
        rateUpload = getInteger64 ("rateUpload");
        isStalled = getBoolean ("isStalled");
        uploadedEver = getInteger ("uploadedEver");
        activityDate = getInteger ("activityDate");
        isFinished = getBoolean ("isFinished");
        rateDownload = getInteger64 ("rateDownload");
        sizeWhenDone = getInteger64 ("sizeWhenDone");
        percentDone = getDouble ("percentDone");
        leftUntilDone = getInteger64 ("leftUntilDone");
        peersConnected = getInteger ("peersConnected");
        peersSendingToUs = getInteger ("peersSendingToUs");
        recheckProgress = getDouble ("recheckProgress");
        peersGettingFromUs = getInteger ("peersGettingFromUs");
        error = getInteger ("error");
        errorString = getString ("errorString");
    }

    public GLib.Icon icon () {
        if (files.get_length() > 1) {
            return ContentType.get_icon ("inode/directory");
        } else {
            if (files != null && files.get_length() > 0) {
               bool certain = false;
               var content_type = ContentType.guess (files.get_object_element(0).get_string_member("name"), null, out certain);
               return ContentType.get_icon (content_type);
            }
        }

        return ContentType.get_icon ("application/x-bittorrent");
    }

    public string title () {
        return name;
    }

    public string stats () {
        switch (status) {
            case 0:
                return "%s of %s".printf (format_size (haveValid), format_size (sizeWhenDone)
                );
            case 4:
                return "%s of %s — %s remaining".printf (format_size (haveValid), format_size (sizeWhenDone), time_to_string (eta));
            case 6:
                return "%s uploaded".printf (format_size (uploadedEver));
            default:
                return "";
        }   
    }

    public double progress () {
        return percentDone;
    }

    //  public double recheckProgress () {
    //      return recheckProgress;
    //  }

    public string state () {
        switch (status) {
                case 0:
                    return "Paused";
                case 1:
                    return "Queued to check files";
                case 2:
                    return "Checking files";
                    //  progress.fraction = torrent.get_double_member("recheckProgress");
                case 3:
                    return "Queued to download files";
                case 5:
                    return "Queued to seed";
                case 4:
                    return "Downloading from %i of %i peers connected. \u2b07%s \u2b06%s".printf (
                        peersSendingToUs, peersConnected, format_size (rateDownload), format_size (rateUpload)
                    );
                case 6:
                    if (error > 0)
                        return "Tracker error: %s".printf (errorString);
                    return "Seeding to %i of %i peers connected. \u2b06%s".printf (
                        peersGettingFromUs, peersConnected, format_size (rateUpload)
                    ); 
                default:
                    return "";
             }
    }

    private int getInteger (string member) {
        if (torrent.has_member (member))
            return (int) torrent.get_int_member (member);

        return 0;
    }

    private uint getInteger64 (string member) {
        if (torrent.has_member (member))
            return (uint) torrent.get_int_member (member);

        return 0;
    }

    private string getString (string member) {
        if (torrent.has_member (member))
            return torrent.get_string_member (member);

        return "";
    }

    private double getDouble (string member) {
        if (torrent.has_member (member))
            return (double) torrent.get_double_member (member);

        return 0.0;
    }

    private bool getBoolean (string member) {
        if (torrent.has_member (member))
            return (bool) torrent.get_boolean_member (member);

        return false;
    }

    private Json.Array getArray (string member) {
        if (torrent.has_member (member))
            return torrent.get_array_member (member);

        return new Json.Array();
    }

    private static string time_to_string (uint totalSeconds) {
        uint seconds = (totalSeconds % 60);
        uint minutes = (totalSeconds % 3600) / 60;
        uint hours = (totalSeconds % 86400) / 3600;
        uint days = (totalSeconds % (86400 * 30)) / 86400;

        var str_days = "%u days".printf (days);
        var str_hours = "%u hours".printf (hours);
        var str_minutes = "%u minutes".printf (minutes);
        var str_seconds = "%u seconds".printf (seconds);

        var formatted = "";
        if (totalSeconds == -1) {
            formatted = "...";
        } else if (days > 0) {
            formatted = "%s, %s, %s, %s".printf (str_days, str_hours, str_minutes, str_seconds);
        } else if (hours > 0) {
            formatted = "%s, %s, %s".printf (str_hours, str_minutes, str_seconds);
        } else if (minutes > 0) {
            formatted = "%s, %s".printf (str_minutes, str_seconds);
        } else if (seconds > 0) {
            formatted = str_seconds;
        }

        return formatted;
    }
   
}