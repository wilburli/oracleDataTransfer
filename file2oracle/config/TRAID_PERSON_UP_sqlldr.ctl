OPTIONS(BINDSIZE=2097152,READSIZE=2097152,ERRORS=-1,ROWS=50000)
LOAD DATA
INFILE './config/outdata/TRAID_PERSON_UP.dat'
REPLACE INTO TABLE TRAID_PERSON_UP
FIELDS TERMINATED BY x'1b' TRAILING NULLCOLS 
(
  "ID" CHAR(46) NULLIF "ID"=BLANKS,
  "DEPT_NAME" CHAR(200) NULLIF "DEPT_NAME"=BLANKS,
  "NAME" CHAR(200) NULLIF "NAME"=BLANKS,
  "DUTY" CHAR(200) NULLIF "DUTY"=BLANKS,
  "PHONE" CHAR(200) NULLIF "PHONE"=BLANKS,
  "USERID" CHAR(200) NULLIF "USERID"=BLANKS,
  "TYPE_BASE" CHAR(50) NULLIF "TYPE_BASE"=BLANKS,
  "DEPTID" CHAR(20) NULLIF "DEPTID"=BLANKS,
  "SON_USER_ID" CHAR(24) NULLIF "SON_USER_ID"=BLANKS,
  "CREATE_TIME" TIMESTAMP "YYYY-MM-DD HH24:MI:SSXFF" NULLIF "CREATE_TIME"=BLANKS,
  "UPDATE_TIME" TIMESTAMP "YYYY-MM-DD HH24:MI:SSXFF" NULLIF "UPDATE_TIME"=BLANKS
)