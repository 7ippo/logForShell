#!/bin/bash

#如何区分出一些非关键log呢
#正常log前加时间戳，这样如svn cp等命令打印的内容没有时间戳
#因此区分了出来
dateStr=`echo $(date +%Y-%m-%d) $(date +[%H:%M:%S])`

#全局执行结果标志位，有一步出错后日志不会继续输出
RESULTFLAG="SUCC"

_SHOWLOG(){
	if [ "$RESULTFLAG" = "SUCC" ]; then
		echo ${dateStr} "$@"
	fi

}


#步骤打印函数：需要传入$1：步骤序号，$2：步骤描述
#如： _STEP 1 "Copy Unity Resource"

_STEP(){
	_SHOWLOG ""
	_SHOWLOG "==================== STEP $1 : $2 IN $0 ===================="
	_SHOWLOG ""
}

#进入脚本函数：在关键脚本开始时执行，调用时需要传入执行脚本的所有参数
#如： _BEFORESHELL $@

_BEFORESHELL(){
	_SHOWLOG ""
	_SHOWLOG "   +   $0  BEGIN   +"
	_SHOWLOG "   +   $0 $@   +"
	_SHOWLOG ""
}

#退出脚本函数：在脚本结束时执行

_AFTERSHELL(){
	_SHOWLOG ""
	_SHOWLOG "   +   $0  FINISH   +"
	_SHOWLOG ""
}

#错误报告函数：在某一步结束后判断执行结果，若出错则调用该函数
#如：_FAILURE $LINENO
#该函数会改变执行结果标志位，阻止出错后日志继续输出
_FAILURE(){
	RESULTFLAG="FAIL"
	echo ""
	echo "****     line `caller` REPORTED FAILURE     ****"
	echo ""
	echo ""
	# 通过循环判断caller返回，如果不为空则持续打印，最多打印5行
	echo "    CALLER LIST    "
	echo " - line `caller 0`"
	for loop in 1 2 3 4
	do
		if [ "`caller $loop`" != "" ];then
			echo " - line `caller $loop`"
		else
			echo ""
			break
		fi
	done
}

#成功报告函数：在关键步骤结束后判断执行结果，成功则调用该函数
#一般步骤不用调用该函数输出

_SUCCESS(){
	echo ""
	echo "****     SUCCESS     ****"
	echo ""
}





