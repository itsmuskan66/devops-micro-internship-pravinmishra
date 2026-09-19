#!/bin/bash

# Notification script for deployment alerts

NOTIFICATION_ENDPOINT="${NOTIFICATION_ENDPOINT:-https://hooks.example.com/notify}"

send_notification() {
  local message="$1"
  curl -s -X POST "$NOTIFICATION_ENDPOINT" \
    -H "Content-Type: application/json" \
    -d "{\"text\": \"$message\"}"
}

send_notification "Deployment completed successfully"
