# Makefile
# installation:
# copy this Makefile, taks.py and the input files FILE001 FILE002 FILE003 onto the machine HEADH
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
# files to process:
FILE001=BIGFILE_EOD2022_03_25.csv
FILE002=BIGFILE_EOD2022_03_25.csv
FILE003=BIGFILE_EOD2022_03_25.csv
FILE004=BIGFILE_EOD2022_03_24.csv
FILE005=BIGFILE_EOD2022_03_24.csv
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
    #
    echo $(HOST001)> FILE001.agent
    echo $(HOST002)> FILE002.agent
    echo $(HOST003)> FILE003.agent
    echo $(HOST001)> FILE004.agent
    echo $(HOST002)> FILE005.agent


clean_agents_to_files_assignments:
    cmd /c 'del /Q *.agent'
    @echo clean_agents_to_files_assignments is done.


#echo test - the agent of FILE001 will be: $(shell cmd /c type FILE001.agent)  -OK-
#echo test - the agent of FILE001 will be: $(file < FILE001.agent) -NOT OK-
#... file function is supported since v 4.2 and we are using GNU Make version 3.78.1 - Built for Windows32



#push steps:

FILE001.s1.pushedToWorker.mkcontrol : $(FILE001)
    cmd /c '$(MASTER_LOGGER_BAT) begin $@'
    cmd /c 'copy $? \\$(shell cmd /c type FILE001.agent)\$(WORKER_WORKDIR)\ && echo> $@'
FILE002.s1.pushedToWorker.mkcontrol : $(FILE002)
    cmd /c '$(MASTER_LOGGER_BAT) begin $@'
    cmd /c 'copy $? \\$(shell cmd /c type FILE002.agent)\$(WORKER_WORKDIR)\ && echo> $@'
FILE003.s1.pushedToWorker.mkcontrol : $(FILE003)
    cmd /c '$(MASTER_LOGGER_BAT) begin $@'
    cmd /c 'copy $? \\$(shell cmd /c type FILE003.agent)\$(WORKER_WORKDIR)\ && echo> $@'
FILE004.s1.pushedToWorker.mkcontrol : $(FILE004)
    cmd /c '$(MASTER_LOGGER_BAT) begin $@'
    cmd /c 'copy $? \\$(shell cmd /c type FILE004.agent)\$(WORKER_WORKDIR)\ && echo> $@'
FILE005.s1.pushedToWorker.mkcontrol : $(FILE005)
    cmd /c '$(MASTER_LOGGER_BAT) begin $@'
    cmd /c 'copy $? \\$(shell cmd /c type FILE005.agent)\$(WORKER_WORKDIR)\ && echo> $@'
#... all rerunnable




# semantic of files:
# FILE001.lock = the FILE001 step was able to acquire a lock and move its agent status from idle to busy in MUTEX zone

%.s2.enqueuedToWorker.mkcontrol : %.s1.pushedToWorker.mkcontrol
    echo doing stem $*
    cmd /c '$(MASTER_LOGGER_BAT) begin $@ $(shell cmd /c type $*.agent)'
    @cmd /c 'for /L %s in (0,5,36000) do \
	if not exist $*.s2.enqueuedToWorker.mkcontrol \
	($(MASTER_LOCK_BAT) acquire $*.s2.enqueuedToWorker.mkcontrol $(shell cmd /c type $*.agent) && $(WAIT5SEC)) \
	else (exit /b)'


# enqueue map jobs:
ko_FILE001.s2.enqueuedToWorker.mkcontrol : FILE001.s1.pushedToWorker.mkcontrol
    cmd /c '$(MASTER_LOGGER_BAT) begin $@ $(shell cmd /c type FILE001.agent)'
    @cmd /c 'for /L %s in (0,5,36000) do if not exist FILE001.s2.enqueuedToWorker.mkcontrol ($(MASTER_LOCK_BAT) acquire FILE001.s2.enqueuedToWorker.mkcontrol $(shell cmd /c type FILE001.agent) && $(WAIT5SEC)) else (exit /b)'
ko_FILE002.s2.enqueuedToWorker.mkcontrol : FILE002.s1.pushedToWorker.mkcontrol
    cmd /c '$(MASTER_LOGGER_BAT) begin $@ $(shell cmd /c type FILE002.agent)'
    @cmd /c 'for /L %s in (0,5,36000) do if not exist FILE002.s2.enqueuedToWorker.mkcontrol ($(MASTER_LOCK_BAT) acquire FILE002.s2.enqueuedToWorker.mkcontrol $(shell cmd /c type FILE002.agent) && $(WAIT5SEC)) else (exit /b)'
ko_FILE003.s2.enqueuedToWorker.mkcontrol : FILE003.s1.pushedToWorker.mkcontrol
    cmd /c '$(MASTER_LOGGER_BAT) begin $@ $(shell cmd /c type FILE003.agent)'
    @cmd /c 'for /L %s in (0,5,36000) do if not exist FILE003.s2.enqueuedToWorker.mkcontrol ($(MASTER_LOCK_BAT) acquire FILE003.s2.enqueuedToWorker.mkcontrol $(shell cmd /c type FILE003.agent) && $(WAIT5SEC)) else (exit /b)'
ko_FILE004.s2.enqueuedToWorker.mkcontrol : FILE004.s1.pushedToWorker.mkcontrol
    cmd /c '$(MASTER_LOGGER_BAT) begin $@ $(shell cmd /c type FILE004.agent)'
    @cmd /c 'for /L %s in (0,5,36000) do if not exist FILE004.s2.enqueuedToWorker.mkcontrol ($(MASTER_LOCK_BAT) acquire FILE004.s2.enqueuedToWorker.mkcontrol $(shell cmd /c type FILE004.agent) && $(WAIT5SEC)) else (exit /b)'
ko_FILE005.s2.enqueuedToWorker.mkcontrol : FILE005.s1.pushedToWorker.mkcontrol
    cmd /c '$(MASTER_LOGGER_BAT) begin $@ $(shell cmd /c type FILE005.agent)'
    @cmd /c 'for /L %s in (0,5,36000) do if not exist FILE005.s2.enqueuedToWorker.mkcontrol ($(MASTER_LOCK_BAT) acquire FILE005.s2.enqueuedToWorker.mkcontrol $(shell cmd /c type FILE005.agent) && $(WAIT5SEC)) else (exit /b)'


# submit map jobs:
%.s3.submittedToWorker.mkcontrol : %.s2.enqueuedToWorker.mkcontrol
    echo doing stem $*
	cmd /c '$(MASTER_LOGGER_BAT) begin $@'
    cmd /c '$(MASTER_REXEC_BAT) $(shell cmd /c type $*.agent) $($*) $* && echo> $@'

ko_FILE001.s3.submittedToWorker.mkcontrol : FILE001.s2.enqueuedToWorker.mkcontrol
    cmd /c '$(MASTER_LOGGER_BAT) begin $@'
    cmd /c '$(MASTER_REXEC_BAT) $(shell cmd /c type FILE001.agent) $(FILE001) FILE001 && echo> $@'
ko_FILE002.s3.submittedToWorker.mkcontrol : FILE002.s2.enqueuedToWorker.mkcontrol
    cmd /c '$(MASTER_LOGGER_BAT) begin $@'
    cmd /c '$(MASTER_REXEC_BAT) $(shell cmd /c type FILE002.agent) $(FILE002) FILE002 && echo> $@'
ko_FILE003.s3.submittedToWorker.mkcontrol : FILE003.s2.enqueuedToWorker.mkcontrol
    cmd /c '$(MASTER_LOGGER_BAT) begin $@'
    cmd /c '$(MASTER_REXEC_BAT) $(shell cmd /c type FILE003.agent) $(FILE003) FILE003 && echo> $@'
ko_FILE004.s3.submittedToWorker.mkcontrol : FILE004.s2.enqueuedToWorker.mkcontrol
    cmd /c '$(MASTER_LOGGER_BAT) begin $@'
    cmd /c '$(MASTER_REXEC_BAT) $(shell cmd /c type FILE004.agent) $(FILE004) FILE004 && echo> $@'
ko_FILE005.s3.submittedToWorker.mkcontrol : FILE005.s2.enqueuedToWorker.mkcontrol
    cmd /c '$(MASTER_LOGGER_BAT) begin $@'
    cmd /c '$(MASTER_REXEC_BAT) $(shell cmd /c type FILE005.agent) $(FILE005) FILE005 && echo> $@'

# poll file steps:
%.s4.workerCompletionChecked.mkcontrol : %.s3.submittedToWorker.mkcontrol
	echo doing stem $*
    @cmd /c 'for /L %s in (0,5,36000) do if not exist $*.workercompleted.mkcontrol ($(WAIT5SEC)) else \
    (echo> $@ && ren $(shell cmd /c type $*.agent).busy.agent $(shell cmd /c type $*.agent).idle.agent && exit /b)'

ko_FILE001.s4.workerCompletionChecked.mkcontrol : FILE001.s3.submittedToWorker.mkcontrol
    @cmd /c 'for /L %s in (0,5,36000) do if not exist FILE001.workercompleted.mkcontrol ($(WAIT5SEC)) else \
    (echo> $@ && ren $(shell cmd /c type FILE001.agent).busy.agent $(shell cmd /c type FILE001.agent).idle.agent && exit /b)'
ko_FILE002.s4.workerCompletionChecked.mkcontrol : FILE002.s3.submittedToWorker.mkcontrol
    @cmd /c 'for /L %s in (0,5,36000) do if not exist FILE002.workercompleted.mkcontrol ($(WAIT5SEC)) else \
    (echo> $@ && ren $(shell cmd /c type FILE002.agent).busy.agent $(shell cmd /c type FILE002.agent).idle.agent && exit /b)'
ko_FILE003.s4.workerCompletionChecked.mkcontrol : FILE003.s3.submittedToWorker.mkcontrol
    @cmd /c 'for /L %s in (0,5,36000) do if not exist FILE003.workercompleted.mkcontrol ($(WAIT5SEC)) else \
    (echo> $@ && ren $(shell cmd /c type FILE003.agent).busy.agent $(shell cmd /c type FILE003.agent).idle.agent && exit /b)'
ko_FILE004.s4.workerCompletionChecked.mkcontrol : FILE004.s3.submittedToWorker.mkcontrol
    @cmd /c 'for /L %s in (0,5,36000) do if not exist FILE004.workercompleted.mkcontrol ($(WAIT5SEC)) else \
    (echo> $@ && ren $(shell cmd /c type FILE004.agent).busy.agent $(shell cmd /c type FILE004.agent).idle.agent && exit /b)'
ko_FILE005.s4.workerCompletionChecked.mkcontrol : FILE005.s3.submittedToWorker.mkcontrol
    @cmd /c 'for /L %s in (0,5,36000) do if not exist FILE005.workercompleted.mkcontrol ($(WAIT5SEC)) else \
    (echo> $@ && ren $(shell cmd /c type FILE005.agent).busy.agent $(shell cmd /c type FILE005.agent).idle.agent && exit /b)'


#pull steps:
$(FILE001).out.csv : FILE001.s4.workerCompletionChecked.mkcontrol
    #cmd /c 'ren $(shell cmd /c type FILE001.agent).busy.agent $(shell cmd /c type FILE001.agent).idle.agent'
    cmd /c 'copy \\$(shell cmd /c type FILE001.agent)\$(WORKER_WORKDIR)\$(FILE001).out.csv $@'
    cmd /c '$(MASTER_LOGGER_BAT) end $<'
$(FILE002).out.csv : FILE002.s4.workerCompletionChecked.mkcontrol
    #cmd /c 'ren $(shell cmd /c type FILE002.agent).busy.agent $(shell cmd /c type FILE002.agent).idle.agent'
    cmd /c 'copy \\$(shell cmd /c type FILE002.agent)\$(WORKER_WORKDIR)\$(FILE002).out.csv $@'
    cmd /c '$(MASTER_LOGGER_BAT) end $<'
$(FILE003).out.csv : FILE003.s4.workerCompletionChecked.mkcontrol
    #cmd /c 'ren $(shell cmd /c type FILE003.agent).busy.agent $(shell cmd /c type FILE003.agent).idle.agent'
    cmd /c 'copy \\$(shell cmd /c type FILE003.agent)\$(WORKER_WORKDIR)\$(FILE003).out.csv $@'
    cmd /c '$(MASTER_LOGGER_BAT) end $<'
$(FILE004).out.csv : FILE004.s4.workerCompletionChecked.mkcontrol
    #cmd /c 'ren $(shell cmd /c type FILE004.agent).busy.agent $(shell cmd /c type FILE004.agent).idle.agent'
    cmd /c 'copy \\$(shell cmd /c type FILE004.agent)\$(WORKER_WORKDIR)\$(FILE004).out.csv $@'
    cmd /c '$(MASTER_LOGGER_BAT) end $<'
$(FILE005).out.csv : FILE005.s4.workerCompletionChecked.mkcontrol
    #cmd /c 'ren $(shell cmd /c type FILE005.agent).busy.agent $(shell cmd /c type FILE005.agent).idle.agent'
    cmd /c 'copy \\$(shell cmd /c type FILE005.agent)\$(WORKER_WORKDIR)\$(FILE005).out.csv $@'
    cmd /c '$(MASTER_LOGGER_BAT) end $<'

#reduce:

$(FINALFILE) : $(FILE001).out.csv $(FILE002).out.csv $(FILE003).out.csv $(FILE004).out.csv $(FILE005).out.csv
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
    cmd /c 'del /Q \\$(shell cmd /c type FILE001.agent)\$(WORKER_WORKDIR)\$(FILE001)'
    cmd /c 'del /Q \\$(shell cmd /c type FILE002.agent)\$(WORKER_WORKDIR)\$(FILE002)'
    cmd /c 'del /Q \\$(shell cmd /c type FILE003.agent)\$(WORKER_WORKDIR)\$(FILE003)'
    cmd /c 'del /Q \\$(shell cmd /c type FILE004.agent)\$(WORKER_WORKDIR)\$(FILE004)'
    cmd /c 'del /Q \\$(shell cmd /c type FILE005.agent)\$(WORKER_WORKDIR)\$(FILE005)'
    @echo === done

rem_out_clean:
    #rerunnable
    @echo === cleaning remote output files according to the .agent specs
    cmd /c 'del /Q \\$(shell cmd /c type FILE001.agent)\$(WORKER_WORKDIR)\$(FILE001).out.csv'
    cmd /c 'del /Q \\$(shell cmd /c type FILE002.agent)\$(WORKER_WORKDIR)\$(FILE002).out.csv'
    cmd /c 'del /Q \\$(shell cmd /c type FILE003.agent)\$(WORKER_WORKDIR)\$(FILE003).out.csv'
    cmd /c 'del /Q \\$(shell cmd /c type FILE004.agent)\$(WORKER_WORKDIR)\$(FILE004).out.csv'
    cmd /c 'del /Q \\$(shell cmd /c type FILE005.agent)\$(WORKER_WORKDIR)\$(FILE005).out.csv'
    @echo === supposed to be done

loc_out_clean:
    #rerunnable
    @echo === cleaning local copies of the output files and the reduce output file
    cmd /c 'del /Q $(FILE001).out.csv'
    cmd /c 'del /Q $(FILE002).out.csv'
    cmd /c 'del /Q $(FILE003).out.csv'
    cmd /c 'del /Q $(FILE004).out.csv'
    cmd /c 'del /Q $(FILE005).out.csv'
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
