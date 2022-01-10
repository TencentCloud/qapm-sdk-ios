#!/bin/sh
#
# Copyright 2018 QAPM, Tencent. All rights reserved.
#
# V1.0.3
#
# 2020.05.18
#
# modify by QAPM
#
#
######################################################
# 1. 脚本集成到Xcode工程的Target
######################################################
#
# --- Copy the SCRIPT to the Run Script of Build Phases in the Xcode project ---
#
#
############################################################
#########               脚本说明                    #########
#
# 该脚本的作用是自动上传符号表，使用上个脚本生成的uuid，以及自动
# 搜寻生成目录下的符号表上传,需要修改的区域请根据自身情况修改
# 建议debug、模拟器编译的情况不要上传符号表
#
#
#########               脚本说明                    #########
############################################################


############################################################
########                需要修改的区域                ########
#
# # Debug模式编译是否上传，1＝上传 0＝不上传，默认不上传
UPLOAD_DEBUG_SYMBOLS=1

# # 模拟器编译是否上传，1=上传 0=不上传，默认不上传
UPLOAD_SIMULATOR_SYMBOLS=0

# #只有Archive操作时上传, 1=支持Archive上传 0=所有Release模式编译都上传
UPLOAD_ARCHIVE_ONLY=0

# QAPM服务域名,内网同学改成https://sngapm.qq.com，外网同学改成https://qapm.qq.com
QAPM_DSYM_UPLOAD_DOMAIN="https://qapm.qq.com"

#QAPM AppKey
QAPM_APP_KEY="55a11d57-4116"

# 主工程的plist文件绝对路径,PROJECT_DIR为工程目录
# 请修改成自己对应的plist文件
INFO_PLIST_FILE="${PROJECT_DIR}/QAPM_iOS_SDK_Demo/Info.plist"
#
########                需要修改的区域                ########
############################################################

P_QAPM_APPKEY=${QAPM_APP_KEY%-*}
P_QAPM_PID=${QAPM_APP_KEY#*-}

# 获取token
function getToken() {

    TOKEN_STATUS=$(/usr/bin/curl "${QAPM_DSYM_UPLOAD_DOMAIN}/web/${P_QAPM_PID}/api/getToken?app_key=${QAPM_APP_KEY}")

    echo "tokenurl is ${QAPM_DSYM_UPLOAD_DOMAIN}/web/${P_QAPM_PID}/api/getToken?app_key=${QAPM_APP_KEY}"

    echo "QAPM server get token response: ${TOKEN_STATUS}"
    if [ ! "${TOKEN_STATUS}" ]; then
        echo "Error: Failed to get the token."
    elif [[ "${TOKEN_STATUS}" == *"{\"status\": \"ok\""* ]]; then
        echo "Success to get token"
        P_QAPM_TOKEN=`expr "$TOKEN_STATUS" : '.*\"\(.*\)\"'`
        echo "The token is : $P_QAPM_TOKEN"
    else
        echo "Error: Failed to get token"
    fi
}

# 上传bSYMBOL文件
function dSYMUpload() {

    getToken

    if [ ! "$P_QAPM_TOKEN" ]; then
        echo "Get token failed"
        deleteUUID
        exit 0
    else
        echo "Get token Success"
    fi

    P_PID="$1"
    P_BSYMBOL_ZIP_FILE="$2"

    echo "zip file path : ${P_BSYMBOL_ZIP_FILE}"

    #
    P_BSYMBOL_ZIP_FILE_NAME=${P_BSYMBOL_ZIP_FILE##*/}
    P_BSYMBOL_ZIP_FILE_NAME=${P_BSYMBOL_ZIP_FILE_NAME//&/_}
    P_BSYMBOL_ZIP_FILE_NAME="${P_BSYMBOL_ZIP_FILE_NAME// /_}"

    DSYM_UPLOAD_URL="${QAPM_DSYM_UPLOAD_DOMAIN}/web/${P_PID}/common/symbolManagerUploadSubmit/"
    
    echo "dSYM upload url: ${DSYM_UPLOAD_URL}"

    uuid=$(/usr/libexec/PlistBuddy -c "Print com.tencent.qapm.uuid" ${INFO_PLIST_FILE})

    echo "dSYM upload uuid: ${uuid}"

    echo "-----------------------------"
    STATUS=$(/usr/bin/curl --location -H "token: ${P_QAPM_TOKEN}=" -k "${DSYM_UPLOAD_URL}" --form "p_id=${P_PID}" --form "fileName=${P_BSYMBOL_ZIP_FILE_NAME}" --form "file=@${P_BSYMBOL_ZIP_FILE}" --form "uuid_from_dsym=0" --form "rdmuuid=${uuid}" --form "need_load=True" --form "async_mode=1" --verbose)

    echo "curl is ${STATUS}"
    echo "curl pid ${P_PID}"
    echo "curl fileName: ${P_BSYMBOL_ZIP_FILE_NAME}"
    echo "curl zip file: ${P_BSYMBOL_ZIP_FILE}"
    echo "-----------------------------"

    UPLOAD_RESULT="FAILTURE"
    echo "QAPM server response: ${STATUS}"
    if [ ! "${STATUS}" ]; then
        echo "Error: Failed to upload the zip archive file."
    elif [[ "${STATUS}" == *"{\"status\": \"ok\""* ]]; then
        echo "Success to upload the dSYM for the app"
        UPLOAD_RESULT="SUCCESS"
    else
        echo "Error: Failed to upload the zip archive file to QAPM."
    fi

    if [ "$?" -ne 0 ]; then
        echo "Error: Failed to remove temporary zip archive."
        deleteUUID
        exit 0
    fi

    echo "--------------------------------"
    echo "${UPLOAD_RESULT} - dSYM upload complete."

    if [[ "${UPLOAD_RESULT}" == "FAILTURE" ]]; then
        echo "--------------------------------"
        echo "Failed to upload the dSYM"
        echo "Please check the script and try it again."
    fi

    deleteUUID
    echo "delete source zip : $P_BSYMBOL_ZIP_FILE"
    rm $P_BSYMBOL_ZIP_FILE
}

# 执行
function run() {
    CONFIG_QAPM_PID="$1"
    CONFIG_DSYM_SOURCE_DIR="$2"
    CONFIG_DSYM_DEST_DIR="$3"

    # 检查必须参数是否设置
    if [ ! "${CONFIG_QAPM_PID}" ]; then
        echo "Error: QAPM PID not defined."
        deleteUUID
        exit 0
    fi

    if [ ! -e "${CONFIG_DSYM_SOURCE_DIR}" ]; then
        echo "Error: Invalid dir1 ${CONFIG_DSYM_SOURCE_DIR}"
        deleteUUID
        exit 0
    fi

    if [ ! "${CONFIG_DSYM_DEST_DIR}" ]; then
        echo "Error: Invalid dir2 ${CONFIG_DSYM_DEST_DIR}"
        deleteUUID
        exit
    fi

    if [ ! -e "${CONFIG_DSYM_DEST_DIR}" ]; then
        mkdir ${CONFIG_DSYM_DEST_DIR}
    fi

    DSYM_FOLDER="${CONFIG_DSYM_SOURCE_DIR}" #/Users/jiangyunsheng/Desktop/dsym/TMF-Poc-Demo.app.dSYM
    IFS=$'\n'

    echo "Scaning dSYM FOLDER: ${DSYM_FOLDER} ..."
    RET="F"
    #用于存储多个符号表
    DSYM_MAP=()
    #
    for dsymFile in $(find "$DSYM_FOLDER" -name '*.dSYM'); do

        FILE_NAME=${dsymFile##*/}

        if [ ${#UPLOAD_SYMBOLS_LIST_ONLY[@]} -gt 0 ]; then
            for chooseFile in ${UPLOAD_SYMBOLS_LIST_ONLY[@]}; do
                if [ $chooseFile = $FILE_NAME ]; then
                    RET="T"
                    echo "Found dSYM file: $dsymFile"
                    DSYM_MAP[${#DSYM_MAP[@]}]=$dsymFile
                    
                fi
            done
        else
            RET="T"
            echo "Found dSYM file: $dsymFile"
            DSYM_MAP[${#DSYM_MAP[@]}]=$dsymFile
        fi
    done

    if [ $RET = "F" ]; then
        echo "No .dSYM found in ${DSYM_FOLDER}"
        deleteUUID
        exit 0
    fi

    zipAndUpload "${DSYM_MAP[*]}"
}

function zipAndUpload(){

    DSYM_FILE=$1

    echo "found ${DSYM_FILE[@]} dsym, prepare zip"

    echo "zipAndUpload"

    DSYM_SYMBOL_ZIP_FILE=""
    NOTE_DSYM=()

    # 每个符号表都要进行md5检查，这个可能会有3.5s左右的损耗，因为3.5一次循环，刚好判断生成就退出，如md5在判断后符号表就生成结束，则损耗3.5s
    for DSYM in ${DSYM_FILE[*]}; do
        DSYM_FILE_NAME=${DSYM##*/}
        REAL_DSYM_NAME=${DSYM_FILE_NAME%%.*}

        if [[ -z "$DSYM_SYMBOL_ZIP_FILE" ]]; then
            #statements
            DSYM_SYMBOL_ZIP_FILE="${CONFIG_DSYM_DEST_DIR}/QAPM_UPLOAD_DSYM.zip"
            echo "zip path = $DSYM_SYMBOL_ZIP_FILE"
        fi

        if [ -e $DSYM_SYMBOL_ZIP_FILE ]; then
            rm -f $DSYM_SYMBOL_ZIP_FILE
        fi

        # 如果只上传dSYM，直接压缩dSYM目录
        cd ${DSYM}

        DSYM_MD5="${DSYM}/Contents/Resources/DWARF/*" #这个路径不确定是否固定，*/Contents/Resources/DWARF/*

        echo "need md5 file = $DSYM_MD5"

        MD5_IS_SAME="false"

        while [ "$MD5_IS_SAME" == "false" ]
        do
            sleep 0.5 #睡3.5s，再次获取，时间太短，怕还没改变就又获取了一次
            getNewDsymSize
            echo "current dsym is $DSYM_FILE_NAME, old size = $OLDSIZE, new size = $NEWSIZE"
            # 对象对比判断
            if [ "${NEWSIZE}" == "$OLDSIZE" ];then
                #避免空符号表存在的情况，遇到过进来了这里，符号表还是空的情况,毕竟太大了
                if [ "$OLDSIZE" == "0B" ] || [ "$NEWSIZE" == "0B" ]; then
                    #statements
                    continue
                fi
                # 双保险，如果文件大小匹配了，再检查md5是否匹配，两者匹配则开始压缩上传
                generateNewMd5
                if [ -z "$OLDMD5" ] || [ -z "$NEWMD5" ] || [ "$OLDMD5" != "$NEWMD5" ]; then
                    #statements
                    continue
                fi
                echo "current dsym is $DSYM_FILE_NAME, old md5 = $OLDMD5, new md5 = $NEWMD5"
                echo "$DSYM_FILE_NAME is compelete"
                MD5_IS_SAME="true"
                break
            else
                echo "$DSYM_FILE_NAME is generating"
                OLDSIZE=$NEWSIZE
            fi
        done
        #生成结束后，记录文件名
        NOTE_DSYM[${#NOTE_DSYM[@]}]="../$DSYM_FILE_NAME"
    done
    echo "is all done,zip and upload"

    zip -r $DSYM_SYMBOL_ZIP_FILE ${NOTE_DSYM[*]} -x *.plist

    echo "zip success, upload now"

    dSYMUpload $CONFIG_QAPM_PID $DSYM_SYMBOL_ZIP_FILE
}


#符号表，第一次获取的MD5
OLDMD5=""
#符号表，获取最新的MD5
NEWMD5=""
#符号表，第一次获取大小
OLDSIZE=""
#符号表，获取最新的大小
NEWSIZE=""
#符号表具体的路径
DSYM_MD5=""

#生成MD5
function generateNewMd5() {
    OLDMD5=$(/usr/local/bin/md5sum -b $DSYM_MD5 | awk '{print $1}'|sed 's/ //g')
    sleep 2
    NEWMD5=$(/usr/local/bin/md5sum -b $DSYM_MD5 | awk '{print $1}'|sed 's/ //g')
}

#获取符号表大小
function getNewDsymSize() {
    NEWSIZE=$(du -h $DSYM_MD5 | awk '{print $1}')
}

#删掉上个脚本注入的uuid
function deleteUUID() {
    #最后操作，无论是否成功，清掉plist中的uuid字段
    echo "delete com.tencent.qapm.uuid : ${INFO_PLIST_FILE}"
    /usr/libexec/PlistBuddy -c "Delete com.tencent.qapm.uuid" ${INFO_PLIST_FILE}
}

# 在Xcode工程中执行
function runInXcode(){
    echo "Uploading dSYM to QAPM in Xcode ..."

    echo "Info.Plist : ${INFO_PLIST_FILE}"

    echo "--------------------------------"
    echo "Prepare application information."
    echo "--------------------------------"

    echo "Product Name: ${PRODUCT_NAME}"

    echo "QAPM PID: ${P_QAPM_PID}"

    echo "--------------------------------"
    
    echo "project dir: ${PROJECT_DIR}"
    echo "--------------------------------"

    echo "Check the arguments ..."

    randomUUID=$(/usr/libexec/PlistBuddy -c "Print com.tencent.qapm.uuid" ${INFO_PLIST_FILE})

    if [ -z "$randomUUID" ]; then
        #statements
        echo "get randomUUID failed, stop now"
        exit 0
    fi

    ##检查模拟器编译是否允许上传符号
    if [ "$EFFECTIVE_PLATFORM_NAME" == "-iphonesimulator" ]; then
        if [ $UPLOAD_SIMULATOR_SYMBOLS -eq 0 ]; then
            deleteUUID
            echo "Warning: Build for simulator and skipping to upload. \nYou can modify 'UPLOAD_SIMULATOR_SYMBOLS' to 1 in the script."
            exit 0
        fi
    fi

    ##检查是否是Release模式编译
    if [ "${CONFIGURATION=}" == "Debug" ]; then
        if [ $UPLOAD_DEBUG_SYMBOLS -eq 0 ]; then
            deleteUUID
            echo "Warning: Build for debug mode and skipping to upload. \nYou can modify 'UPLOAD_DEBUG_SYMBOLS' to 1 in the script."
            exit 0
        fi
    fi

    ##检查是否Archive操作
    if [ $UPLOAD_ARCHIVE_ONLY -eq 1 ]; then
        if [[ "$TARGET_BUILD_DIR" == *"/Archive"* ]]; then
            echo "Archive the package"
        else
            echo "Warning: Build for NOT Archive mode and skipping to upload. \nYou can modify 'UPLOAD_ARCHIVE_ONLY' to 0 in the script."
            deleteUUID
            exit 0
        fi
    fi

    run ${P_QAPM_PID} ${DWARF_DSYM_FOLDER_PATH} ${BUILD_DIR}/QAPMSymbolTemp
}

BuildInXcode="F"
if [ -f "${INFO_PLIST_FILE}" ]; then
    BuildInXcode="T"
fi

if [ $BuildInXcode = "T" ]; then
    runInXcode
else
    echo "需要运行在xcode环境下哦"
    # # 你可以在此处直接设置QAPMAppKey
    # QAPM_APP_KEY="$1"
    # DWARF_DSYM_FOLDER_PATH="$2"
    # SYMBOL_OUTPUT_PATH="$3"
    # run ${P_QAPM_PID} ${DWARF_DSYM_FOLDER_PATH} ${SYMBOL_OUTPUT_PATH}
fi
