# created by tetraloba (2026/07/22 15:48)
# hugelobaのproxyリポジトリにおいてWORKSPACEファイルを更新するためのスクリプト

set -e
SCRIPT_DIR=$(cd $(dirname $0); pwd)
WORKSPACE_FILE="${SCRIPT_DIR}/WORKSPACE"

GIT_REMOTE_URL="https://github.com/tetraloba/envoy.git"
BRANCH="feat/tetraloba"

# 正規表現参考
# > grep to output only needed capturing group
# > https://shscripts.com/grep-to-output-only-needed-capturing-group/
OLD_ENVOY_SHA=$(grep -oP '^ENVOY_SHA = "\K([0-9a-f]{40})(?=")' ${WORKSPACE_FILE})
NEW_ENVOY_SHA=$(git ls-remote ${GIT_REMOTE_URL} ${BRANCH} | cut -f 1)

OLD_ENVOY_SHA256=$(grep -oP '^ENVOY_SHA256 = "\K([0-9a-f]{64})(?=")' ${WORKSPACE_FILE})

wget https://github.com/tetraloba/envoy/archive/${NEW_ENVOY_SHA}.tar.gz &&
NEW_ENVOY_SHA256=$(sha256sum ${NEW_ENVOY_SHA}.tar.gz | cut -d ' ' -f 1) &&
rm ${NEW_ENVOY_SHA}.tar.gz

cp ${WORKSPACE_FILE} ${WORKSPACE_FILE}.old

# echo ENVOY_SHA256=$ENVOY_SHA256 # debug
sed -E "s/^ENVOY_SHA = \"${OLD_ENVOY_SHA}\"/ENVOY_SHA = \"${NEW_ENVOY_SHA}\"/g" ${WORKSPACE_FILE}.old |
sed -E "s/^ENVOY_SHA256 = \"${OLD_ENVOY_SHA256}\"/ENVOY_SHA256 = \"${NEW_ENVOY_SHA256}\"/g" > ${WORKSPACE_FILE}

echo "update envoy ${OLD_ENVOY_SHA:0:7} to ${NEW_ENVOY_SHA:0:7}" >> ${SCRIPT_DIR}/.commit_messages

diff ${WORKSPACE_FILE}.old ${WORKSPACE_FILE} # debug

