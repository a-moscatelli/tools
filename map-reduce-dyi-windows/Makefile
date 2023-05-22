# Makefile
# see help:

# expected initial content of folder MASTER_WORKDIR on node HEADH:
# -
# bigfile*.csv
# make.exe
# Makefile
# PsExec.exe
# setenv.bat
# task.py
# -
# example of setenv.bat:
#set "MASTER_WORKDIR=folder\subfolder\subsubfolder"
#set "WORKER_WORKDIR=folder"


############  ENVIRONMENT SPECIFIC VALUES  - BEGIN

# HEADH = working workstation and head node

# remote workers labels: we assume one job per file per worker
WORKERS=HOST001 HOST002 HOST003

# map tasks labels and files to process:
TASKS=TASK001 TASK002 TASK003 TASK004 TASK005

# output file of the reduce step:
FINALFILE=merged.out.csv
#
MASTER_NET_ABS_TEMPBAT_LOC=\\$(HEADH)\$(MASTER_WORKDIR)
PYCALL_AT_WORKER=c:\Python37-32\python.exe \\$(HEADH)\$(MASTER_WORKDIR)\task.py
WAIT5SEC=C:\Windows\System32\timeout.exe /T 5
WAIT5SEC=C:\Windows\System32\ping.exe 127.0.0.1 -n 5 >NUL
PSEXEC=PsExec.exe

############  ENVIRONMENT SPECIFIC VALUES  - END


help:
    @echo ''
    @echo HEADH is: $(HEADH)
    @echo HOST001 is: $(HOST001)
    @echo TASK001 is: $(TASK001)
    @echo MASTER_WORKDIR is: $(MASTER_WORKDIR)
    @echo WORKER_WORKDIR is: $(WORKER_WORKDIR)
    @echo ''
    @echo '1.   make install or make i'
    @echo '2.   make pre_assign_agents_to_files or make a'
    @echo '3.   make clean or make c'
    @echo '4.   make -j 3 all'
    @echo '......... or whatever degree of parallelism as per needs'
    @echo '5.   make clean or make c'
    @echo '2r.  make clean_agents_to_files_assignments or make ca'
    @echo '1r.  make uninstall or make ci'
    @echo ''
    @echo 'run: make util_test_rexec'
    @echo '... to run a remote execution test'
    @echo 'run: make util_rem_dir'
    @echo '... to see a list of the remote files'

#shortcuts

i:install
a:pre_assign_agents_to_files
c:clean
ca:clean_agents_to_files_assignments
ci:uninstall


all : map_reduce


map_reduce: $(FINALFILE)
#  echo map_reduce is up-to-date!


foreach.WX.util_test_rexec = $(foreach WX, $(WORKERS), $(WX).foreach.WX.util_test_rexec)
util_test_rexec: $(foreach.WX.util_test_rexec)
$(foreach.WX.util_test_rexec):
    @echo doing HOST $(patsubst %.foreach.WX.util_test_rexec,%,$@) = $($(patsubst %.foreach.WX.util_test_rexec,%,$@))
    @echo doing:
    @echo '$(PSEXEC) \\$($(patsubst %.foreach.WX.util_test_rexec,%,$@)) -accepteula -s cmd /c cd'
    @cmd /c '$(PSEXEC)  \\$($(patsubst %.foreach.WX.util_test_rexec,%,$@)) -accepteula -s cmd /c cd'


pre_assign_agents_to_files: step0_task_init worker_state_init
    #rerunnable
    #
    -cmd /c 'del /Q $(MASTER_LOG)'
    $(MASTER_LOGGER_BAT) EXEC pre_assign_agents_to_files
    #
    echo HOST001> TASK001.agent
    echo HOST002> TASK002.agent
    echo HOST003> TASK003.agent
    echo HOST001> TASK004.agent
    echo HOST002> TASK005.agent






clean_agents_to_files_assignments:
    cmd /c 'del /Q *.agent'
    cmd /c 'del /Q *.mkcontrol'
    -cmd /c 'del /Q $(MASTER_LOG)'
    @echo clean_agents_to_files_assignments is done.


#echo test - the agent of TASK001 will be: $(shell cmd /c type TASK001.agent)  -OK-
#echo test - the agent of TASK001 will be: $(file < TASK001.agent) -NOT OK-
#... file function is supported since v 4.2 and we are using GNU Make version 3.78.1 - Built for Windows32

foreach.WX.worker_state_init = $(foreach WX, $(WORKERS), $(WX).idle.agent)
worker_state_init: $(foreach.WX.worker_state_init)
$(foreach.WX.worker_state_init) :
    cmd /c 'echo>$@'

#ref. https://www.gnu.org/software/make/manual/html_node/Static-Usage.html
step0 = $(foreach TX, $(TASKS), $(TX).step0.inputFileReadyOnMaster.mkcontrol)
step1 = $(foreach TX, $(TASKS), $(TX).step1.inputFilePushedToWorker.mkcontrol)
step2 = $(foreach TX, $(TASKS), $(TX).step2.workerAcquisitionLoopFinished.mkcontrol)
step3 = $(foreach TX, $(TASKS), $(TX).step3.submittedToWorker.mkcontrol)
step4 = $(foreach TX, $(TASKS), $(TX).step4.workerCompletionCheckLoopFinished.mkcontrol)
step5 = $(foreach TX, $(TASKS), $(TX).step5.outputFilePulledToMaster.mkcontrol)

step0_task_init: $(step0)
$(step0) :
    cmd /c 'echo>$@'

#push steps:
#... all rerunnable
$(step1) : %.step1.inputFilePushedToWorker.mkcontrol : %.step0.inputFileReadyOnMaster.mkcontrol
    echo doing stem $*
    cmd /c '$(MASTER_LOGGER_BAT) BEGIN $@'
    cmd /c 'copy $($*) \\$($(shell cmd /c type $*.agent))\$(WORKER_WORKDIR)\'
    echo> $@


next_acquire_onthego:
    @echo WIP
#  FOR %%F in (*.idle.agent) do (echo %%F>TASK_XXX.tentative.txt && exit /b)


# enqueue map jobs:
$(step2) : %.step2.workerAcquisitionLoopFinished.mkcontrol : %.step1.inputFilePushedToWorker.mkcontrol
    echo doing stem $*
    cmd /c '$(MASTER_LOGGER_BAT) BEGIN $@ $(shell cmd /c type $*.agent)'
    @cmd /c 'for /L %s in (0,5,36000) do \
    if not exist $*.step2.workerAcquisitionLoopFinished.mkcontrol \
    ($(MASTER_LOCK_BAT) acquire $*.step2.workerAcquisitionLoopFinished.mkcontrol $(shell cmd /c type $*.agent) && $(WAIT5SEC)) \
    else \
    (exit /b)'

# submit map jobs:
$(step3) : %.step3.submittedToWorker.mkcontrol : %.step2.workerAcquisitionLoopFinished.mkcontrol
    echo doing stem $*
    cmd /c '$(MASTER_LOGGER_BAT) BEGIN $@'
    cmd /c '$(MASTER_REXEC_BAT) $($(shell cmd /c type $*.agent)) $($*) $* && echo> $@'

# poll file steps:
$(step4) : %.step4.workerCompletionCheckLoopFinished.mkcontrol : %.step3.submittedToWorker.mkcontrol
    echo doing stem $*
    @cmd /c 'for /L %s in (0,5,36000) do \
    if not exist $*.step4.workerCompletionCheckLoopFinished.mkcontrol \
    ($(WAIT5SEC)) \
    else \
    (echo> $@ && $(MASTER_LOCK_BAT) release NA $(shell cmd /c type $*.agent) && exit /b)'

#pull steps:
$(step5) : %.step5.outputFilePulledToMaster.mkcontrol : %.step4.workerCompletionCheckLoopFinished.mkcontrol
    echo doing stem $*
#  cmd /c 'ren $(shell cmd /c type TASK001.agent).busy.agent $(shell cmd /c type TASK001.agent).idle.agent'
    cmd /c 'copy \\$($(shell cmd /c type $*.agent))\$(WORKER_WORKDIR)\$($*).out.csv  .'
    cmd /c 'echo>$@'
    cmd /c '$(MASTER_LOGGER_BAT) END $<'


#reduce:
#ref. https://www.gnu.org/software/make/manual/html_node/Static-Usage.html
#objects = foo.o bar.o
#all: $(objects)
#$(objects): %.o: %.c
#  $(CC) -c $(CFLAGS) $< -o $@

#TASKS=TASK001 TASK002 TASK003 TASK004 TASK005
#$(FINALFILE) : $(TASK001).out.csv $(TASK002).out.csv $(TASK003).out.csv $(TASK004).out.csv $(TASK005).out.csv

tasks_output_files = $(foreach TX, $(TASKS), $($(TX)).out.csv)

$(FINALFILE) : $(step5)
    $(MASTER_LOGGER_BAT) BEGIN reduce
    cmd /c 'type $(tasks_output_files) > $(FINALFILE)'
    $(MASTER_LOGGER_BAT) END reduce
    cmd /c 'dir *.out.csv'
    @echo DONE!

###

MASTER_REXEC_BAT=MASTER-TEMP.REMOTEEXEC.BAT
WORKER_LEXEC_BAT=WORKER-TEMP.LOCALEXEC.BAT
MASTER_LOGGER_BAT=MASTER-LOGGER.BAT
MASTER_LOCK_BAT=MASTER-LOCK.BAT
MASTER_LOG=make-log.log



###

install: gen_loc_exec gen_rem_exec gen_logger gen_lock env_check
# NB will likely be done in parallel

env_check:
    @echo MASTER_WORKDIR is: $(MASTER_WORKDIR)
    @echo WORKER_WORKDIR is: $(WORKER_WORKDIR)

gen_lock:
    echo '' > $(MASTER_LOCK_BAT)
    echo 'if [%1]==[release] goto RELEASE' >> $(MASTER_LOCK_BAT)
    echo 'ren %3.idle.agent %3.busy.agent' >> $(MASTER_LOCK_BAT)
    echo 'if [%errorlevel%]==[0] goto MUTEX' >> $(MASTER_LOCK_BAT)
    echo 'exit /b 0' >> $(MASTER_LOCK_BAT)
    echo ':MUTEX' >> $(MASTER_LOCK_BAT)
    echo 'echo>%2' >> $(MASTER_LOCK_BAT)
    echo 'exit /b 0' >> $(MASTER_LOCK_BAT)
    echo ':RELEASE' >> $(MASTER_LOCK_BAT)
    echo 'ren %3.busy.agent %3.idle.agent' >> $(MASTER_LOCK_BAT)
    echo 'exit /b 0' >> $(MASTER_LOCK_BAT)


uninstall:
    cmd /c 'del /Q $(MASTER_REXEC_BAT) $(MASTER_LOGGER_BAT) $(MASTER_LOCK_BAT) $(WORKER_LEXEC_BAT)'


###

gen_logger:
    echo 'echo %TIME% %1 %2 %3 >> $(MASTER_LOG)' > $(MASTER_LOGGER_BAT)



gen_loc_exec:
#  install - WORKER_LEXEC_BAT
    echo 'rem I am expected to be a worker' > $(WORKER_LEXEC_BAT)
    echo 'SET MYHOSTNAME=%1' >> $(WORKER_LEXEC_BAT)
    echo 'SET FILENM=%2' >> $(WORKER_LEXEC_BAT)
    echo 'SET FILECTR=%3' >> $(WORKER_LEXEC_BAT)
    echo '$(PYCALL_AT_WORKER) \\%MYHOSTNAME%\$(WORKER_WORKDIR)\%FILENM%  \\%MYHOSTNAME%\$(WORKER_WORKDIR)\%FILENM%.out.csv' >> $(WORKER_LEXEC_BAT)
    echo 'echo> \\$(HEADH)\$(MASTER_WORKDIR)\%FILECTR%.step4.workerCompletionCheckLoopFinished.mkcontrol' >> $(WORKER_LEXEC_BAT)

gen_rem_exec:
#  install - MASTER_REXEC_BAT
    echo 'rem I am expected to be the head node' > $(MASTER_REXEC_BAT)
    echo '$(PSEXEC)  \\%1 -accepteula -s -d $(MASTER_NET_ABS_TEMPBAT_LOC)\$(WORKER_LEXEC_BAT) %1 %2 %3' >> $(MASTER_REXEC_BAT)
    echo cd >> $(MASTER_REXEC_BAT)
#  the below cd is required to override the (false) error code returned by PsEcex when used with the -d switch
#TBC use -

###

clean: mkcontrolFilesCleanup remoteInOutFilesCleanup localOutputFilesCleanup localReduceOutputFilesCleanup

mkcontrolFilesCleanup:
#  rerunnable
    @echo === cleaning the .mkcontrol files
    cmd /c 'del /Q *.mkcontrol'
    @echo === done

localReduceOutputFilesCleanup:
    cmd /c 'del /Q $(FINALFILE)'


foreach.TX.remoteInOutFilesCleanup = $(foreach TX, $(TASKS), $(TX).foreach.TX.remoteInOutFilesCleanup)
remoteInOutFilesCleanup: $(foreach.TX.remoteInOutFilesCleanup)
$(foreach.TX.remoteInOutFilesCleanup):
    @echo doing WORKER $(patsubst %.foreach.TX.remoteInOutFilesCleanup,%,$@) = $($(patsubst %.foreach.TX.remoteInOutFilesCleanup,%,$@))
    -cmd /c 'del /Q \\$($(shell cmd /c type $(patsubst %.foreach.TX.remoteInOutFilesCleanup,%,$@).agent))\$(WORKER_WORKDIR)\$($(patsubst %.foreach.TX.remoteInOutFilesCleanup,%,$@))'
    -cmd /c 'del /Q \\$($(shell cmd /c type $(patsubst %.foreach.TX.remoteInOutFilesCleanup,%,$@).agent))\$(WORKER_WORKDIR)\$($(patsubst %.foreach.TX.remoteInOutFilesCleanup,%,$@)).out.csv'


foreach.TX.localOutputFilesCleanup = $(foreach TX, $(TASKS), $(TX).foreach.TX.localOutputFilesCleanup)
localOutputFilesCleanup: $(foreach.TX.localOutputFilesCleanup)
$(foreach.TX.localOutputFilesCleanup):
#      doing WORKER TASK001 = bigfile_real_name.csv
    @echo doing WORKER $(patsubst %.foreach.TX.localOutputFilesCleanup,%,$@) = $($(patsubst %.foreach.TX.localOutputFilesCleanup,%,$@))
    -cmd /c 'del /Q $($(patsubst %.foreach.TX.localOutputFilesCleanup,%,$@)).out.csv'



foreach.WX.util_rem_dir = $(foreach WX, $(WORKERS), $(WX).foreach.WX.util_rem_dir)
util_rem_dir: $(foreach.WX.util_rem_dir)
$(foreach.WX.util_rem_dir):
    @echo doing HOST $(patsubst %.foreach.WX.util_rem_dir,%,$@) = $($(patsubst %.foreach.WX.util_rem_dir,%,$@))
    -cmd /c 'dir /OD \\$($(patsubst %.foreach.WX.util_rem_dir,%,$@))\$(WORKER_WORKDIR)\'
    @echo 'that was  \\$($(patsubst %.foreach.WX.util_rem_dir,%,$@))\$(WORKER_WORKDIR)\'




###

# https://www.gnu.org/software/make/manual/make.html#Wildcard-Function
# https://www.gnu.org/software/make/manual/make.html#Automatic-Variables
# https://www.gnu.org/software/make/manual/html_node/Functions.html
# https://www.gnu.org/software/make/manual/html_node/Pattern-Rules.html    for stems
