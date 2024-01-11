import os
import random
import time
from azure.iot.device import IoTHubDeviceClient, Message

MSG_TXT = '{{"peopleNumber": {number}}}'


def run_telemetry_sample(client):
    
    print("IoT Hub device sending periodic messages")

    client.connect()

    
    number = random.randint(1, 100)
    msg_txt_formatted = MSG_TXT.format(number=number)
    message = Message(msg_txt_formatted)

    # if number > 30:
    #     message.custom_properties["temperatureAlert"] = "true"
    # else:
    #     message.custom_properties["temperatureAlert"] = "false"

    # Send the message.
    print("Sending message: {}".format(message))
    client.send_message(message)
    print("Message successfully sent")
    
    #time.sleep(10)


def main():
    print("IoT Hub Quickstart #1 - Simulated device")
    print("Press Ctrl-C to exit")

    client = IoTHubDeviceClient.create_from_connection_string("HostName=piscoIoT.azure-devices.net;DeviceId=2;SharedAccessKey=XckcyvTf5F7w/+Ja6lYkWAgQqc0KdRcbbAIoTAzNka0=")

    try:
        run_telemetry_sample(client)
    except KeyboardInterrupt:
        print("IoTHubClient sample stopped by user")
    finally:
        print("Shutting down IoTHubClient")
        client.shutdown()

if __name__ == '__main__':
    main()