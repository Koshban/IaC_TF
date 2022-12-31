#!/bin/bash
echo "Hello World, Here I come!!" > index.html
nohup busybox httpd -f -p 8080 &
