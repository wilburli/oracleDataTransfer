# oracle2file

#### 介绍
    通过调用sqluldr2，将oracle数据快速导出文件，可通过配置sql脚本执行，


#### 软件架构
    config                #配置文件
    sqluldr2              #sqluldr2包，含window和linux版本
    oracle2file.sh        #核心脚本，需要修改里面的数据库相关信息

#### 使用说明
    oracle2file.sh ./config 20200702 ./outdata
	#参数说明
    #./config 配置文件地址
    #20200702 $dt
    #./outdata 数据文件输出目录
    


#### 环境配置
1.分配权限  chmod 777 *

2.locate libclntsh.so.10.1  查看位置
获取对于路径
/u01/app/oracle/oracle/product/10.2.0/db_1/lib/libclntsh.so.10.1
编辑/etc/ld.so.conf
vim /etc/ld.so.conf

在最后一行输入获取的路径
/u01/app/oracle/oracle/product/10.2.0/db_1/lib/

执行
ldconfig


#### 备注

sqlldr userid=vids/vids123 control=test.ctl log=test.log;



-- 合并更新数据 MERGE INTO table1 A USING table1c B ON (A.ID = B.ID) when matched then update set A.VAR_NAME= B.VAR_NAME,NAME= B.NAME,SEX= B.SEX,UPDATE_TIME= B.UPDATE_TIME