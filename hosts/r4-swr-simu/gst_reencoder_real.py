import gi
gi.require_version('Gst', '1.0')
gi.require_version('GstRtspServer', '1.0')
import os
from gi.repository import Gst, GstRtspServer, GObject

Gst.init(None)
Gst.debug_set_default_threshold(Gst.DebugLevel.INFO)
url = "rtsp://192.168.100.191/live"

class RTSPMediaFactory(GstRtspServer.RTSPMediaFactory):
    def __init__(self, source_url):
        super().__init__()
        self.source_url = source_url

    def do_create_element(self, url):
        # Create individual elements
        src = Gst.ElementFactory.make("rtspsrc", "src")
        src.set_property("location", self.source_url)
        src.set_property("latency", 0)

        depay = Gst.ElementFactory.make("rtph264depay", "depay")
        parse = Gst.ElementFactory.make("h264parse", "parse")
        parse.set_property("config-interval", 1)

        # Decoding the H264 stream
        decoder = Gst.ElementFactory.make("avdec_h264", "decoder")

        # Re-encoding the stream to H264
        encoder = Gst.ElementFactory.make("x264enc", "encoder")
        encoder.set_property("tune", "zerolatency")  # Set for low-latency encoding

        # RTP payloader
        pay = Gst.ElementFactory.make("rtph264pay", "pay")
        pay.set_property("pt", 96)
        pay.set_property("name", "pay0")

        # Create pipeline and add elements
        pipeline = Gst.Pipeline.new("pipeline")
        pipeline.add(src)
        pipeline.add(depay)
        pipeline.add(parse)
        pipeline.add(decoder)
        pipeline.add(encoder)
        pipeline.add(pay)

        # Link static parts
        depay.link(parse)
        parse.link(decoder)
        decoder.link(encoder)
        encoder.link(pay)

        def on_pad_added(src_element, pad):
            caps = pad.query_caps(None)

            for i in range(caps.get_size()):
                structure = caps.get_structure(i)
                if structure.has_field("a-X-com-parrot-camera-type"):
                    cam_type = structure.get_string("a-X-com-parrot-camera-type")
                    print(f"Detected camera type: {cam_type}")
                    if cam_type == "front":
                        sink_pad = depay.get_static_pad("sink")
                        if not sink_pad.is_linked():
                            result = pad.link(sink_pad)
                            if result == Gst.PadLinkReturn.OK:
                                print("Linked front camera stream.")
                            else:
                                print("Failed to link front camera pad:", result)
                        break  # Don't try to link more pads

        src.connect("pad-added", on_pad_added)

        return pipeline


class RTSPServer:
    def __init__(self, source_url):
        self.server = GstRtspServer.RTSPServer()
        self.factory = RTSPMediaFactory(source_url)
        self.factory.set_shared(True)
        mount_points = self.server.get_mount_points()
        mount_points.add_factory("/clean", self.factory)
        self.server.set_service("8552")
        self.server.set_address('0.0.0.0')
        self.server.attach(None)

    def run(self):
        print("RTSP server is live at rtsp://0.0.0.0:8552/clean")
        loop = GObject.MainLoop()
        loop.run()


if __name__ == "__main__":

    server = RTSPServer(url)
    server.run()
