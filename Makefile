
DOCKERHUB_ID:=ibmosquito
SERVICE_NAME:="sms-me"
SERVICE_VERSION:="1.0.0"
PATTERN_NAME:="pattern-sms-me"
ARCH:="arm"

# Leave blank for open DockerHub containers
# CONTAINER_CREDS:=-r "registry.wherever.com:myid:mypw"
CONTAINER_CREDS:=

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
	docker build -t $(DOCKERHUB_ID)/$(NAME)_$(ARCH):$(SERVICE_VERSION) .

dev: stop build
	docker run -it -v `pwd`:/outside \
	  --name ${SERVICE_NAME} \
	  --net=host \
	  -e SERVICE_PLAN_ID=$(SERVICE_PLAN_ID) \
	  -e API_TOKEN=$(API_TOKEN) \
	  -e SENDER_SMS_NUMBER=$(SENDER_SMS_NUMBER) \
	  -e INTERFACE_NAME=$(INTERFACE_NAME) \
	  -e TARGET_SMS_NUMBER=$(TARGET_SMS_NUMBER) \
	  $(DOCKERHUB_ID)/$(SERVICE_NAME)_$(ARCH):$(SERVICE_VERSION) /bin/bash

run: stop
	docker run -d \
	  --name ${SERVICE_NAME} \
	  --restart unless-stopped \
	  --net=host \
	  -e SERVICE_PLAN_ID=$(SERVICE_PLAN_ID) \
	  -e API_TOKEN=$(API_TOKEN) \
	  -e SENDER_SMS_NUMBER=$(SENDER_SMS_NUMBER) \
	  -e INTERFACE_NAME=$(INTERFACE_NAME) \
	  -e TARGET_SMS_NUMBER=$(TARGET_SMS_NUMBER) \
	  $(DOCKERHUB_ID)/$(SERVICE_NAME)_$(ARCH):$(SERVICE_VERSION)

test:
	echo "Check your phone for an SMS!"

push:
	docker push $(DOCKERHUB_ID)/$(SERVICE_NAME)_$(ARCH):$(SERVICE_VERSION) 

publish-service:
	@ARCH=$(ARCH) \
        SERVICE_NAME="$(SERVICE_NAME)" \
        SERVICE_VERSION="$(SERVICE_VERSION)"\
        SERVICE_CONTAINER="$(DOCKERHUB_ID)/$(SERVICE_NAME)_$(ARCH):$(SERVICE_VERSION)" \
        hzn exchange service publish -O $(CONTAINER_CREDS) -f service.json --pull-image

publish-pattern:
	@ARCH=$(ARCH) \
        SERVICE_NAME="$(SERVICE_NAME)" \
        SERVICE_VERSION="$(SERVICE_VERSION)"\
        PATTERN_NAME="$(PATTERN_NAME)" \
	hzn exchange pattern publish -f pattern.json

stop:
	@docker rm -f ${SERVICE_NAME} >/dev/null 2>&1 || :

clean:
	@docker rmi -f $(DOCKERHUB_ID)/$(SERVICE_NAME)_$(ARCH):$(SERVICE_VERSION) >/dev/null 2>&1 || :

agent-run:
	hzn register --pattern "${HZN_ORG_ID}/$(PATTERN_NAME)"

agent-stop:
	hzn unregister -f

.PHONY: build dev run push publish-service publish-pattern test stop clean agent-run agent-stop
