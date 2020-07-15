# file2oracle

#### 介绍
    通过调用sqlldr，将oracle数据快速导入文件，可通过配置sql脚本执行


#### 软件架构
    config                #配置文件
	  -- outdata           #数据文件
    file2oracle.sh        #核心脚本

#### 使用说明
    file2oracle.sh ./config 20200702 
    #./config 配置文件地址
    #20200702  日志文件名
    
