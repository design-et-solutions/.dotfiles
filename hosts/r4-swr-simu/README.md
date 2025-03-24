```shell
sudo apt install curl ffmpeg python3-full
```

```shell
curl --fail --silent --show-error --location https://debian.parrot.com/gpg | gpg --dearmor | sudo tee /usr/share/keyrings/debian.parrot.com.gpg > /dev/null
echo "deb [signed-by=/usr/share/keyrings/debian.parrot.com.gpg] https://debian.parrot.com/ jammy main generic" | sudo tee /etc/apt/sources.list.d/debian.parrot.com.list
sudo apt update
sudo apt install parrot-sphinx

newgrp firmwared
sudo usermod -a -G firmwared me

sudo nano /etc/gdm3/custom.conf
```

```conf
[...]
WaylandEnable=false
[...]
```

```sh
sudo systemctl gdm3
```

Fix color.

```sh
sudo apt update
apt-cache search parrot-ue4
sudo apt install parrot-ue4-forest
```

```sh
sudo ubuntu-drivers autoinstall
```

```sh
sudo systemctl start firmwared.service
```

```sh
sphinx "/opt/parrot-sphinx/usr/share/sphinx/drones/anafi_ai.drone"::firmware="https://firmware.parrot.com/Versions/anafi2/pc/%23latest/images/anafi2-pc.ext2.zip"
```

```sh
parrot-ue4-forest  -nullrhi -sphinx-port=8385
```

After few times... (like 5min).

- Web dashboard is accessible at `http://localhost:9003`
- Using interface for remote controller: `'<interface>'`

```shell
$ ping 10.202.0.1
PING 10.202.0.1 (10.202.0.1) 56(84) bytes of data.
64 bytes from 10.202.0.1: icmp_seq=1 ttl=64 time=0.022 ms
64 bytes from 10.202.0.1: icmp_seq=2 ttl=64 time=0.036 ms
64 bytes from 10.202.0.1: icmp_seq=3 ttl=64 time=0.036 ms

ffprobe -v quiet -print_format json -show_format -show_streams -show_entries stream_tags:format_tags rtsp://10.202.0.1/live

ffmpeg -i rtsp://10.202.0.1/live -f sdl "ANAFI Ai Stream"

sphinx-cli camera front_photo --sphinx-port 8385
```

```json
{
  "streams": [
    {
      "index": 0,
      "codec_name": "h264",
      "codec_long_name": "H.264 / AVC / MPEG-4 AVC / MPEG-4 part 10",
      "profile": "Main",
      "codec_type": "video",
      "codec_tag_string": "[0][0][0][0]",
      "codec_tag": "0x0000",
      "width": 1280,
      "height": 720,
      "coded_width": 1280,
      "coded_height": 720,
      "closed_captions": 0,
      "film_grain": 0,
      "has_b_frames": 0,
      "pix_fmt": "yuv420p",
      "level": 40,
      "chroma_location": "left",
      "field_order": "progressive",
      "refs": 1,
      "is_avc": "false",
      "nal_length_size": "0",
      "r_frame_rate": "30/1",
      "avg_frame_rate": "30/1",
      "time_base": "1/90000",
      "start_pts": 3000,
      "start_time": "0.033333",
      "bits_per_raw_sample": "8",
      "extradata_size": 47,
      "disposition": {
        "default": 0,
        "dub": 0,
        "original": 0,
        "comment": 0,
        "lyrics": 0,
        "karaoke": 0,
        "forced": 0,
        "hearing_impaired": 0,
        "visual_impaired": 0,
        "clean_effects": 0,
        "attached_pic": 0,
        "timed_thumbnails": 0,
        "non_diegetic": 0,
        "captions": 0,
        "descriptions": 0,
        "metadata": 0,
        "dependent": 0,
        "still_image": 0
      }
    },
    {
      "index": 1,
      "codec_name": "h264",
      "codec_long_name": "H.264 / AVC / MPEG-4 AVC / MPEG-4 part 10",
      "profile": "Main",
      "codec_type": "video",
      "codec_tag_string": "[0][0][0][0]",
      "codec_tag": "0x0000",
      "width": 1280,
      "height": 720,
      "coded_width": 1280,
      "coded_height": 720,
      "closed_captions": 0,
      "film_grain": 0,
      "has_b_frames": 0,
      "pix_fmt": "yuv420p",
      "level": 40,
      "chroma_location": "left",
      "field_order": "progressive",
      "refs": 1,
      "is_avc": "false",
      "nal_length_size": "0",
      "r_frame_rate": "30/1",
      "avg_frame_rate": "30/1",
      "time_base": "1/90000",
      "start_pts": 3000,
      "start_time": "0.033333",
      "bits_per_raw_sample": "8",
      "extradata_size": 46,
      "disposition": {
        "default": 0,
        "dub": 0,
        "original": 0,
        "comment": 0,
        "lyrics": 0,
        "karaoke": 0,
        "forced": 0,
        "hearing_impaired": 0,
        "visual_impaired": 0,
        "clean_effects": 0,
        "attached_pic": 0,
        "timed_thumbnails": 0,
        "non_diegetic": 0,
        "captions": 0,
        "descriptions": 0,
        "metadata": 0,
        "dependent": 0,
        "still_image": 0
      }
    },
    {
      "index": 2,
      "codec_name": "h264",
      "codec_long_name": "H.264 / AVC / MPEG-4 AVC / MPEG-4 part 10",
      "profile": "Main",
      "codec_type": "video",
      "codec_tag_string": "[0][0][0][0]",
      "codec_tag": "0x0000",
      "width": 1280,
      "height": 720,
      "coded_width": 1280,
      "coded_height": 720,
      "closed_captions": 0,
      "film_grain": 0,
      "has_b_frames": 0,
      "pix_fmt": "yuv420p",
      "level": 40,
      "chroma_location": "left",
      "field_order": "progressive",
      "refs": 1,
      "is_avc": "false",
      "nal_length_size": "0",
      "r_frame_rate": "30/1",
      "avg_frame_rate": "30/1",
      "time_base": "1/90000",
      "start_pts": 3000,
      "start_time": "0.033333",
      "bits_per_raw_sample": "8",
      "extradata_size": 47,
      "disposition": {
        "default": 0,
        "dub": 0,
        "original": 0,
        "comment": 0,
        "lyrics": 0,
        "karaoke": 0,
        "forced": 0,
        "hearing_impaired": 0,
        "visual_impaired": 0,
        "clean_effects": 0,
        "attached_pic": 0,
        "timed_thumbnails": 0,
        "non_diegetic": 0,
        "captions": 0,
        "descriptions": 0,
        "metadata": 0,
        "dependent": 0,
        "still_image": 0
      }
    },
    {
      "index": 3,
      "codec_name": "h264",
      "codec_long_name": "H.264 / AVC / MPEG-4 AVC / MPEG-4 part 10",
      "profile": "Main",
      "codec_type": "video",
      "codec_tag_string": "[0][0][0][0]",
      "codec_tag": "0x0000",
      "width": 1280,
      "height": 720,
      "coded_width": 1280,
      "coded_height": 720,
      "closed_captions": 0,
      "film_grain": 0,
      "has_b_frames": 0,
      "pix_fmt": "yuv420p",
      "level": 40,
      "chroma_location": "left",
      "field_order": "progressive",
      "refs": 1,
      "is_avc": "false",
      "nal_length_size": "0",
      "r_frame_rate": "30/1",
      "avg_frame_rate": "30/1",
      "time_base": "1/90000",
      "start_pts": 3000,
      "start_time": "0.033333",
      "bits_per_raw_sample": "8",
      "extradata_size": 47,
      "disposition": {
        "default": 0,
        "dub": 0,
        "original": 0,
        "comment": 0,
        "lyrics": 0,
        "karaoke": 0,
        "forced": 0,
        "hearing_impaired": 0,
        "visual_impaired": 0,
        "clean_effects": 0,
        "attached_pic": 0,
        "timed_thumbnails": 0,
        "non_diegetic": 0,
        "captions": 0,
        "descriptions": 0,
        "metadata": 0,
        "dependent": 0,
        "still_image": 0
      }
    },
    {
      "index": 4,
      "codec_name": "h264",
      "codec_long_name": "H.264 / AVC / MPEG-4 AVC / MPEG-4 part 10",
      "profile": "Main",
      "codec_type": "video",
      "codec_tag_string": "[0][0][0][0]",
      "codec_tag": "0x0000",
      "width": 320,
      "height": 240,
      "coded_width": 320,
      "coded_height": 240,
      "closed_captions": 0,
      "film_grain": 0,
      "has_b_frames": 0,
      "pix_fmt": "yuv420p",
      "level": 40,
      "chroma_location": "left",
      "field_order": "progressive",
      "refs": 1,
      "is_avc": "false",
      "nal_length_size": "0",
      "r_frame_rate": "60/1",
      "avg_frame_rate": "60/1",
      "time_base": "1/90000",
      "start_pts": 1500,
      "start_time": "0.016667",
      "bits_per_raw_sample": "8",
      "extradata_size": 44,
      "disposition": {
        "default": 0,
        "dub": 0,
        "original": 0,
        "comment": 0,
        "lyrics": 0,
        "karaoke": 0,
        "forced": 0,
        "hearing_impaired": 0,
        "visual_impaired": 0,
        "clean_effects": 0,
        "attached_pic": 0,
        "timed_thumbnails": 0,
        "non_diegetic": 0,
        "captions": 0,
        "descriptions": 0,
        "metadata": 0,
        "dependent": 0,
        "still_image": 0
      }
    },
    {
      "index": 5,
      "codec_name": "h264",
      "codec_long_name": "H.264 / AVC / MPEG-4 AVC / MPEG-4 part 10",
      "profile": "Main",
      "codec_type": "video",
      "codec_tag_string": "[0][0][0][0]",
      "codec_tag": "0x0000",
      "width": 176,
      "height": 90,
      "coded_width": 176,
      "coded_height": 90,
      "closed_captions": 0,
      "film_grain": 0,
      "has_b_frames": 0,
      "pix_fmt": "yuv420p",
      "level": 40,
      "chroma_location": "left",
      "field_order": "progressive",
      "refs": 1,
      "is_avc": "false",
      "nal_length_size": "0",
      "r_frame_rate": "30/1",
      "avg_frame_rate": "30/1",
      "time_base": "1/90000",
      "start_pts": 3000,
      "start_time": "0.033333",
      "bits_per_raw_sample": "8",
      "extradata_size": 47,
      "disposition": {
        "default": 0,
        "dub": 0,
        "original": 0,
        "comment": 0,
        "lyrics": 0,
        "karaoke": 0,
        "forced": 0,
        "hearing_impaired": 0,
        "visual_impaired": 0,
        "clean_effects": 0,
        "attached_pic": 0,
        "timed_thumbnails": 0,
        "non_diegetic": 0,
        "captions": 0,
        "descriptions": 0,
        "metadata": 0,
        "dependent": 0,
        "still_image": 0
      }
    }
  ],
  "format": {
    "filename": "rtsp://10.202.0.1/live",
    "nb_streams": 6,
    "nb_programs": 0,
    "format_name": "rtsp",
    "format_long_name": "RTSP input",
    "start_time": "0.016667",
    "probe_score": 100,
    "tags": {
      "title": "live",
      "comment": "ANAFI Ai 000000"
    }
  }
}
```
