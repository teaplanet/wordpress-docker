#/bin/sh
sudo docker run -p 10080:80 -v /data/blog:/blog:rw ken/blog

# debug
#sudo docker run -i -t -p 10080:80 -v /data/blog:/blog:rw ken/blog /bin/bash
