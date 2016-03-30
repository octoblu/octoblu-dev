#!/bin/bash

unset PORT
growl-express >/dev/null 2>&1 &
echo $! >/tmp/growl-express.pid

sleep 1
curl -s -H "Content-Type: application/json" -X POST -d '{
  "notifications": [
    { "label": "default", "icon": "http://imgur.com/amjVCj6.jpg" },
    { "label": "success", "icon": "http://imgur.com/WjZjXjP.jpg" },
    { "label": "error", "icon": "http://imgur.com/rvtftG9.jpg" }
  ] }' http://localhost:23054/register >/dev/null 2>&1 &

echo + growl-express
