/* main.vala *
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

	const string APP_NAME = "headphones-plug-controller";
	const string APP_VERSION = "0.1.0";
	const string APP_ID = "com.github.nvlgit.Headphones-Plug-Controller";

	public class Application {

		private static bool version;
		private static bool debug = false;
		private const OptionEntry[] options = {
		    { "version",   0,  0, OptionArg.NONE, ref version, "Display version number", null },
		    { "debug",    'd', 0, OptionArg.NONE, ref debug,   "Show debug information", null },
		    { null }
		};

		static int main (string[] args) {

			try {
				var opt_context = new OptionContext ();
				opt_context.set_help_enabled (true);
				opt_context.add_main_entries (options, null);
				opt_context.parse (ref args);

			} catch (OptionError e) {

				stdout.printf ("%s\n", e.message);
				stdout.printf ("Run '%s --help' to see a full list of available command line options.\n", args[0]);
				return 1;
			}

			if (version) {

				stdout.printf ("Version: %s\n", APP_VERSION);
				return 0;
			}

			if (debug) {

				Environment.set_variable("G_MESSAGES_DEBUG", "all", false);
				message("\n%s started in debug mode.\n", APP_NAME);
			}

			/****** Begin app *******/
			var loop = new GLib.MainLoop ();
			var detector = new PlugDetector ();
			var controller = new PlaybackController ();
			detector.run ();

			detector.port_changed.connect ( () => {

				if ( ( detector.get_last_port_type () ) == PortType.HEADPHONES )
					controller.resume.begin ();
				if ( ( detector.get_last_port_type () ) == PortType.SPEAKER )
					controller.discontinue.begin ();
			});

			loop.run ();

			return 0;
		}
	}
}
