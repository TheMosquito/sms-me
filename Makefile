
DOCKERHUB_ID:=ibmosquito
NAME:="sms-me"
VERSION:="1.0.0"


# The SMS message will contain the LAN IP address assigned to this interface
INTERFACE_NAME:=eth0


# The SMS message will be sent to the TARGET_SMS_NUMBER stated here
# Start with '+' then country code, then number, e.g.: +15555551212
TARGET_SMS_NUMBER:=


# These are your Synch credentials:
# The SENDER_SMS_NUMBER can be your virtual number or one of your real ones
SERVICE_PLAN_ID:=
API_TOKEN:=
SENDER_SMS_NUMBER:=


default: build run

build:
	docker build -t $(DOCKERHUB_ID)/$(NAME):$(VERSION) .

dev: stop build
	docker run -it -v `pwd`:/outside \
	  --name ${NAME} \
	  --net=host \
	  -e SERVICE_PLAN_ID=$(SERVICE_PLAN_ID) \
	  -e API_TOKEN=$(API_TOKEN) \
	  -e SENDER_SMS_NUMBER=$(SENDER_SMS_NUMBER) \
	  -e INTERFACE_NAME=$(INTERFACE_NAME) \
	  -e TARGET_SMS_NUMBER=$(TARGET_SMS_NUMBER) \
	  $(DOCKERHUB_ID)/$(NAME):$(VERSION) /bin/bash

run: stop
	docker run -d \
	  --name ${NAME} \
	  --restart unless-stopped \
	  --net=host \
	  -e SERVICE_PLAN_ID=$(SERVICE_PLAN_ID) \
	  -e API_TOKEN=$(API_TOKEN) \
	  -e SENDER_SMS_NUMBER=$(SENDER_SMS_NUMBER) \
	  -e INTERFACE_NAME=$(INTERFACE_NAME) \
	  -e TARGET_SMS_NUMBER=$(TARGET_SMS_NUMBER) \
	  $(DOCKERHUB_ID)/$(NAME):$(VERSION)

test:
	echo "Check your phone for an SMS!"

push:
	docker push $(DOCKERHUB_ID)/$(NAME):$(VERSION) 

stop:
	@docker rm -f ${NAME} >/dev/null 2>&1 || :

clean:
	@docker rmi -f $(DOCKERHUB_ID)/$(NAME):$(VERSION) >/dev/null 2>&1 || :

.PHONY: build dev run push test stop clean
