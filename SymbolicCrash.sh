#!/bin/sh

# 首先判断是否有相关的文件
dSYMPath=`find . -iname "*.dSYM"`
XcodeName=""

# 获取Xcode的名称
function getXcodeName() {
    # 获取Xcode名
    echo "请输入Xcode的名称:"
    read ANS

    XcodeName="$ANS"
    if [ -z "$XcodeName" ]; then
        getXcodeName
    else
        symbolicatecrash
    fi
}

# 获取Xcode的symbolicatecrash脚本
function symbolicatecrash() {
    # 拷贝Xcode自带的symbolicatecrash脚本到当前目录
    cp /Applications/${XcodeName}.app/Contents/Developer/Platforms/AppleTVSimulator.platform/Developer/Library/PrivateFrameworks/DVTFoundation.framework/symbolicatecrash .

    analyze
}

# 解析
function analyze() {

    crashFiles=`find . -iname "*.crash"`

    export DEVELOPER_DIR="/Applications/${XcodeName}.app/Contents/Developer"

    for fileName in $crashFiles; do
        {
           ./symbolicatecrash $fileName $dsymPath > $fileName.log
        }

    done
}

function beginShell() {
    if [  -z "$dSYMPath" ]; then
        echo "没有找到dSYM文件!"
    else
        getXcodeName
    fi
}

beginShell

