FROM rabbitmq

ADD rabbitmq.config /etc/rabbitmq/rabbitmq.config
ADD certs /certs

ADD http://www.rabbitmq.com/community-plugins/v3.6.x/rabbitmq_auth_backend_http-3.6.x-3dfe5950.ez /plugins/
RUN chmod 777 /plugins/*

RUN rabbitmq-plugins enable --offline rabbitmq_mqtt
RUN rabbitmq-plugins enable --offline rabbitmq_amqp1_0
RUN rabbitmq-plugins enable --offline rabbitmq_auth_backend_http
RUN rabbitmq-plugins enable --offline rabbitmq_auth_mechanism_ssl
