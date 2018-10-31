REPO1=iexception007/wss_server
REPO2=iexception007/wss_client
VERSION=v0.0.1

.PHONY:build push run clear
build:
	docker build -f Dockerfile.server -t ${REPO1}:${VERSION} .
	docker build -f Dockerfile.client -t ${REPO2}:${VERSION} .

push:
	docker push ${REPO1}:${VERSION}
	docker push ${REPO2}:${VERSION}

run:
	-docker rm -f wss_server
	-docker ru -f wss_client
	docker run -d -p 9001:9001 --name wss_server ${REPO1}:${VERSION}
	docker run --name wss_client ${REPO2}:${VERSION}

clear:
	docker rm -f wss_server
	docker rm -f wss_client
