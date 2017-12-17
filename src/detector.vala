/* detector.vala *
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

	public enum PortType {

			UNKNOWN,
			SPEAKER,
			HEADPHONES
	}

	public class PlugDetector : GLib.Object {

		private PulseAudio.GLibMainLoop loop;
		private PulseAudio.Context context;
		private PulseAudio.Proplist proplist;
		private PortType last_port;
		public signal void port_changed ();

		public PlugDetector () {
			GLib.Object();
		}

		construct {
			this.proplist = new PulseAudio.Proplist ();
			this.proplist.sets (PulseAudio.Proplist.PROP_APPLICATION_NAME, APP_NAME);
			this.proplist.sets (PulseAudio.Proplist.PROP_APPLICATION_ID, APP_ID);
			this.proplist.sets (PulseAudio.Proplist.PROP_APPLICATION_VERSION, APP_VERSION);
		}

		public void run () {

			this.loop = new PulseAudio.GLibMainLoop ();
			this.context = new PulseAudio.Context (loop.get_api(),
				                               null,
				                               proplist);
		        this.context.set_state_callback(this.context_state_cb);

		        if (this.context.connect( null, PulseAudio.Context.Flags.NOFAIL, null) < 0) {
				stderr.printf("pa_context_connect() failed: %s\n",
				      PulseAudio.strerror(context.errno() ) );
		        }
		}

		public PortType get_last_port_type () {

			return last_port;
		}

		private void context_state_cb (PulseAudio.Context context) {

		        PulseAudio.Context.State state = context.get_state();
			if ( state == PulseAudio.Context.State.READY) {

				context.subscribe (PulseAudio.Context.SubscriptionMask.SINK);
				context.set_subscribe_callback (context_events_cb);
			}
		}

		private void context_events_cb (PulseAudio.Context context,
			                        PulseAudio.Context.SubscriptionEventType type,
			                        uint32 index) {

			if (type == PulseAudio.Context.SubscriptionEventType.CHANGE) {
				context.get_sink_info_by_index (index, sink_info_cb);
			}
		}

		private void sink_info_cb (PulseAudio.Context context,
			                   PulseAudio.SinkInfo? info,
			                   int eol) {

			if (info != null) {
				PortType current_port = get_port_type (info.active_port);
				if ( current_port != last_port ) {
					last_port = current_port;
					port_changed (); // Emit signal
					debug ("\nActive port: %s\n", info.active_port.name);
				}
			}
		}

		private PortType get_port_type (PulseAudio.SinkPortInfo * port) {

			PortType port_type = PortType.UNKNOWN;

			if ( "headphones" in port.name )
				port_type = PortType.HEADPHONES;
			if ( "speaker" in port.name )
				port_type = PortType.SPEAKER;

			return port_type;
		}
	}
}
