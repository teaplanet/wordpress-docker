#!/bin/sh
sudo docker run -p 127.0.0.1:10022:22 -p 127.0.0.1:10080:80 -v /data/blog:/blog:rw ken/blog

# debug
#sudo docker run -i -t -p 127.0.0.1:10022:22 -p 127.0.0.1:10080:80 -v /data/blog:/blog:rw ken/blog /bin/bash
