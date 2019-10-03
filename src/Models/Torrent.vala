public class Models.Torrent : Object {

    // The Json.Object received from the server.
    public Json.Object torrent { get; set; }
    
    // Torrent name.
    public string name { get; set; }
    
    // Last time of upload or download activity.
    public int activityDate { get; set; } 
    
    // The date when this torrent was first added.
    public int addedDate { get; set; }  
    
    // Torrent creation date.
    public int dateCreated { get; set; } 

    // The date when the torrent finished downloading.   
    public int doneDate { get; set; }
    
    // Estimated number of seconds left when downloading or seeding. -1 means not available and -2 means unknown.
    public uint eta { get; set; }  
    
    // Array of file object containing key, bytesCompleted, length and name.
    public Json.Array files { get; set; } 
    
    // Session unique torrent id.
    public int id { get; set; }  
    
    // True if the torrent is finished. Downloaded and seeded.
    public bool isFinished { get; set; }
    
    // True if the torrent has stalled - been idle for a long time.
    public bool isStalled { get; set; }  
    
    // Number of bytes left until the download is done.
    public uint leftUntilDone { get; set; }

    // Number of total bytes uploaded.
    public uint uploadedEver { get; set; }
    
    // Array of peer objects.
    public Json.Array peers { get; set; }
    
    // Number of peers we are connected to.
    public int peersConnected { get; set; } 
    
    // Number of peers we are sending data to.
    public int peersGettingFromUs { get; set; } 

    // Number of peers sending to us
    public int peersSendingToUs { get; set; }
    
    // Download progress of selected files. 0.0 to 1.0.
    public double percentDone { get; set; } 
    
    // Download rate in bps.
    public uint rateDownload { get; set; } 
    
    // Upload rate in bps.
    public uint rateUpload { get; set; }
    
    // Progress of recheck. 0.0 to 1.0.
    public double recheckProgress { get; set; } 

    // Size of the torrent download in bytes.
    public uint sizeWhenDone { get; set; } 

    // Number of bytes of checksum verified data.
    public uint haveValid { get; set; }
    
    // Current status, see source
    public int status { get; set; }

    public int error { get; set; }
    public string errorString { get; set; }

    public int filesCount { get; set; }
    public string firstFileName { get; set; }
    
    public class Torrent(Json.Node node) {
      
        Json.Reader reader = new Json.Reader(node);
        foreach (string member in reader.list_members ()) {
            switch (member) {
                case "name":
                case "errorString":
                    if (reader.read_member (member) == true && reader.is_value())
                        @set (member, reader.get_string_value ());
                    reader.end_member ();
                    break;
                case "id":
                case "error":
                case "status":
                case "doneDate":
                case "addedDate":
                case "uploadedEver":
                case "activityDate":
                case "peersConnected":
                case "peersSendingToUs":
                case "peersGettingFromUs":
                    if (reader.read_member (member) == true && reader.is_value())
                        @set (member, (int) reader.get_int_value ());
                    reader.end_member ();
                    break;
                case "eta":
                case "haveValid":
                case "rateUpload":
                case "rateDownload":
                case "sizeWhenDone":
                case "leftUntilDone":
                    if (reader.read_member (member) == true && reader.is_value())
                        @set (member, (uint) reader.get_int_value ());
                    reader.end_member ();
                    break;
                case "percentDone":
                case "recheckProgress":
                    if (reader.read_member (member) == true && reader.is_value())
                        @set (member, reader.get_double_value ());
                    reader.end_member ();
                    break;
                case "isStalled":
                case "isFinished":
                    if (reader.read_member (member) == true && reader.is_value())
                        @set (member, reader.get_boolean_value ());
                    reader.end_member ();
                    break;
                case "files":
                    if (reader.read_member (member) == true && reader.is_array()) {
                        if (reader.count_elements() > 0 && reader.read_element (0) && reader.is_object()) {
                            if (reader.read_member ("name") == true && reader.is_value()) {
                                @set ("firstFileName", reader.get_string_value ());
                                reader.end_member ();
                            }
                            reader.end_element ();
                        } 
                        @set (member, reader.get_value ());
                        @set (member + "Count", reader.count_elements());
                        reader.end_member ();
                    }
                    reader.end_member ();
                    break;
                case "peers":
                    if (reader.read_member (member) == true && reader.is_array())
                        @set (member, reader.get_value ());  
                    reader.end_member ();
                    break;
                default:
                    assert_not_reached ();
            }
        }
    }

    public GLib.Icon icon () {


        if (filesCount > 1) {
            return ContentType.get_icon ("inode/directory");
        } else if (filesCount > 0) {
            bool certain = false;
            return ContentType.get_icon (ContentType.guess (firstFileName, null, out certain));
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

    public string state () {
        switch (status) {
                case 0:
                    return "Paused";
                case 1:
                    return "Queued to check files";
                case 2:
                    return "Checking files";
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
            formatted = "Unknown time ";
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