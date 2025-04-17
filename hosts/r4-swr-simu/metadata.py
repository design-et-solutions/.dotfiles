import asyncio
import json
import math

import olympe
import websockets
from olympe.messages.ardrone3.PilotingState import (
    AttitudeChanged,
    GpsLocationChanged,
    SpeedChanged,
)
from olympe.messages.gimbal import attitude as gimbal_attitude


# Function to send data over WebSocket
async def send_data():
    # Connect to the WebSocket server
    uri = "ws://192.168.100.125:3001/ws?room=metada"
    async with websockets.connect(uri) as websocket:
        # Get telemetry data from the drone
        drone = olympe.Drone("10.202.0.1")
        drone.connect()

        try:
            while True:
                # Get GPS position
                position = drone.get_state(GpsLocationChanged)
                latitude = position["latitude"]
                longitude = position["longitude"]
                altitude = position["altitude"]

                # Get heading (yaw in radians, convert to degrees)
                attitude = drone.get_state(AttitudeChanged)
                yaw_rad = attitude["yaw"]
                heading_deg = yaw_rad

                # Get speed
                speed = drone.get_state(SpeedChanged)
                speed_x = speed["speedX"]
                speed_y = speed["speedY"]
                speed_z = speed["speedZ"]
                horizontal_speed = math.sqrt(speed_x**2 + speed_y**2)

                electro_optical_sensor_fov = 69.0

                # Get gimbal attitude
                gimbal = drone.get_state(gimbal_attitude)[0]
                gimbal_pitch = gimbal["pitch_absolute"]
                gimbal_roll = gimbal["roll_absolute"]
                gimbal_yaw = gimbal["yaw_absolute"]

                # Create the telemetry response
                drone_information = {
                    "longitude": longitude,
                    "latitude": latitude,
                    "altitude": altitude,
                    "heading": heading_deg,
                    "speed": horizontal_speed,
                }

                sensor_information = {
                    "electro_optical_sensor_fov": electro_optical_sensor_fov,
                    "gimbal_azimut_angle": gimbal_yaw,
                    "gimbal_elevation_angle": gimbal_pitch,
                }

                drone_telemetry_response = {
                    "drone_information": drone_information,
                    "sensor_information": sensor_information,
                }

                # Send the data over WebSocket
                await websocket.send(json.dumps(drone_telemetry_response))

                # Wait for 200ms before sending the next data
                await asyncio.sleep(0.2)  # 200ms delay

        finally:
            # Disconnect the drone after the loop ends
            drone.disconnect()


# Start the asyncio event loop
asyncio.get_event_loop().run_until_complete(send_data())
