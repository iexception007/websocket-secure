import wss
import trollius as asyncio

loop = asyncio.get_event_loop()

server =  wss.Server(port=9002,
                     useSsl=True,
                     sslCert="/code/ssl/www.aaa.com.crt",
                     sslKey="/code/ssl/www.aaa.com.key")

def onTextMessage(server, msg, client):
	print("got message from client:", msg)

def onBinaryMessage(server, msg, client):
	print("got binary message")

server.onMessage = onTextMessage
server.onBinaryMessage = onBinaryMessage

@asyncio.coroutine
def sendData():
	while True:
		try:
			print("trying to broadcast...")
			s.broadcast("{'hello' : 'world' }")
		except:
			exc_type, exc_value, exc_traceback = sys.exc_info()
			traceback.print_tb(exc_traceback, limit=1, file=sys.stdout)
			traceback.print_exception(exc_type, exc_value, exc_traceback,
						  limit=2, file=sys.stdout)

		yield asyncio.From(asyncio.sleep(30))

loop.create_task(sendData())

server.start()
loop.run_forever()