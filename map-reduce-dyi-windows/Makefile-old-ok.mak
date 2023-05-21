# Makefile
# installation:
# copy this Makefile, taks.py and the input files TASK001 TASK002 TASK003 onto the machine HEADH
# make install
# make -j 3 all  # or whatever degree of parallelism is needed.
# make clean


############  ENVIRONMENT SPECIFIC VALUES	- BEGIN

# working workstation and head node:
HEADH=NODE054
# remote workers: we assume one job per file per worker
HOST001=NODE208
HOST002=NODE051
HOST003=NODE058
# map tasks and files to process:
TASK001=BIGFILE_EOD2022_03_25.csv
TASK002=BIGFILE_EOD2022_03_25.csv
TASK003=BIGFILE_EOD2022_03_25.csv
TASK004=BIGFILE_EOD2022_03_24.csv
TASK005=BIGFILE_EOD2022_03_24.csv
# output file of the reduce step:
FINALFILE=merged.out.csv
#
MASTER_WORKDIR=MASTER\WORKDIR
WORKER_WORKDIR=WORKER\WORKDIR
MASTER_NET_ABS_TEMPBAT_LOC=\\$(HEADH)\$(MASTER_WORKDIR)
PYCALL_AT_WORKER=c:\Python37-32\python.exe \\$(HEADH)\$(MASTER_WORKDIR)\task.py
WAIT5SEC=C:\Windows\System32\timeout.exe /T 5
WAIT5SEC=C:\Windows\System32\ping.exe 127.0.0.1 -n 5
PSEXEC=PsExec.exe

############  ENVIRONMENT SPECIFIC VALUES	- END


help:
    @echo ''
    @echo '1.   make install or make i'
    @echo '2.   make pre_assign_agents_to_files or make a'
    @echo '3.   make clean or make c'
    @echo '4.   make -j 3 all'
    @echo '......... or whatever degree of parallelism as per needs'
    @echo '5.   make clean or make c'
    @echo '2r.  make clean_agents_to_files_assignments or make ac'
    @echo '1r.  make uninstall or make ic'
    @echo ''
    @echo 'run: make util_test_rexec'
    @echo '... to run a remote execution test'
    @echo 'run: make util_rem_dir'
    @echo '... to see a list of the remote files'

#shortcuts

i:install
a:pre_assign_agents_to_files
c:clean
ac:clean_agents_to_files_assignments
ic:uninstall


all : map_reduce

map_reduce: $(FINALFILE)
    echo map_reduce is up-to-date!

util_test_rexec:
    @cmd /c '$(PSEXEC)  \\$(HOST001) -accepteula -s cmd /c cd'
    @cmd /c '$(PSEXEC)  \\$(HOST002) -accepteula -s cmd /c cd'
    @cmd /c '$(PSEXEC)  \\$(HOST003) -accepteula -s cmd /c cd'


pre_assign_agents_to_files:
    #rerunnable
    #
    $(MASTER_LOGGER_BAT) exec pre_assign_agents_to_files
    #
    echo> $(HOST001).idle.agent
    echo> $(HOST002).idle.agent
    echo> $(HOST003).idle.agent
	
	echo> TASK001.s0.inputFileReadyOnMaster.mkcontrol
	echo> TASK002.s0.inputFileReadyOnMaster.mkcontrol
	echo> TASK003.s0.inputFileReadyOnMaster.mkcontrol
	echo> TASK004.s0.inputFileReadyOnMaster.mkcontrol
	echo> TASK005.s0.inputFileReadyOnMaster.mkcontrol
	
    #
    echo $(HOST001)> TASK001.agent
    echo $(HOST002)> TASK002.agent
    echo $(HOST003)> TASK003.agent
    echo $(HOST001)> TASK004.agent
    echo $(HOST002)> TASK005.agent


clean_agents_to_files_assignments:
    cmd /c 'del /Q *.agent'
    @echo clean_agents_to_files_assignments is done.


#echo test - the agent of TASK001 will be: $(shell cmd /c type TASK001.agent)  -OK-
#echo test - the agent of TASK001 will be: $(file < TASK001.agent) -NOT OK-
#... file function is supported since v 4.2 and we are using GNU Make version 3.78.1 - Built for Windows32



#push steps:


%.s1.pushedToWorker.mkcontrol : %.s0.inputFileReadyOnMaster.mkcontrol
	echo doing stem $*
    cmd /c '$(MASTER_LOGGER_BAT) begin $@'
    cmd /c 'copy $? \\$(shell cmd /c type $*.agent)\$(WORKER_WORKDIR)\ && echo> $@'

ko_TASK001.s1.pushedToWorker.mkcontrol : $(TASK001)
    cmd /c '$(MASTER_LOGGER_BAT) begin $@'
    cmd /c 'copy $? \\$(shell cmd /c type TASK001.agent)\$(WORKER_WORKDIR)\ && echo> $@'
ko_TASK002.s1.pushedToWorker.mkcontrol : $(TASK002)
    cmd /c '$(MASTER_LOGGER_BAT) begin $@'
    cmd /c 'copy $? \\$(shell cmd /c type TASK002.agent)\$(WORKER_WORKDIR)\ && echo> $@'
ko_TASK003.s1.pushedToWorker.mkcontrol : $(TASK003)
    cmd /c '$(MASTER_LOGGER_BAT) begin $@'
    cmd /c 'copy $? \\$(shell cmd /c type TASK003.agent)\$(WORKER_WORKDIR)\ && echo> $@'
ko_TASK004.s1.pushedToWorker.mkcontrol : $(TASK004)
    cmd /c '$(MASTER_LOGGER_BAT) begin $@'
    cmd /c 'copy $? \\$(shell cmd /c type TASK004.agent)\$(WORKER_WORKDIR)\ && echo> $@'
ko_TASK005.s1.pushedToWorker.mkcontrol : $(TASK005)
    cmd /c '$(MASTER_LOGGER_BAT) begin $@'
    cmd /c 'copy $? \\$(shell cmd /c type TASK005.agent)\$(WORKER_WORKDIR)\ && echo> $@'
#... all rerunnable




# semantic of files:
# TASK001.lock = the TASK001 step was able to acquire a lock and move its agent status from idle to busy in MUTEX zone


%.s2.enqueuedToWorker.mkcontrol : %.s1.pushedToWorker.mkcontrol
    echo doing stem $*
    cmd /c '$(MASTER_LOGGER_BAT) begin $@ $(shell cmd /c type $*.agent)'
    @cmd /c 'for /L %s in (0,5,36000) do \
	if not exist $*.s2.enqueuedToWorker.mkcontrol \
	($(MASTER_LOCK_BAT) acquire $*.s2.enqueuedToWorker.mkcontrol $(shell cmd /c type $*.agent) && $(WAIT5SEC)) \
	else (exit /b)'


# enqueue map jobs:
ko_FILE001.s2.enqueuedToWorker.mkcontrol : TASK001.s1.pushedToWorker.mkcontrol
    cmd /c '$(MASTER_LOGGER_BAT) begin $@ $(shell cmd /c type TASK001.agent)'
    @cmd /c 'for /L %s in (0,5,36000) do if not exist TASK001.s2.enqueuedToWorker.mkcontrol ($(MASTER_LOCK_BAT) acquire TASK001.s2.enqueuedToWorker.mkcontrol $(shell cmd /c type TASK001.agent) && $(WAIT5SEC)) else (exit /b)'
ko_FILE002.s2.enqueuedToWorker.mkcontrol : TASK002.s1.pushedToWorker.mkcontrol
    cmd /c '$(MASTER_LOGGER_BAT) begin $@ $(shell cmd /c type TASK002.agent)'
    @cmd /c 'for /L %s in (0,5,36000) do if not exist TASK002.s2.enqueuedToWorker.mkcontrol ($(MASTER_LOCK_BAT) acquire TASK002.s2.enqueuedToWorker.mkcontrol $(shell cmd /c type TASK002.agent) && $(WAIT5SEC)) else (exit /b)'
ko_FILE003.s2.enqueuedToWorker.mkcontrol : TASK003.s1.pushedToWorker.mkcontrol
    cmd /c '$(MASTER_LOGGER_BAT) begin $@ $(shell cmd /c type TASK003.agent)'
    @cmd /c 'for /L %s in (0,5,36000) do if not exist TASK003.s2.enqueuedToWorker.mkcontrol ($(MASTER_LOCK_BAT) acquire TASK003.s2.enqueuedToWorker.mkcontrol $(shell cmd /c type TASK003.agent) && $(WAIT5SEC)) else (exit /b)'
ko_FILE004.s2.enqueuedToWorker.mkcontrol : TASK004.s1.pushedToWorker.mkcontrol
    cmd /c '$(MASTER_LOGGER_BAT) begin $@ $(shell cmd /c type TASK004.agent)'
    @cmd /c 'for /L %s in (0,5,36000) do if not exist TASK004.s2.enqueuedToWorker.mkcontrol ($(MASTER_LOCK_BAT) acquire TASK004.s2.enqueuedToWorker.mkcontrol $(shell cmd /c type TASK004.agent) && $(WAIT5SEC)) else (exit /b)'
ko_FILE005.s2.enqueuedToWorker.mkcontrol : TASK005.s1.pushedToWorker.mkcontrol
    cmd /c '$(MASTER_LOGGER_BAT) begin $@ $(shell cmd /c type TASK005.agent)'
    @cmd /c 'for /L %s in (0,5,36000) do if not exist TASK005.s2.enqueuedToWorker.mkcontrol ($(MASTER_LOCK_BAT) acquire TASK005.s2.enqueuedToWorker.mkcontrol $(shell cmd /c type TASK005.agent) && $(WAIT5SEC)) else (exit /b)'


# submit map jobs:
%.s3.submittedToWorker.mkcontrol : %.s2.enqueuedToWorker.mkcontrol
    echo doing stem $*
	cmd /c '$(MASTER_LOGGER_BAT) begin $@'
    cmd /c '$(MASTER_REXEC_BAT) $(shell cmd /c type $*.agent) $($*) $* && echo> $@'

ko_FILE001.s3.submittedToWorker.mkcontrol : TASK001.s2.enqueuedToWorker.mkcontrol
    cmd /c '$(MASTER_LOGGER_BAT) begin $@'
    cmd /c '$(MASTER_REXEC_BAT) $(shell cmd /c type TASK001.agent) $(TASK001) TASK001 && echo> $@'
ko_FILE002.s3.submittedToWorker.mkcontrol : TASK002.s2.enqueuedToWorker.mkcontrol
    cmd /c '$(MASTER_LOGGER_BAT) begin $@'
    cmd /c '$(MASTER_REXEC_BAT) $(shell cmd /c type TASK002.agent) $(TASK002) TASK002 && echo> $@'
ko_FILE003.s3.submittedToWorker.mkcontrol : TASK003.s2.enqueuedToWorker.mkcontrol
    cmd /c '$(MASTER_LOGGER_BAT) begin $@'
    cmd /c '$(MASTER_REXEC_BAT) $(shell cmd /c type TASK003.agent) $(TASK003) TASK003 && echo> $@'
ko_FILE004.s3.submittedToWorker.mkcontrol : TASK004.s2.enqueuedToWorker.mkcontrol
    cmd /c '$(MASTER_LOGGER_BAT) begin $@'
    cmd /c '$(MASTER_REXEC_BAT) $(shell cmd /c type TASK004.agent) $(TASK004) TASK004 && echo> $@'
ko_FILE005.s3.submittedToWorker.mkcontrol : TASK005.s2.enqueuedToWorker.mkcontrol
    cmd /c '$(MASTER_LOGGER_BAT) begin $@'
    cmd /c '$(MASTER_REXEC_BAT) $(shell cmd /c type TASK005.agent) $(TASK005) TASK005 && echo> $@'

# poll file steps:
%.s4.workerCompletionChecked.mkcontrol : %.s3.submittedToWorker.mkcontrol
	echo doing stem $*
    @cmd /c 'for /L %s in (0,5,36000) do if not exist $*.workercompleted.mkcontrol ($(WAIT5SEC)) else \
    (echo> $@ && ren $(shell cmd /c type $*.agent).busy.agent $(shell cmd /c type $*.agent).idle.agent && exit /b)'

ko_FILE001.s4.workerCompletionChecked.mkcontrol : TASK001.s3.submittedToWorker.mkcontrol
    @cmd /c 'for /L %s in (0,5,36000) do if not exist TASK001.workercompleted.mkcontrol ($(WAIT5SEC)) else \
    (echo> $@ && ren $(shell cmd /c type TASK001.agent).busy.agent $(shell cmd /c type TASK001.agent).idle.agent && exit /b)'
ko_FILE002.s4.workerCompletionChecked.mkcontrol : TASK002.s3.submittedToWorker.mkcontrol
    @cmd /c 'for /L %s in (0,5,36000) do if not exist TASK002.workercompleted.mkcontrol ($(WAIT5SEC)) else \
    (echo> $@ && ren $(shell cmd /c type TASK002.agent).busy.agent $(shell cmd /c type TASK002.agent).idle.agent && exit /b)'
ko_FILE003.s4.workerCompletionChecked.mkcontrol : TASK003.s3.submittedToWorker.mkcontrol
    @cmd /c 'for /L %s in (0,5,36000) do if not exist TASK003.workercompleted.mkcontrol ($(WAIT5SEC)) else \
    (echo> $@ && ren $(shell cmd /c type TASK003.agent).busy.agent $(shell cmd /c type TASK003.agent).idle.agent && exit /b)'
ko_FILE004.s4.workerCompletionChecked.mkcontrol : TASK004.s3.submittedToWorker.mkcontrol
    @cmd /c 'for /L %s in (0,5,36000) do if not exist TASK004.workercompleted.mkcontrol ($(WAIT5SEC)) else \
    (echo> $@ && ren $(shell cmd /c type TASK004.agent).busy.agent $(shell cmd /c type TASK004.agent).idle.agent && exit /b)'
ko_FILE005.s4.workerCompletionChecked.mkcontrol : TASK005.s3.submittedToWorker.mkcontrol
    @cmd /c 'for /L %s in (0,5,36000) do if not exist TASK005.workercompleted.mkcontrol ($(WAIT5SEC)) else \
    (echo> $@ && ren $(shell cmd /c type TASK005.agent).busy.agent $(shell cmd /c type TASK005.agent).idle.agent && exit /b)'


#pull steps:
%.s5.outputFileReadyOnMaster.mkcontrol : %.s4.workerCompletionChecked.mkcontrol
 	echo doing stem $*
#	cmd /c 'ren $(shell cmd /c type TASK001.agent).busy.agent $(shell cmd /c type TASK001.agent).idle.agent'
    cmd /c 'copy \\$(shell cmd /c type $*.agent)\$(WORKER_WORKDIR)\$($*).out.csv  .'
	cmd /c 'echo>$@'
    cmd /c '$(MASTER_LOGGER_BAT) end $<'


ko_$(TASK001).out.csv : TASK001.s4.workerCompletionChecked.mkcontrol
    #cmd /c 'ren $(shell cmd /c type TASK001.agent).busy.agent $(shell cmd /c type TASK001.agent).idle.agent'
    cmd /c 'copy \\$(shell cmd /c type TASK001.agent)\$(WORKER_WORKDIR)\$(TASK001).out.csv $@'
    cmd /c '$(MASTER_LOGGER_BAT) end $<'
ko_$(TASK002).out.csv : TASK002.s4.workerCompletionChecked.mkcontrol
    #cmd /c 'ren $(shell cmd /c type TASK002.agent).busy.agent $(shell cmd /c type TASK002.agent).idle.agent'
    cmd /c 'copy \\$(shell cmd /c type TASK002.agent)\$(WORKER_WORKDIR)\$(TASK002).out.csv $@'
    cmd /c '$(MASTER_LOGGER_BAT) end $<'
ko_$(TASK003).out.csv : TASK003.s4.workerCompletionChecked.mkcontrol
    #cmd /c 'ren $(shell cmd /c type TASK003.agent).busy.agent $(shell cmd /c type TASK003.agent).idle.agent'
    cmd /c 'copy \\$(shell cmd /c type TASK003.agent)\$(WORKER_WORKDIR)\$(TASK003).out.csv $@'
    cmd /c '$(MASTER_LOGGER_BAT) end $<'
ko_$(TASK004).out.csv : TASK004.s4.workerCompletionChecked.mkcontrol
    #cmd /c 'ren $(shell cmd /c type TASK004.agent).busy.agent $(shell cmd /c type TASK004.agent).idle.agent'
    cmd /c 'copy \\$(shell cmd /c type TASK004.agent)\$(WORKER_WORKDIR)\$(TASK004).out.csv $@'
    cmd /c '$(MASTER_LOGGER_BAT) end $<'
ko_$(TASK005).out.csv : TASK005.s4.workerCompletionChecked.mkcontrol
    #cmd /c 'ren $(shell cmd /c type TASK005.agent).busy.agent $(shell cmd /c type TASK005.agent).idle.agent'
    cmd /c 'copy \\$(shell cmd /c type TASK005.agent)\$(WORKER_WORKDIR)\$(TASK005).out.csv $@'
    cmd /c '$(MASTER_LOGGER_BAT) end $<'

#reduce:

$(FINALFILE) : $(TASK001).out.csv $(TASK002).out.csv $(TASK003).out.csv $(TASK004).out.csv $(TASK005).out.csv
    $(MASTER_LOGGER_BAT) begin reduce
    cmd /c 'type $? > $(FINALFILE)'
    $(MASTER_LOGGER_BAT) end reduce
    cmd /c 'dir *.out.csv'
    @echo DONE!

###

MASTER_REXEC_BAT=MASTER-TEMP.REMOTEEXEC.BAT
WORKER_LEXEC_BAT=WORKER-TEMP.LOCALEXEC.BAT
MASTER_LOGGER_BAT=MASTER-LOGGER.BAT
MASTER_LOCK_BAT=MASTER-LOCK.BAT
MASTER_LOG=make-log.log



###

install: gen_loc_exec gen_rem_exec gen_logger delete_log gen_lock

gen_lock:
    echo 'ren %3.idle.agent %3.busy.agent' > $(MASTER_LOCK_BAT)
    echo 'set R=%errorlevel%' >> $(MASTER_LOCK_BAT)
    echo 'if [%R%]==[0] goto MUTEX' >> $(MASTER_LOCK_BAT)
    echo 'exit /b 0' >> $(MASTER_LOCK_BAT)
    echo ':MUTEX' >> $(MASTER_LOCK_BAT)
    echo 'echo>%2' >> $(MASTER_LOCK_BAT)
    echo 'exit /b 0' >> $(MASTER_LOCK_BAT)


uninstall:
    cmd /c 'del /Q $(MASTER_LOG)'
    cmd /c 'del /Q $(MASTER_REXEC_BAT)'
    cmd /c 'del /Q $(MASTER_LOGGER_BAT)'
    cmd /c 'del /Q $(MASTER_LOCK_BAT)'
    cmd /c 'del /Q $(WORKER_LEXEC_BAT)'


###

gen_logger:
    echo 'echo %TIME% %1 %2 %3 >> $(MASTER_LOG)' > $(MASTER_LOGGER_BAT)

delete_log:
    cmd /c 'del /Q $(MASTER_LOG)'



gen_loc_exec:
    # install - WORKER_LEXEC_BAT
    echo 'rem I am expected to be a worker' > $(WORKER_LEXEC_BAT)
    echo 'SET MYHOSTNAME=%1' >> $(WORKER_LEXEC_BAT)
    echo 'SET FILENM=%2' >> $(WORKER_LEXEC_BAT)
    echo 'SET FILECTR=%3' >> $(WORKER_LEXEC_BAT)
    echo '$(PYCALL_AT_WORKER) \\%MYHOSTNAME%\$(WORKER_WORKDIR)\%FILENM%  \\%MYHOSTNAME%\$(WORKER_WORKDIR)\%FILENM%.out.csv' >> $(WORKER_LEXEC_BAT)
    echo 'echo> \\$(HEADH)\$(MASTER_WORKDIR)\%FILECTR%.workercompleted.mkcontrol' >> $(WORKER_LEXEC_BAT)

gen_rem_exec:
    # install - MASTER_REXEC_BAT
    echo 'rem I am expected to be the head node' > $(MASTER_REXEC_BAT)
    echo '$(PSEXEC)  \\%1 -accepteula -s -d $(MASTER_NET_ABS_TEMPBAT_LOC)\$(WORKER_LEXEC_BAT) %1 %2 %3' >> $(MASTER_REXEC_BAT)
    # the below cd is required to override the (false) error code returned by PsEcex when used with the -d switch
    echo cd >> $(MASTER_REXEC_BAT)

###

clean: clean_mkcontrol rem_in_clean rem_out_clean loc_out_clean

clean_mkcontrol:
    #rerunnable
    @echo === cleaning the .mkcontrol files
    cmd /c 'del /Q *.mkcontrol'
    cmd /c 'del /Q *.lock'
    @echo === done


rem_in_clean:
    #rerunnable
    @echo === cleaning remote input files according to the .agent specs
    cmd /c 'del /Q \\$(shell cmd /c type TASK001.agent)\$(WORKER_WORKDIR)\$(TASK001)'
    cmd /c 'del /Q \\$(shell cmd /c type TASK002.agent)\$(WORKER_WORKDIR)\$(TASK002)'
    cmd /c 'del /Q \\$(shell cmd /c type TASK003.agent)\$(WORKER_WORKDIR)\$(TASK003)'
    cmd /c 'del /Q \\$(shell cmd /c type TASK004.agent)\$(WORKER_WORKDIR)\$(TASK004)'
    cmd /c 'del /Q \\$(shell cmd /c type TASK005.agent)\$(WORKER_WORKDIR)\$(TASK005)'
    @echo === done

rem_out_clean:
    #rerunnable
    @echo === cleaning remote output files according to the .agent specs
    cmd /c 'del /Q \\$(shell cmd /c type TASK001.agent)\$(WORKER_WORKDIR)\$(TASK001).out.csv'
    cmd /c 'del /Q \\$(shell cmd /c type TASK002.agent)\$(WORKER_WORKDIR)\$(TASK002).out.csv'
    cmd /c 'del /Q \\$(shell cmd /c type TASK003.agent)\$(WORKER_WORKDIR)\$(TASK003).out.csv'
    cmd /c 'del /Q \\$(shell cmd /c type TASK004.agent)\$(WORKER_WORKDIR)\$(TASK004).out.csv'
    cmd /c 'del /Q \\$(shell cmd /c type TASK005.agent)\$(WORKER_WORKDIR)\$(TASK005).out.csv'
    @echo === supposed to be done

loc_out_clean:
    #rerunnable
    @echo === cleaning local copies of the output files and the reduce output file
    cmd /c 'del /Q $(TASK001).out.csv'
    cmd /c 'del /Q $(TASK002).out.csv'
    cmd /c 'del /Q $(TASK003).out.csv'
    cmd /c 'del /Q $(TASK004).out.csv'
    cmd /c 'del /Q $(TASK005).out.csv'
    cmd /c 'del /Q $(FINALFILE)'
    @echo === done

###
### foreach worker

util_rem_dir:
    #rerunnable
    cmd /c 'dir \\$(HOST001)\$(WORKER_WORKDIR) || cd'
    cmd /c 'dir \\$(HOST002)\$(WORKER_WORKDIR) || cd'
    cmd /c 'dir \\$(HOST003)\$(WORKER_WORKDIR) || cd'

###

# https://www.gnu.org/software/make/manual/make.html#Wildcard-Function
# https://www.gnu.org/software/make/manual/make.html#Automatic-Variables
# https://www.gnu.org/software/make/manual/html_node/Functions.html
