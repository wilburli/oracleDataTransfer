
###############################################################################################
ORA_USER=vids
ORA_PWD=vids123
ORA_HOST=10.30.17.84
ORA_PORT=1521
ORA_SID=orclvids
CMD="sqlldr"

###############################################################################################

CMD="$CMD $ORA_USER/$ORA_PWD"
#获取配置文件列表
#curpath=$(cd `dirname $0`;pwd)
cf_forderpath=$1
v_data_date=$2

curpath=$(cd `dirname $0`;pwd)

logpath=$curpath/logs/
logfilepath="${logpath}/${v_data_date}.log"
rm -rf $logfilepath

f_count=`ls ${cf_forderpath}/|grep '.ctl$'|wc -l`
echo "`date +"%Y-%m-%d %H:%M:%S"` 共【$f_count】项任务" 
b=''
let i=0
let j=0
startp=1
printf "\r\n"

softfiles=$(ls $cf_forderpath | grep '.ctl$')
for file in $softfiles
do
echo "`date +"%Y-%m-%d %H:%M:%S"` $cf_forderpath/$file" 
    if test -f "$cf_forderpath/$file";
    then
		echo "`date +"%Y-%m-%d %H:%M:%S"` test2" 
        cf_filepath=$cf_forderpath/$file 
        tmpname=${file##*/}
        cf_filename=${tmpname%.*}
        echo "cf_filepath：$cf_filepath " >> $logfilepath
        echo "cf_filename：$cf_filename" >> $logfilepath
        rm -rf ${cf_filepath}_exec
        cp ${cf_filepath} ${cf_filepath}_exec
        #sed -i 's/\$dt/'${v_data_date}'/g' ${cf_filepath}_exec   
        CMDRUN="$CMD control=${cf_filepath}_exec log=${cf_filename}.log; "
		echo "SQL---TEST：$CMDRUN "
        echo "`date +"%Y-%m-%d %H:%M:%S"` IMPORT BEGING：${cf_filename}.dat" >> $logfilepath
        $CMDRUN >> $logfilepath 2>&1
        echo "`date +"%Y-%m-%d %H:%M:%S"` IMPORT END：${cf_filename}.dat" >> $logfilepath
        
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
echo "`date +"%Y-%m-%d %H:%M:%S"` 全部导入完成"