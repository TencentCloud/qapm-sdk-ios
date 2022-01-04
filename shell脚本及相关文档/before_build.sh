#!/bin/sh
#
# Copyright 2018 QAPM, Tencent. All rights reserved.
#
# V1.0
#
# 2020.05.18
#
# create by QAPM
#
#
############################################################
# 1. 脚本集成到Xcode工程的Target
############################################################

############################################################
#########				脚本说明					   #########	
#
# 该脚本作用是往主工程的plist文件中插入com.tencent.qapm.uuid，
# 目的是为了上传符号表以及后续堆栈翻译可以共用同一个uuid
# 先执行Delete是因为如果存在该字段的话直接Add会失败
# 如无该字段，删除也会失败，无需担心

#########				脚本说明					   #########
############################################################


############################################################
########                需要修改的区域                ######## 
#                                                          
# 主工程的plist文件绝对路径,PROJECT_DIR为工程目录
# 请修改成自己对应的plist文件
INFO_PLIST_FILE="${PROJECT_DIR}/xxxxx.plist"
#
########                需要修改的区域                ######## 
############################################################

function injection() {
    randomUUID=$(uuidgen)
    randomUUID=$(echo $randomUUID | tr 'A-Z' 'a-z')
    /usr/libexec/PlistBuddy -c "Delete com.tencent.qapm.uuid" $1
    /usr/libexec/PlistBuddy -c "Add com.tencent.qapm.uuid string ${randomUUID}" $1
}

injection $INFO_PLIST_FILE
