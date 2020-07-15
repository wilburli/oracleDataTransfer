
###############################################################################################
ORA_USER=vids
ORA_PWD=vids123
ORA_HOST=10.30.17.84
ORA_PORT=1521
ORA_SID=orclvids
CMD="./sqluldr2/sqluldr2_linux64_10204.bin"

DELIMIT=0x1b   #分隔符
###############################################################################################

CMD="$CMD $ORA_USER/$ORA_PWD"
#获取配置文件列表
#curpath=$(cd `dirname $0`;pwd)
cf_forderpath=$1
v_data_date=$2
out_forderpath=$3

curpath=$(cd `dirname $0`;pwd)

logpath=$curpath/logs/
logfilepath="${logpath}/${v_data_date}.log"
rm -rf $logfilepath

if [ ! -d "$out_forderpath" ];then
	echo "`date +"%Y-%m-%d %H:%M:%S"` 输出路径设置错误，设置路径【$out_forderpath】不存在"
	mkdir $out_forderpath
    exit 1
fi

if [ ! -d "$out_forderpath/$v_data_date/" ];then
	mkdir "$out_forderpath/$v_data_date/"    
fi
out_forderpath="$out_forderpath/$v_data_date/"

f_count=`ls ${cf_forderpath}|wc -l`
echo "`date +"%Y-%m-%d %H:%M:%S"` 共【$f_count】项任务" 
b=''
let i=0
let j=0
startp=1
printf "\r\n"

softfiles=$(ls $cf_forderpath)
for file in $softfiles
do
echo "`date +"%Y-%m-%d %H:%M:%S"` $cf_forderpath/$file" 
    if test -f "$cf_forderpath/$file";
    then
		echo "`date +"%Y-%m-%d %H:%M:%S"` test2" 
        cf_filepath=$cf_forderpath/$file 
        tmpname=${file##*/}
        cf_filename=${tmpname%.*}
        echo "文件路径：$cf_filepath " >> $logfilepath
        echo "文件名：$cf_filename" >> $logfilepath
        rm -rf ${cf_filepath}_exec
        cp ${cf_filepath} ${cf_filepath}_exec
        #sed -i 's/\$dt/'${v_data_date}'/g' ${cf_filepath}_exec   
        CMDRUN="$CMD sql=${cf_filepath}_exec head=no file=${out_forderpath}/${cf_filename}.dat table=${cf_filename} field=$DELIMIT"
        echo "`date +"%Y-%m-%d %H:%M:%S"` 导出开始：${cf_filename}.dat" >> $logfilepath
        $CMDRUN >> $logfilepath 2>&1
        echo "`date +"%Y-%m-%d %H:%M:%S"` 导出完成：${cf_filename}.dat" >> $logfilepath
        
        ############################################################################
        sleep 1
        #printf "\r\n"
        i=$(($i+1))
        percent=$(($i*100/$f_count)) 
        for ((j=$startp;$j<=$percent;j+=1))
        do
            printf "`date +"%Y-%m-%d %H:%M:%S"` progress:[%-100s]%d%%\r" $b $j
            sleep 0.05
            b="#"$b
        done
        startp=$percent
        #printf "\r\n"
        ############################################################################
        rm -rf ${cf_filepath}_exec
    fi
done

printf "\r\n"
#设置错误码
errorcount=$(awk 'BEGIN{IGNORECASE=1}/ORA-/' "${logfilepath}"| wc -l)
if [ $errorcount -gt 0 ]; then 
    echo "`date +"%Y-%m-%d %H:%M:%S"` 【ERROR】执行存在错误,错误行数（${errorcount}）"
	cat ${logfilepath}
    #awk 'BEGIN{IGNORECASE=1}/ORA-/' "${logfilepath}"
    exit 1
fi
printf "\r\n"
echo "`date +"%Y-%m-%d %H:%M:%S"` 全部导出完成"