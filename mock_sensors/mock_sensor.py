import os
import random
import time
from azure.iot.device import IoTHubDeviceClient, Message

idSensor = 1
MSG_TXT = '{{"peopleNumber": {number}, "idSensor": {idSensor}}}'

def simulate_sensor(client):
    
    print("IoT Hub device sending periodic messages")

    client.connect()

    number = random.randint(1, 100)
    msg_txt_formatted = MSG_TXT.format(number=number, idSensor=idSensor)
    message = Message(msg_txt_formatted)

    # Send the message.
    print("Sending message: {}".format(message))
    client.send_message(message)
    print("Message successfully sent")

def main():
    print("Press Ctrl-C to exit")

    client = IoTHubDeviceClient.create_from_connection_string("HostName=piscooiothub.azure-devices.net;DeviceId=1;SharedAccessKey=QEGJXWX4I5+i+zvrcSmMdjBunRVnWv8APAIoTBFH0xM=")

    try:
        simulate_sensor(client)
    except KeyboardInterrupt:
        print("IoTHubClient stopped by user")
    finally:
        print("Shutting down IoTHubClient")
        client.shutdown()

if __name__ == '__main__':
    main()