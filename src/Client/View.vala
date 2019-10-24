public class Client.View : Gtk.ListBox {
    public Server.Model server;
    public Client.Model client;
    public List<Torrent.Row> rows;  

    public View (Server.Model server) {
        set_selection_mode (Gtk.SelectionMode.MULTIPLE);
        activate_on_single_click = false;
        button_press_event.connect (on_button_press);
        popup_menu.connect (on_popup_menu);

        // move this to an async method to improve start-up time
        rows = new List<Torrent.Row> ();
        client = new Client.Model (server);

        Json.Array torrents = client.all();

        foreach (Json.Node node in torrents.get_elements()) {
            Torrent.Model torrent = new Torrent.Model(node);
            Torrent.Row row = new Torrent.Row(torrent);

            row.pause.clicked.connect (() => {
                GLib.Application.get_default().send_notification(null, new Notification ("TODO: NOT YET IMPLEMENTED"));
            });
            rows.append(row);
            prepend(row);
        }
                
        var loop = new MainLoop();
        TimeoutSource time = new TimeoutSource (2000);
        var count = 0;
        time.set_callback (() => {
            do_calc_in_bg.begin(rows, (obj, res) => {
                try {
                    count++;
                    double result = do_calc_in_bg.end(res);
                    stderr.printf(@"$count Result: $result\n");
                } catch (ThreadError e) {
                    string msg = e.message;
                    stderr.printf(@"Thread error: $msg\n");
                }
                loop.quit();
            });
            return true;
        });
    
        time.attach (loop.get_context ());

        loop.run();
    }

    async double do_calc_in_bg(List<Torrent.Row> rows) throws ThreadError {
        SourceFunc callback = do_calc_in_bg.callback;
        double[] output = new double[1];

        Json.Array torrents2 = client.all();

    
        // Hold reference to closure to keep it from being freed whilst
        // thread is active.
        ThreadFunc<bool> run = () => {

            foreach (Json.Node node in torrents2.get_elements()) {
                Torrent.Model torrent2 = new Torrent.Model(node);
                foreach (Torrent.Row row in rows) {
                    if (row.id == torrent2.id) {
                        row.stats.set_text(torrent2.stats());
                        row.state.set_text(torrent2.state());
                        row.progress.fraction = torrent2.percentDone;
                        //TODO Also change the pause button's icon
                        if (torrent2.status == Torrent.Statuses.CHECK) {
                            row.progress.fraction = torrent2.recheckProgress;
                        }
                    }
                }
                //  torrents2.remove(node);
            }

            
            output[0] = torrents2.get_length();
            Idle.add((owned) callback);
            return true;
        };
        
        new Thread<bool>("thread-example", run);
    
        // Wait for background thread to schedule our callback
        yield;
        Thread.usleep(1000);

        return output[0];
    }

    private bool on_popup_menu () {
        Gdk.Event event = Gtk.get_current_event ();
        var menu = new Gtk.Menu ();

        List<weak Gtk.ListBoxRow> items = get_selected_rows ();
        var all_paused = true;

        foreach (var selected_row in items) {
            //  if (!(selected_row as Torrent.Row).paused) {
            //      all_paused = false;
            //      break;
            //  }
        }

        var remove_item = new Gtk.MenuItem.with_label ("Remove");
        remove_item.activate.connect (() => {
            foreach (var selected_row in items) {
                //  Torrent.Row selected2_row = (Torrent.Row) selected_row;
                //  warning ( GLib.Application.get_default ().get_application_id ());
                //  torrentController.remove (select_row.torrent);
            }
        });

        var remove_item_with_files = new Gtk.MenuItem.with_label ("Remove with data");
        remove_item_with_files.activate.connect (() => {
            foreach (var selected_row in items) {
                //  (selected_row as TorrentListRow).remove_torrent ();
            }
        });

        var pause_item = new Gtk.MenuItem.with_label ("Pause");
        pause_item.activate.connect (() => {
            foreach (var selected_row in items) {
                //  (selected_row as TorrentListRow).pause_torrent ();
            }
        });

        var unpause_item = new Gtk.MenuItem.with_label ("Resume");
        unpause_item.activate.connect (() => {
            foreach (var selected_row in items) {
                //  (selected_row as TorrentListRow).resume_torrent ();
            }
        });

        //  var edit_files_item = new Gtk.MenuItem.with_label (_("Select Files to Download"));
        //  edit_files_item.activate.connect (() => {
        //      var selected_row = get_selected_row () as TorrentListRow;
        //      if (selected_row != null) {
        //          selected_row.edit_files ();
        //      }
        //  });

        //  var open_item = new Gtk.MenuItem.with_label (_("Show in File Browser"));
        //  open_item.activate.connect (() => {
        //      var selected_row = get_selected_row ();
        //      if (selected_row != null) {
        //          open_torrent_location ((selected_row as TorrentListRow).id);
        //      }
        //  });

        //  var copy_magnet_item = new Gtk.MenuItem.with_label (_("Copy Magnet Link"));
        //  copy_magnet_item.activate.connect (() => {
        //      var selected_row = get_selected_row () as TorrentListRow;
        //      if (selected_row != null) {
        //          selected_row.copy_magnet_link ();
        //          link_copied ();
        //      }
        //  });

        menu.add (remove_item);
        menu.add (remove_item_with_files);
        if (all_paused) {
            menu.add (unpause_item);
        } else {
            menu.add (pause_item);
        }

        if (items.length () < 2) {
            var selected_row = get_selected_row () as Torrent.Row;

            //  if (selected_row != null && selected_row.multi_file_torrent) {
            //      menu.add (edit_files_item);
            //  }

            //  menu.add (copy_magnet_item);
            //  menu.add (open_item);
        }

        menu.set_screen (null);
        menu.attach_to_widget (this, null);

        menu.show_all ();
        uint button;
        event.get_button (out button);
        menu.popup (null, null, null, button, event.get_time ());
        return true;
    }

    private bool on_button_press (Gdk.EventButton event) {
        if (event.type == Gdk.EventType.BUTTON_PRESS && event.button == Gdk.BUTTON_SECONDARY) {
            var clicked_row = get_row_at_y ((int)event.y);
            var rows = get_selected_rows ();
            var found = false;
            foreach (var row in rows) {
                if (clicked_row == row) {
                    found = true;
                    break;
                }
            }

            if (!found) {
                selected_foreach ((box, row) => {
                    unselect_row (row);
                });

                select_row (clicked_row);
            }

            popup_menu ();
            return true;
        }
        return false;
    }
    
}