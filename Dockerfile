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