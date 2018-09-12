#!/bin/bash

#全局执行结果标志位，有一步出错后日志不会继续输出
#考虑到子Shell与父Shell进程间通信，使用文件作为标志位进行信息传递和判断
export GLOBAL_FAIL_FLAG="$(pwd)/globalFailFlag.tag"

#是否加入标签TAG标志位，默认为default
#如： . ./logForShell.sh default
#需要加入TAG时，调用该脚本时传入TAG参数
#如： . ./logForShell.sh [Shell]
if [ "${1}" != "default" ];then
	TAG_FOR_SHELL=${1}
else
	TAG_FOR_SHELL=""
fi

#核心打印函数：用于区分关键与非关键日志
#正常log前加时间戳，这样如svn cp等命令打印的内容没有时间戳
#打印日志前加入自定义标签，方便过滤检索

function Show(){
	dateStr=`echo $(date +%Y-%m-%d) $(date +[%H:%M:%S])`
	if [ ! -f ${GLOBAL_FAIL_FLAG} ]; then
		echo "${dateStr} ${TAG_FOR_SHELL} $@"
	fi

}

#空行打印函数：请在非关键日志如svn,cp,wget等命令前打印一个空行

function BlankLine(){
	echo ""
}

#纯净打印函数：无时间戳无标签无格式

function NoFormatShow(){
	echo "$@"
}

#步骤打印函数：需要传入$1：步骤序号，$2：步骤描述
#如： Step 1 "Copy Unity Resource"

function Step(){
	sourceFileName=`caller`
	Show ""
	Show "==================== ${sourceFileName##*/}  STEP $1 : $2 ===================="
	Show ""
}

#进入脚本函数：在关键脚本开始时执行，调用时需要传入执行脚本的所有参数
#如： BeforeShell $@

function BeforeShell(){
	sourceFileName=`caller`
	Show ""
	Show "   +   ${sourceFileName##*/}  BEGIN   +"
	Show "   +   ${sourceFileName##*/} $@   +"
	Show ""
}

#退出脚本函数：在脚本结束时执行
#如： AfterShell

function AfterShell(){
	sourceFileName=`caller`
	Show ""
	Show "   +   ${sourceFileName##*/}  FINISH   +"
}

#错误报告函数：在某一步结束后判断执行结果，若出错则调用该函数
#如： ReportFailure
#该函数会改变执行结果标志位，阻止出错后日志继续输出

function ReportFailure(){
	touch ${GLOBAL_FAIL_FLAG}
	echo ""
	echo ""
	echo "****     line `caller` REPORTED FAILURE     ****"
	echo ""
	echo ""
	# 通过循环判断caller返回，如果不为空则持续打印，最多打印5行
	echo "    CALLER LIST    "
	echo " - line `caller 0`"
	for loop in 1 2 3 4
	do
		if [ "`caller ${loop}`" != "" ];then
			echo " - line `caller ${loop}`"
		else
			echo ""
			break
		fi
	done
}

#成功报告函数：在关键步骤结束后判断执行结果，成功则调用该函数
#一般步骤不用调用该函数输出
#如： ReportSuccess "Init and check related params"

function ReportSuccess(){
	echo ""
	echo "****     $1 SUCCESS      ****"
	echo ""
}

#清理标志位函数：在加载logForShell函数后，务必在主入口脚本所有语句执行前调用

function CleanFlagBeforeStart(){
	if [ -f ${GLOBAL_FAIL_FLAG} ]; then
		rm -f ${GLOBAL_FAIL_FLAG}
	fi
}