# sms-me

Sends an SMS message to the specified phone (SMS) number stating the IP address of the specified interface.

Uses the [Sinch](https://www.sinch.com/) service. Visit that site and create a free account, then get your SERVICE_PLAN_ID, API_TOKEN, and a SENDER_SMS_NUMBER, that you will need below.

## Usage:

1. Edit the Makefie to add:

```
SERVICE_PLAN_ID (your sinch plan ID)
API_TOKEN (your sinch API token)
SENDER_SMS_NUMBER (any of the virtual numbers or real numbers on your sinch account)
INTERFACE_NAME (the network interface whose IP address you want to know)
TARGET_SMS_NUMBER (the target SMS number where the message will be sent)
```

2. Then run `make build`, and

3. Then run `make run`

## Notes:

This container will send the LAN IP address message once on startup, then it will sleep forever. If it is restarted (e.g., after a power cycle) it will send a new message (possibly with a new IP address since the local DHCP server may assign it a new one). This code is dumber than you might want it to be since it does not monitor the IP address to see if it has changed over time. But a reboot should fix it if its IP address changes. If anyone wanted to submit a PR that does that monitoring and automates sending a new message, that would be cool. :-) 

The `docker run` command must include the `--net=host` flag so the container can discern the LAN IP address assigned to the specified INTERFACE_NAME.
