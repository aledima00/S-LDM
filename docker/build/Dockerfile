FROM mylib/sldm-prebuild:latest

# Copy the S-LDM source code inside the container
COPY . /home/sldm/SLDM
# Set ownership and permissions for the SLDM folder
RUN chown -R sldm:sldm /home/sldm/SLDM && \
    chmod -R 755 /home/sldm/SLDM

USER sldm

# Compile the S-LDM
RUN cd /home/sldm/SLDM && \
    make fullclean && \
    make


WORKDIR /home/sldm/SLDM
# EXPOSE 5671 5672 8161

CMD ["/bin/sh", "-c", "./SLDM -A ${SLDM_INTERNAL_AREA} --ext-area-lat-factor ${SLDM_EXTERNAL_AREA_LAT_FACTOR} --ext-area-lon-factor ${SLDM_EXTERNAL_AREA_LON_FACTOR} --broker-url ${BROKER_URL} --broker-queue ${AMQP_TOPIC} --ms-rest-address ${MS_REST_ADDRESS} --ms-rest-port ${MS_REST_PORT} --vehviz-nodejs-address ${VEHVIZ_UDP_ADDRESS} --vehviz-nodejs-port ${VEHVIZ_UDP_PORT} --vehviz-web-port ${VEHVIZ_WEB_PORT} -L ${LOG_FILE} ${SLDM_OTHER_OPTIONS}"]
