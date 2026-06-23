TZ="Europe/Rome"
SLDM_INTERNAL_AREA="45.059394:7.671071-45.070606:7.684931"
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
GNN_SNAPSHOT_PATH="gnn/input/f0_lc.pth"
GNN_CSV_OUT_DIR="out/f0_lc"
GNN_CSV_OUT_PATH="${GNN_CSV_OUT_DIR}"/gnn_out.csv
GNN_STEP_LEN_MS=100
GNN_PACK_SIZE=80
GNN_STRIDE=1
GNN_TRIGGERING_THRESHOLD=0.5
GNN_NETOFFSET="545.78,622.98"
# DISABLE_GNN_TRIGGER="--disable-gnn-trigger"

# if output dir does not exist, create it
if [ ! -d "${GNN_CSV_OUT_DIR}" ]; then
    echo "Output directory ${GNN_CSV_OUT_DIR} does not exist. Creating it..."
    mkdir -p "${GNN_CSV_OUT_DIR}"
fi

bash -c "./SLDM --disable-misbehaviour-detector --disable-quadkey-filter --gnn-snapshot-path ${GNN_SNAPSHOT_PATH} --gnn-csv-out-path ${GNN_CSV_OUT_PATH} --gnn-step-len ${GNN_STEP_LEN_MS} --gnn-pack-size ${GNN_PACK_SIZE} --gnn-stride ${GNN_STRIDE} --gnn-triggering-threshold ${GNN_TRIGGERING_THRESHOLD} --gnn-sumo-netoffset ${GNN_NETOFFSET} -A ${SLDM_INTERNAL_AREA} --ext-area-lat-factor ${SLDM_EXTERNAL_AREA_LAT_FACTOR} --ext-area-lon-factor ${SLDM_EXTERNAL_AREA_LON_FACTOR} --broker-url ${BROKER_URL} --broker-queue ${AMQP_TOPIC} --ms-rest-address ${MS_REST_ADDRESS} --ms-rest-port ${MS_REST_PORT} --vehviz-nodejs-address ${VEHVIZ_UDP_ADDRESS} --vehviz-nodejs-port ${VEHVIZ_UDP_PORT} --vehviz-web-port ${VEHVIZ_WEB_PORT} --vehviz-update-interval ${VEHVIZ_UPDATE_INTERVAL_S}"