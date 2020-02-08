# docker-elk-setup-security
Set up the security when using the elk stack from docker hub [sebp/elk](https://hub.docker.com/r/sebp/elk/)

## How to apply:

* We will replace elk configration files to setup the security.
1. Adding this line to **elasticsearch.yml** to enable the security.
```
xpack.security.enabled: true
```
2. Adding these lines to **logstash.yml**. Make sure to replace the password.
```
xpack.monitoring.enabled: true
xpack.monitoring.elasticsearch.username: logstash_system
xpack.monitoring.elasticsearch.password: logstashpass
```
3. Adding these lines to **kibana.yml**. Make sure to replace the password.
```
xpack.monitoring.ui.container.elasticsearch.enabled: true
elasticsearch.username: kibana
elasticsearch.password: kibanapassword
```
4. We will also need to set the credentials in the logstash pipeline.
So we will add these line to **30-output.conf**. Make sure to replace the password.
```
output {
  elasticsearch {
    hosts => ["localhost:9200"]
    user => "elastic"
    password => "elasticpassword"
  }
}
```
5. We will we will write the **Dockerfile**  to replace the files when we build the image.
```
FROM sebp/elk
# overwrite existing file
RUN rm /etc/logstash/conf.d/30-output.conf
COPY 30-output.conf /etc/logstash/conf.d/30-output.conf 
RUN rm /etc/logstash/conf.d/02-beats-input.conf
COPY 02-beats-input.conf /etc/logstash/conf.d/02-beats-input.conf
RUN rm /etc/elasticsearch/elasticsearch.yml
COPY elasticsearch.yml /etc/elasticsearch/elasticsearch.yml
RUN rm /opt/logstash/config/logstash.yml
COPY logstash.yml /opt/logstash/config/logstash.yml
RUN rm /opt/kibana/config/kibana.yml
COPY kibana.yml /opt/kibana/config/kibana.yml
```
6. Navigate to these files directory, and then run the following command to build the image.
```
docker build . --tag docker-elk
```
7. Now we will run the container using this command.
```
docker run -p 5601:5601 -p 9200:9200 -p 5044:5044 -it --name elk docker-elk
```

## Finally, we need to setup the passwords using container bash:

8. Run this command to enter to the container bash. 
```
docker exec -it elk bin/bash
```
9. Navigate to elastic search.
```
cd opt/elasticsearch
```
10. Run this command, and you will be asked to set the passwords for all built-in elk users.
Make sure you enter the same password you wrote in the steps 2, 3, and 4.
```
bin/elasticsearch-setup-passwords interactive
```

After setting the passwords everything should work fine, head up to kibana and check :)

## Resources:

https://www.elastic.co/guide/en/x-pack/6.2/setting-up-authentication.html#bootstrap-elastic-passwords

