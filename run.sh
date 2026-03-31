TZ="Europe/Rome"
SLDM_INTERNAL_AREA="45.059:7.670-45.071:7.685"
SLDM_EXTERNAL_AREA_LAT_FACTOR="0.000001"
SLDM_EXTERNAL_AREA_LON_FACTOR="0.000001"
BROKER_URL="127.0.0.1:5672"
AMQP_TOPIC="topic://5gcarmen.examples"
MS_REST_ADDRESS=http://localhost
MS_REST_PORT=8000
VEHVIZ_UDP_ADDRESS=127.0.0.1
VEHVIZ_UDP_PORT=48110
VEHVIZ_WEB_PORT=8080
VEHVIZ_UPDATE_INTERVAL_S=0.1
#LOG_FILE="logs/log.txt"
GNN_SNAPSHOT_PATH="gnn/input/lb3.2seq.pth"
GNN_CSV_OUT_PATH="out/prediction.csv"
GNN_STEP_LEN_MS=100
GNN_PACK_SIZE=80
GNN_STRIDE=5
GNN_TRIGGERING_THRESHOLD=0.5
GNN_NETOFFSET="250.00,-6.24"
DISABLE_GNN_TRIGGER="--disable-gnn-trigger"

bash -c "./SLDM --disable-misbehaviour-detector --disable-quadkey-filter --gnn-snapshot-path ${GNN_SNAPSHOT_PATH} --gnn-csv-out-path ${GNN_CSV_OUT_PATH} --gnn-step-len ${GNN_STEP_LEN_MS} --gnn-pack-size ${GNN_PACK_SIZE} --gnn-stride ${GNN_STRIDE} --gnn-triggering-threshold ${GNN_TRIGGERING_THRESHOLD} --gnn-sumo-netoffset ${GNN_NETOFFSET} -A ${SLDM_INTERNAL_AREA} --ext-area-lat-factor ${SLDM_EXTERNAL_AREA_LAT_FACTOR} --ext-area-lon-factor ${SLDM_EXTERNAL_AREA_LON_FACTOR} --broker-url ${BROKER_URL} --broker-queue ${AMQP_TOPIC} --ms-rest-address ${MS_REST_ADDRESS} --ms-rest-port ${MS_REST_PORT} --vehviz-nodejs-address ${VEHVIZ_UDP_ADDRESS} --vehviz-nodejs-port ${VEHVIZ_UDP_PORT} --vehviz-web-port ${VEHVIZ_WEB_PORT} --vehviz-update-interval ${VEHVIZ_UPDATE_INTERVAL_S}"