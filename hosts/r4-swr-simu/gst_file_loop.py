import gi
gi.require_version('Gst', '1.0')
gi.require_version('GstRtspServer', '1.0')

from gi.repository import Gst, GstRtspServer, GObject, GLib

Gst.init(None)
Gst.debug_set_default_threshold(Gst.DebugLevel.INFO)

class LoopFactory(GstRtspServer.RTSPMediaFactory):
    def __init__(self):
        super(LoopFactory, self).__init__()
        self.set_shared(True)

    def do_create_element(self, url):
        pipeline_desc = (
            'filesrc location=file_example.mp4 ! qtdemux name=demux '
            'demux.video_0 ! queue ! decodebin ! x264enc tune=zerolatency ! rtph264pay pt=96 name=pay0 '
        )
        return Gst.parse_launch(pipeline_desc)


server = GstRtspServer.RTSPServer()
factory = LoopFactory()
factory.set_launch('( filesrc location=file_example.mp4 ! qtdemux name=demux '
                   'demux.video_0 ! queue ! decodebin ! x264enc tune=zerolatency ! rtph264pay name=pay0 pt=96 )')
factory.set_shared(True)

mounts = server.get_mount_points()
mounts.add_factory("/clean", factory)

server.set_service("8552")
server.set_address('0.0.0.0')
server.attach(None)
print("RTSP server ready at rtsp://127.0.0.1:8552/clean")
GLib.MainLoop().run()


