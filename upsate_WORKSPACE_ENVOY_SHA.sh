# created by tetraloba (2026/07/22 15:48)
GIT_REMOTE_URL="https://github.com/tetraloba/envoy.git"
BRANCH="feat/tetraloba"

ENVOY_SHA=$(git ls-remote ${GIT_REMOTE_URL} ${BRANCH} | cut -f 1)
wget https://github.com/tetraloba/envoy/archive/${ENVOY_SHA}.tar.gz && ENVOY_SHA256=$(sha256sum ${ENVOY_SHA}.tar.gz | cut -d ' ' -f 1) && rm ${ENVOY_SHA}.tar.gz
# echo ENVOY_SHA256=$ENVOY_SHA256 # debug
cp WORKSPACE WORKSPACE.old
sed -E "s/ENVOY_SHA = \"[0-9a-f]{40}\"/ENVOY_SHA = \"${ENVOY_SHA}\"/g" WORKSPACE.old | sed -E "s/ENVOY_SHA256 = \"[0-9a-f]{64}\"/ENVOY_SHA256 = \"${ENVOY_SHA256}\"/g" > WORKSPACE
diff WORKSPACE.old WORKSPACE # debug

