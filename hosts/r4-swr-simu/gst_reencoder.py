import gi
gi.require_version('Gst', '1.0')
gi.require_version('GstRtspServer', '1.0')

from gi.repository import Gst, GstRtspServer, GObject

Gst.init(None)
Gst.debug_set_default_threshold(Gst.DebugLevel.INFO)
class RTSPMediaFactory(GstRtspServer.RTSPMediaFactory):
    def __init__(self, source_url):
        super().__init__()
        self.source_url = source_url

    def do_create_element(self, url):
        pipeline_str = f"""
           rtspsrc location={self.source_url} protocols=tcp latency=100 !
           rtph264depay !
           h264parse !
           avdec_h264 !
           videoconvert !
           videorate !
           video/x-raw, format=I420, width=1280, height=720, framerate=30/1 !
           x264enc speed-preset=faster tune=zerolatency bframes=0 !
           video/x-h264, profile=baseline !
           h264parse config-interval=1 !
           video/x-h264, stream-format=avc, alignment=au !
           rtph264pay config-interval=1 name=pay0
        """
        return Gst.parse_launch(pipeline_str)

class RTSPServer:
    def __init__(self, source_url):
        self.server = GstRtspServer.RTSPServer()
        self.factory = RTSPMediaFactory(source_url)
        self.factory.set_shared(True)
        mount_points = self.server.get_mount_points()
        mount_points.add_factory("/clean", self.factory)
        self.server.set_service("8553")
        self.server.set_address('0.0.0.0')
        self.server.attach(None)

    def run(self):
        print("RTSP server is live at rtsp://0.0.0.0:8553/clean")
        loop = GObject.MainLoop()
        loop.run()

if __name__ == "__main__":
    url = "rtsp://0.0.0.0:8554/vivatech-simu"
    server = RTSPServer(url)
    server.run()
