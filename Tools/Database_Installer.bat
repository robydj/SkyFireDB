@ECHO OFF
TITLE Database Installation Tool
COLOR 0A

:TOP
CLS
ECHO.
ECHO          浜様様様様様様様様様様様様様様様融
ECHO          �                                �
ECHO          �        Welcome to the DB       �
ECHO          �      SkyFireDB 406a Rev 120    �
ECHO          �        Installation Tool       �
ECHO          �                                �
ECHO          藩様様様様様様様様様様様様様様様夕
ECHO.
ECHO.
ECHO    Please enter your MySQL Info...
ECHO.
SET /p host= MySQL Server Address (e.g. localhost):
ECHO.
SET /p user= MySQL Username: 
SET /p pass= MySQL Password: 
ECHO.
SET /p world_db= World Database: 
SET port=3306
SET dumppath=.\dump\
SET mysqlpath=.\mysql\
SET devsql=..\MainDB\dev\
SET changsql=..\Updates
SET local_sp=\MainDB\locals\Spanish\
SET local_gr=\MainDB\locals\German\
SET local_ru=\MainDB\locals\Russian\
SER local_it=\MainDB\locals\Italian\

:Begin
CLS
SET v=""
ECHO.
ECHO.
ECHO    1 - Install 4.0.6a World Database and all updates, NOTE! Whole db will be overwritten!
ECHO.
ECHO    L - Apply Locals, "You need to install the database and updates first."
ECHO.
ECHO    W - Backup World Database.
ECHO    C - Backup Character Database.
ECHO    U - Import Changeset.
ECHO.
ECHO    S - Change your settings
ECHO.
ECHO    X - Exit this tool
ECHO.
SET /p v= 		Enter a char: 
IF %v%==* GOTO error
IF %v%==1 GOTO importDB
IF %v%==l GOTO locals
IF %v%==L GOTO locals
IF %v%==a GOTO 406sets
IF %v%==A GOTO 406sets
IF %v%==w GOTO dumpworld
IF %v%==W GOTO dumpworld
IF %v%==c GOTO dumpchar
IF %v%==C GOTO dumpchar
IF %v%==u GOTO changeset
IF %v%==U GOTO changeset
IF %v%==s GOTO top
IF %v%==S GOTO top
IF %v%==x GOTO exit
IF %v%==X GOTO exit
IF %v%=="" GOTO exit
GOTO error

:importDB
CLS
ECHO First Lets Create database (or overwrite old) !!
ECHO.
ECHO DROP database IF EXISTS `%world_db%`; > %devsql%\databaseclean.sql
ECHO CREATE database IF NOT EXISTS `%world_db%`; >> %devsql%\databaseclean.sql
	%mysqlpath%\mysql --host=%host% --user=%user% --password=%pass% --port=%port% < %devsql%\databaseclean.sql
@DEL %devsql%\databaseclean.sql

ECHO Lets make a clean database.
ECHO Importing Data now...
ECHO.
FOR %%C IN (%devsql%\*.sql) DO (
	ECHO Importing: %%~nxC
	%mysqlpath%\mysql --host=%host% --user=%user% --password=%pass% --port=%port% %world_db% < "%%~fC"
	ECHO Successfully imported %%~nxC
)
ECHO.
ECHO import: Changesets
for %%C in (%changsql%\*.sql) do (
	ECHO import: %%~nxC
	%mysqlpath%\mysql --host=%host% --user=%user% --password=%pass% --port=%port% %world_db% < "%%~fC"
)
ECHO Changesets imported sucesfully!
ECHO.
ECHO Your current 4.0.6a database is complete.
ECHO You don't need to apply any updates.
ECHO.
ECHO.
ECHO.
ECHO.
PAUSE
GOTO Begin

:dumpworld
CLS
IF NOT EXIST "%dumppath%" MKDIR %dumppath%
ECHO %world_db% Database Export started...

FOR %%a IN ("%devsql%\*.sql") DO SET /A Count+=1
setlocal enabledelayedexpansion
FOR %%C IN (%devsql%\*.sql) DO (
	SET /A Count2+=1
	ECHO Dumping [!Count2!/%Count%] %%~nC
	%mysqlpath%\mysqldump --host=%host% --user=%user% --password=%pass% --port=%port% --routines --skip-comments %world_db% %%~nC > %dumppath%\%%~nxC
)
endlocal 

ECHO  Finished ... %world_db% exported to %dumppath% folder...
PAUSE
GOTO begin

:locals
CLS
ECHO   Here is a list of locals.!!!)
ECHO.   
ECHO   Spanish        = S
ECHO   German         = G  "No Data Yet"
ECHO   Russian        = R  "No Data Yet"
ECHO   Italian        = I
ECHO.
ECHO   Return to main menu = B
ECHO.
set /p ch=      Number: 
ECHO.
IF %ch%==s GOTO install_sp
IF %ch%==S GOTO install_sp
IF %ch%==g GOTO install_gr
IF %ch%==G GOTO install_gr
IF %ch%==r GOTO install_ru
IF %ch%==R GOTO install_ru
IF %ch%==i GOTO install_it
IF %ch%==I GOTO install_it
IF %ch%==b GOTO begin
IF %ch%==B GOTO begin
IF %ch%=="" GOTO locals

:install_sp
ECHO Importing Spanish Data now...
ECHO.
FOR %%C IN (%local_sp%\*.sql) DO (
	ECHO Importing: %%~nxC1
	%mysqlpath%\mysql --host=%host% --user=%user% --password=%pass% --port=%port% %world_db% < "%%~fC"
	ECHO Spanish Locals Successfully imported %%~nxC1
)
ECHO Done.

:install_gr
ECHO Importing German Data now...
ECHO.
FOR %%C IN (%local_sp%\*.sql) DO (
	ECHO Importing: %%~nxC1
	%mysqlpath%\mysql --host=%host% --user=%user% --password=%pass% --port=%port% %world_db% < "%%~fC"
	ECHO German Locals Successfully imported %%~nxC1
)
ECHO Done.

:install_ru
ECHO Importing Russian Data now...
ECHO.
FOR %%C IN (%local_sp%\*.sql) DO (
	ECHO Importing: %%~nxC1
	%mysqlpath%\mysql --host=%host% --user=%user% --password=%pass% --port=%port% %world_db% < "%%~fC"
	ECHO Russian Locals Successfully imported %%~nxC1
)
ECHO Done.

:install_it
ECHO Importing Italian Data now...
ECHO.
FOR %%C IN (%local_it%\*.sql) DO (
	ECHO Importing: %%~nxC1
	%mysqlpath%\mysql --host=%host% --user=%user% --password=%pass% --port=%port% %world_db% < "%%~fC"
	ECHO Italian Locals Successfully imported %%~nxC1
)
ECHO Done.

:dumpchar
CLS
SET sqlname=char-%DATE:~0,3% - %DATE:~4,2%-%DATE:~7,2%-%DATE:~10,4%--%TIME:~0,2%-%TIME:~3,2%
SET /p chardb=   Enter name of your character DB:
ECHO.
IF NOT EXIST "%dumppath%" MKDIR %dumppath%
ECHO Dumping %sqlname%.sql to %dumppath%
%mysqlpath%\mysqldump -u%user% -p%pass% --result-file="%dumppath%\%sqlname%.sql" %chardb%
ECHO Done.
PAUSE
GOTO begin

:changeset
CLS
ECHO   Here is a list of changesets.!!!)
ECHO.   
ECHO   changeset 93 = 93
ECHO   changeset 94 = 94
ECHO   changeset 95 = 95
ECHO   changeset 96 = 96
ECHO   changeset 97 = 97
ECHO   changeset 98 = 98
ECHO   changeset 99 = 99
ECHO   changeset 100 = 100
ECHO   changeset 101 = 101
ECHO   changeset 102 = 102
ECHO   changeset 103 = 103
ECHO   changeset 104 = 104
ECHO   changeset 105 = 105
ECHO   changeset 106 = 106
ECHO   changeset 107 = 107
ECHO   changeset 108 = 108
ECHO   changeset 109 = 109
ECHO   changeset 110 = 110
ECHO   changeset 111 = 111
ECHO   changeset 112 = 112
ECHO   changeset 113 = 113
ECHO   changeset 114 = 114
ECHO   changeset 115 = 115
ECHO   changeset 116 = 116
ECHO   changeset 117 = 117
ECHO   changeset 118 = 118
ECHO   changeset 119 = 119
ECHO   changeset 120 = 120
ECHO.
ECHO   Or type in "A" to import all changesets
ECHO.
ECHO   Return to main menu = B
ECHO.
set /p ch=      Number: 
ECHO.
IF %ch%==a GOTO changesetall
IF %ch%==A GOTO changesetall
IF %ch%==93 GOTO changeset93
IF %ch%==94 GOTO changeset94
IF %ch%==95 GOTO changeset95
IF %ch%==96 GOTO changeset96
IF %ch%==97 GOTO changeset97
IF %ch%==98 GOTO changeset98
IF %ch%==99 GOTO changeset99
IF %ch%==100 GOTO changeset100
IF %ch%==101 GOTO changeset101
IF %ch%==102 GOTO changeset102
IF %ch%==103 GOTO changeset103
IF %ch%==104 GOTO changeset104
IF %ch%==105 GOTO changeset105
IF %ch%==106 GOTO changeset106
IF %ch%==107 GOTO changeset107
IF %ch%==108 GOTO changeset108
IF %ch%==109 GOTO changeset109
IF %ch%==110 GOTO changeset110
IF %ch%==111 GOTO changeset111
IF %ch%==112 GOTO changeset112
IF %ch%==113 GOTO changeset113
IF %ch%==114 GOTO changeset114
IF %ch%==115 GOTO changeset115
IF %ch%==116 GOTO changeset116
IF %ch%==117 GOTO changeset117
IF %ch%==118 GOTO changeset118
IF %ch%==119 GOTO changeset119
IF %ch%==120 GOTO changeset120
IF %ch%==b GOTO begin
IF %ch%==B GOTO begin
IF %ch%=="" GOTO changeset

:changeset93
CLS
ECHO.
ECHO import: Changeset 93
%mysqlpath%\mysql --host=%host% --user=%user% --password=%pass% --port=%port% %world_db% < %changsql%\93_world_gameobject_involvedrelation.sql
ECHO Changeset 93 imported sucesfully!
ECHO.
PAUSE   
GOTO changeset

:changeset94
CLS
ECHO.
ECHO import: Changeset 94
%mysqlpath%\mysql --host=%host% --user=%user% --password=%pass% --port=%port% %world_db% < %changsql%\94_world_creature.sql
ECHO Changeset 94 imported sucesfully!
ECHO.
PAUSE   
GOTO changeset

:changeset95
CLS
ECHO.
ECHO import: Changeset 95
%mysqlpath%\mysql --host=%host% --user=%user% --password=%pass% --port=%port% %world_db% < %changsql%\95_world_npc_vendor.sql
ECHO Changeset 95 imported sucesfully!
ECHO.
PAUSE   
GOTO changeset

:changeset96
CLS
ECHO.
ECHO import: Changeset 96
%mysqlpath%\mysql --host=%host% --user=%user% --password=%pass% --port=%port% %world_db% < %changsql%\96_world_item_template.sql
ECHO Changeset 96 imported sucesfully!
ECHO.
PAUSE   
GOTO changeset

:changeset97
CLS
ECHO.
ECHO import: Changeset 97
%mysqlpath%\mysql --host=%host% --user=%user% --password=%pass% --port=%port% %world_db% < %changsql%\97_world_gameobject_loot_template.sql
ECHO Changeset 97 imported sucesfully!
ECHO.
PAUSE   
GOTO changeset

:changeset98
CLS
ECHO.
ECHO import: Changeset 98
%mysqlpath%\mysql --host=%host% --user=%user% --password=%pass% --port=%port% %world_db% < %changsql%\98_world_gameobject_loot_template.sql
ECHO Changeset 98 imported sucesfully!
ECHO.
PAUSE   
GOTO changeset

:changeset99
CLS
ECHO.
ECHO import: Changeset 99
%mysqlpath%\mysql --host=%host% --user=%user% --password=%pass% --port=%port% %world_db% < %changsql%\99_world_npc_vendor.sql
ECHO Changeset 99 imported sucesfully!
ECHO.
PAUSE   
GOTO changeset

:changeset100
CLS
ECHO.
ECHO import: Changeset 100
%mysqlpath%\mysql --host=%host% --user=%user% --password=%pass% --port=%port% %world_db% < %changsql%\100_world_gameobject_loot_template.sql
ECHO Changeset 100 imported sucesfully!
ECHO.
PAUSE   
GOTO changeset

:changeset101
CLS
ECHO.
ECHO import: Changeset 101
%mysqlpath%\mysql --host=%host% --user=%user% --password=%pass% --port=%port% %world_db% < %changsql%\101_world_gameobject_template.sql
ECHO Changeset 101 imported sucesfully!
ECHO.
PAUSE   
GOTO changeset

:changeset102
CLS
ECHO.
ECHO import: Changeset 102
%mysqlpath%\mysql --host=%host% --user=%user% --password=%pass% --port=%port% %world_db% < %changsql%\102_world_gameobject_loot_template.sql
ECHO Changeset 102 imported sucesfully!
ECHO.
PAUSE   
GOTO changeset

:changeset103
CLS
ECHO.
ECHO import: Changeset 103
%mysqlpath%\mysql --host=%host% --user=%user% --password=%pass% --port=%port% %world_db% < %changsql%\103_world_gameobject_template.sql
ECHO Changeset 103 imported sucesfully!
ECHO.
PAUSE   
GOTO changeset

:changeset104
CLS
ECHO.
ECHO import: Changeset 104
%mysqlpath%\mysql --host=%host% --user=%user% --password=%pass% --port=%port% %world_db% < %changsql%\104_world_npc_template.sql
ECHO Changeset 104 imported sucesfully!
ECHO.
PAUSE   
GOTO changeset

:changeset105
CLS
ECHO.
ECHO import: Changeset 105
%mysqlpath%\mysql --host=%host% --user=%user% --password=%pass% --port=%port% %world_db% < %changsql%\105_world_gameobject_loot_template.sql
ECHO Changeset 105 imported sucesfully!
ECHO.
PAUSE   
GOTO changeset

:changeset106
CLS
ECHO.
ECHO import: Changeset 106
%mysqlpath%\mysql --host=%host% --user=%user% --password=%pass% --port=%port% %world_db% < %changsql%\106_world_gameobject_template.sql
ECHO Changeset 106 imported sucesfully!
ECHO.
PAUSE   
GOTO changeset

:changeset107
CLS
ECHO.
ECHO import: Changeset 107
%mysqlpath%\mysql --host=%host% --user=%user% --password=%pass% --port=%port% %world_db% < %changsql%\107_world_gameobject_loot_template.sql
ECHO Changeset 107 imported sucesfully!
ECHO.
PAUSE   
GOTO changeset

:changeset108
CLS
ECHO.
ECHO import: Changeset 108
%mysqlpath%\mysql --host=%host% --user=%user% --password=%pass% --port=%port% %world_db% < %changsql%\108_world_npc_Vendor.sql
ECHO Changeset 108 imported sucesfully!
ECHO.
PAUSE   
GOTO changeset

:changeset109
CLS
ECHO.
ECHO import: Changeset 109
%mysqlpath%\mysql --host=%host% --user=%user% --password=%pass% --port=%port% %world_db% < %changsql%\109_world_gameobject_loot_template.sql
ECHO Changeset 109 imported sucesfully!
ECHO.
PAUSE   
GOTO changeset

:changeset110
CLS
ECHO.
ECHO import: Changeset 110
%mysqlpath%\mysql --host=%host% --user=%user% --password=%pass% --port=%port% %world_db% < %changsql%\110_world_gameobject_template.sql
ECHO Changeset 110 imported sucesfully!
ECHO.
PAUSE   
GOTO changeset

:changeset111
CLS
ECHO.
ECHO import: Changeset 111
%mysqlpath%\mysql --host=%host% --user=%user% --password=%pass% --port=%port% %world_db% < %changsql%\111_world_creature_template.sql
ECHO Changeset 111 imported sucesfully!
ECHO.
PAUSE   
GOTO changeset

:changeset112
CLS
ECHO.
ECHO import: Changeset 112
%mysqlpath%\mysql --host=%host% --user=%user% --password=%pass% --port=%port% %world_db% < %changsql%\112_world_gameobject_involvedrelation.sql
ECHO Changeset 112 imported sucesfully!
ECHO.
PAUSE   
GOTO changeset

:changeset113
CLS
ECHO.
ECHO import: Changeset 113
%mysqlpath%\mysql --host=%host% --user=%user% --password=%pass% --port=%port% %world_db% < %changsql%\113_world_creature.sql
ECHO Changeset 113 imported sucesfully!
ECHO.
PAUSE   
GOTO changeset

:changeset114
CLS
ECHO.
ECHO import: Changeset 114
%mysqlpath%\mysql --host=%host% --user=%user% --password=%pass% --port=%port% %world_db% < %changsql%\114_world_creature.sql
ECHO Changeset 114 imported sucesfully!
ECHO.
PAUSE   
GOTO changeset

:changeset115
CLS
ECHO.
ECHO import: Changeset 115
%mysqlpath%\mysql --host=%host% --user=%user% --password=%pass% --port=%port% %world_db% < %changsql%\115_world_creature_questrelation.sql
ECHO Changeset 115 imported sucesfully!
ECHO.
PAUSE   
GOTO changeset

:changeset116
CLS
ECHO.
ECHO import: Changeset 116
%mysqlpath%\mysql --host=%host% --user=%user% --password=%pass% --port=%port% %world_db% < %changsql%\116_world_creature_involvedrelation.sql
ECHO Changeset 116 imported sucesfully!
ECHO.
PAUSE   
GOTO changeset

:changeset117
CLS
ECHO.
ECHO import: Changeset 117
%mysqlpath%\mysql --host=%host% --user=%user% --password=%pass% --port=%port% %world_db% < %changsql%\117_world_creature_template.sql
ECHO Changeset 117 imported sucesfully!
ECHO.
PAUSE   
GOTO changeset

:changeset118
CLS
ECHO.
ECHO import: Changeset 118
%mysqlpath%\mysql --host=%host% --user=%user% --password=%pass% --port=%port% %world_db% < %changsql%\118_world_creature_template.sql
ECHO Changeset 118 imported sucesfully!
ECHO.
PAUSE   
GOTO changeset

:changeset119
CLS
ECHO.
ECHO import: Changeset 119
%mysqlpath%\mysql --host=%host% --user=%user% --password=%pass% --port=%port% %world_db% < %changsql%\119_world_gameobject_template.sql
ECHO Changeset 119 imported sucesfully!
ECHO.
PAUSE   
GOTO changeset

:changeset120
CLS
ECHO.
ECHO import: Changeset 120
%mysqlpath%\mysql --host=%host% --user=%user% --password=%pass% --port=%port% %world_db% < %changsql%\120_world_gameobject_loot_template.sql
ECHO Changeset 120 imported sucesfully!
ECHO.
PAUSE   
GOTO changeset

:changesetall
CLS
ECHO.
ECHO import: Changesets
for %%C in (%changsql%\*.sql) do (
	ECHO import: %%~nxC
	%mysqlpath%\mysql --host=%host% --user=%user% --password=%pass% --port=%port% %world_db% < "%%~fC"
)
ECHO Changesets imported sucesfully!
ECHO.
PAUSE   
GOTO begin

:error
ECHO	Please enter a correct character.
ECHO.
PAUSE
GOTO begin

:error2
ECHO	Changeset with this number not found.
ECHO.
PAUSE
GOTO begin

:exit