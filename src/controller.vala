/* controller.vala *
 * Copyright (C) 2017 Nick *
 * Permission is hereby granted, free of charge, to any person obtaining
 * a copy of this software and associated documentation files (the
 * "Software"), to deal in the Software without restriction, including
 * without limitation the rights to use, copy, modify, merge, publish,
 * distribute, sublicense, and/or sell copies of the Software, and to
 * permit persons to whom the Software is furnished to do so, subject to
 * the following conditions:
 *
 * The above copyright notice and this permission notice shall be
 * included in all copies or substantial portions of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
 * EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
 * MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
 * NONINFRINGEMENT. IN NO EVENT SHALL THE X CONSORTIUM BE LIABLE FOR ANY
 * CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
 * TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
 * SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 *
 * Except as contained in this notice, the name(s) of the above copyright
 * holders shall not be used in advertising or otherwise to promote the sale,
 * use or other dealings in this Software without prior written
 * authorization.
 */

namespace Hpppc {

    public class PlaybackController : GLib.Object {

        private unowned GLib.List<string>? players;

        public async void discontinue () {

            yield playing_players_to_pause ();
        }

        public async void resume () {

            yield paused_players_to_play ();
        }

        private async void get_all_players () {

            unowned GLib.List<string>? p = null;
            GLib.VariantIter? iter = null;
            string? name = null;

            try {
                var proxy = new GLib.DBusProxy.for_bus_sync (GLib.BusType.SESSION,
                                                             GLib.DBusProxyFlags.DO_NOT_AUTO_START, null,
                                                             "org.freedesktop.DBus", "/org/freedesktop/DBus",
                                                             "org.freedesktop.DBus", null);
                GLib.Variant variant = yield proxy.call ("ListNames", null, GLib.DBusCallFlags.NONE, -1, null);
                variant.get("(as)", out iter);
                while (iter.next ("s", out name, out variant) ) {
                    if ("org.mpris.MediaPlayer2" in name) {
    		            debug ("\nFound MPRISv2.2 D-Bus client: '%s' [type: '%s']\n", name, variant.get_type_string () );
    		            p.prepend(name);
    		        }
		        }
            } catch (Error e) {

                debug ("\nCould not start application over DBus: %s\n", e.message);
            }
            this.players = p;
        }

        private async void playing_players_to_pause () {

            yield get_all_players ();
            unowned GLib.List<string>? pp = null;

                foreach (string name in this.players) {

                    if ( is_playing (name) ) {

                       debug ("\nStatus 'Playing': %s\n", name);
                       pp.prepend(name);
                       yield player_pause (name);
                    }
                }
            this.players = pp;
        }

        private bool is_playing (string name) {

            bool ret = false;

            Mpris2Controller c = new Mpris2Controller (name);

    		if (c.player.PlaybackStatus != null) {
                if ("Playing" in c.player.PlaybackStatus) {
                    ret = true;
    		    }
    		}
    		return ret;
        }

        private async void player_pause (string name) {

            Mpris2Controller c = new Mpris2Controller (name);

            try {

                yield c.player.Pause ();
                debug ("\nPerform 'Pause' for: %s\n", name);

            } catch (Error e) {

                debug ("\nError: %s\n", e.message);
            }
        }

        private async void paused_players_to_play () {

            foreach (string name in this.players) {

                    yield player_play (name);
            }
        }

        private async void player_play (string name) {

            Mpris2Controller c = new Mpris2Controller (name);

            try {

                yield c.player.Play ();
                debug ("\nPerform 'Play' for: %s\n", name);

            } catch (Error e) {

                debug ("\nError: %s\n", e.message);
            }
        }
    }

    [DBus (name = "org.mpris.MediaPlayer2.Player")]
    public interface MprisPlayer : GLib.Object {

        public abstract string PlaybackStatus {owned get; }
        public abstract async void Play()  throws IOError;
        public abstract async void Pause() throws IOError;
    }

    public class Mpris2Controller : GLib.Object {

        public string dbus_name {get; construct;}
        public MprisPlayer player;

        public Mpris2Controller(string name) {

            GLib.Object (dbus_name : name);
        }

        construct {

            try {

                this.player = Bus.get_proxy_sync ( BusType.SESSION, dbus_name,
                                                   "/org/mpris/MediaPlayer2" );
            } catch (IOError e) {

                debug ("Can't create DBus interfaces - %s", e.message);
            }
        }
    }
}
