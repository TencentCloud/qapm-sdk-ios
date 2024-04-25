#!/bin/sh
#
# Copyright 2020 QAPM, Tencent. All rights reserved.
#
# V1.0.1
#
# 2020.02.25
#
#
#QAPM_APP_KEY="请正确填写申请产品时的appkey"
#QAPM AppKey
QAPM_APP_KEY="appKey"
#请正确填写QAPM初始化时填写的对应的host域名
# QAPM服务域名，比如域名为https://qapm.qq.com，则QAPM_DSYM_UPLOAD_DOMAIN="qapm.qq.com",公有云内网用户域名为sngapm.qq.com
QAPM_DSYM_UPLOAD_DOMAIN="qapm.qq.com"
#请正确填写业务APP的productName名称，如示例demo的productName为QAPM,则QAPM_DSYM_NAME="QAPM"
QAPM_DSYM_NAME="QAPM"
SHELL_FOLDER=$(cd "$(dirname "$0")";pwd)
P_QAPM_APPKEY=${QAPM_APP_KEY%-*}
P_QAPM_PID=${QAPM_APP_KEY#*-}
QAPM_DSYM_UUID=$(dwarfdump --uuid "${SHELL_FOLDER}/${QAPM_DSYM_NAME}.app.dSYM")
if [ ! "$QAPM_DSYM_UUID" ]; then
    echo "符号表文件不存在，或者已经损坏，请检查符号表文件"
    exit 0
    else
    echo "符号表文件正常"
fi


QAPM_DSYMARM64_UUID=${QAPM_DSYM_UUID}
QAPM_DSYM_ARM64_UUID=${QAPM_DSYMARM64_UUID##*UUID}
DSYM_ARM64_UUID=$(echo ${QAPM_DSYM_ARM64_UUID:0:37} | tr '[a-z]' '[A-Z]')
echo "DSYM_ARM64_UUID:${DSYM_ARM64_UUID}"

QAPM_ARM32_UUID=$(echo ${QAPM_DSYM_UUID:5:38} | tr '[a-z]' '[A-Z]')
echo "DSYM_ARM32_UUID:${QAPM_ARM32_UUID}"

SYMBOL_OUTPUT_PATH="${SHELL_FOLDER}/QAPMUPLOAD.zip"
zip -r QAPMUPLOAD.zip *.dSYM

echo "SYMBOL_OUTPUT_PATH: ${SYMBOL_OUTPUT_PATH}"
# 获取token
function getToken() {

TOKEN_STATUS=$(/usr/bin/curl "https://${QAPM_DSYM_UPLOAD_DOMAIN}/api/v2/public/getToken?app_key=$QAPM_APP_KEY&username=OA::kevineluo")

echo "QAPM server get token response: ${TOKEN_STATUS}"

json=$(echo "$TOKEN_STATUS" | jq .)

# 使用 jq 解析 JSON 并检查 status 字段
if [ "$(echo "$json" | jq -r '.status')" == "ok" ]; then
    # 如果 status 是 "ok"，则提取 data 字段的值
        P_QAPM_TOKEN=$(echo "$json" | jq -r '.data')
    echo "Token data value: $P_QAPM_TOKEN"
else
    # 如果 status 不是 "ok"，则输出错误信息
    echo "Error: The status is not 'ok'."
fi

}

 getToken $QAPM_APP_KEY

if [ ! "$P_QAPM_TOKEN" ]; then
    echo "Get token failed"
exit 0

else
    echo "Get token Success"
fi

# 上传bSYMBOL文件
function dSYMUpload() {

    P_PID="$P_QAPM_PID"
    P_BSYMBOL_ZIP_FILE="$SYMBOL_OUTPUT_PATH"

    echo "zip file path : ${P_BSYMBOL_ZIP_FILE}"

    #
    P_BSYMBOL_ZIP_FILE_NAME=${P_BSYMBOL_ZIP_FILE##*/}
    P_BSYMBOL_ZIP_FILE_NAME=${P_BSYMBOL_ZIP_FILE_NAME//&/_}
    P_BSYMBOL_ZIP_FILE_NAME="${P_BSYMBOL_ZIP_FILE_NAME// /_}"
    
    DSYM_UPLOAD_URL="https://${QAPM_DSYM_UPLOAD_DOMAIN}/api/v2/translator/v1/symbolmap/file?app_id=${P_PID}&build_id=${DSYM_ARM64_UUID}&platform=ios&re_upload=true"
    
    echo "dSYM upload url: ${DSYM_UPLOAD_URL}"

    echo "-----------------------------"
     STATUS_ARM64=$(/usr/bin/curl -H "X-Token: ${P_QAPM_TOKEN}" -H "X-AppId: ${P_PID}" -k "${DSYM_UPLOAD_URL}" --form "symbolmap_file=@${P_BSYMBOL_ZIP_FILE}" --verbose)
     
    echo "curl is ${STATUS_ARM64}"
    ARM64_UPLOAD_RESULT="FAILTURE"
    echo "QAPM_ARM64 server response: ${STATUS_ARM64}"

    #if [ ! "${STATUS_ARM64}" ]; then
    #    echo "Error: Failed to upload the arm64_zip archive file."
    #elif [[ "${STATUS_ARM64}" == *"{\"status\": \"ok\""* ]]; then
    #    echo "ARM64_Success to upload the dSYM for the app"
    #    ARM64_UPLOAD_RESULT="SUCCESS"
    #else
    #    echo "Error: Failed to upload the arm64_zip archive file to QAPM."
    #fi

    echo "--------------------------------"
    echo "${STATUS_ARM64} - ARM64_dSYM upload complete."

    if [[ "${STATUS_ARM64}" == "FAILTURE" ]]; then
        echo "--------------------------------"
        echo "Failed to upload the dSYM"
        echo "Please check the script and try it again."
    fi
    echo "--------------------------------"
    
    STATUS_ARM32=$(/usr/bin/curl -H "X-Token: ${P_QAPM_TOKEN}" -H "X-AppId: ${P_PID}" -k "${DSYM_UPLOAD_URL}" --form "symbolmap_file=@${P_BSYMBOL_ZIP_FILE}" --verbose)

  
    ARM32_UPLOAD_RESULT="FAILTURE"
    echo "QAPM_ARM32 server response: ${STATUS_ARM32}"
    

    echo "--------------------------------"
    echo "${STATUS_ARM32} - ARM32_dSYM upload complete."

    if [[ "${STATUS_ARM32}" == "FAILTURE" ]]; then
        echo "--------------------------------"
        echo "Failed to upload the dSYM"
        echo "Please check the script and try it again."
    fi
    
    
    echo "curl is ${STATUS_ARM32}"
    echo "curl pid ${P_PID}"
    echo "curl fileName: ${P_BSYMBOL_ZIP_FILE_NAME}"
    echo "curl zip file: ${P_BSYMBOL_ZIP_FILE}"
    echo "-----------------------------"
}

# 执行
function run() {
 dSYMUpload
}
run ${P_QAPM_PID} ${SYMBOL_OUTPUT_PATH}





