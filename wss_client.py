import wss
import trollius as asyncio
import argparse

parser = argparse.ArgumentParser()
parser.add_argument('--ssl', dest="usessl", help="use ssl.", action='store_true')
parser.add_argument('--debug', dest="debug", help="turn on debugging.", action='store_true')
parser.add_argument('address', help="address", default="localhost", nargs="?")
parser.add_argument('port', help="port", default=9000, nargs="?")
args = parser.parse_args()

loop = asyncio.get_event_loop()
client = wss.Client(retry=True, loop=loop)

def textHandler(msg):
	print(msg)

def opened():
	print("connected")
	client.sendMessage("{'foo' : 'bar'}")

def closed():
	print("connection closed")


client.debug = args.debug

client.setTextHandler(textHandler)
client.setOpenHandler(opened)
client.setCloseHandler(closed)

client.connectTo(args.address, args.port, useSsl=args.usessl)

loop.run_forever()