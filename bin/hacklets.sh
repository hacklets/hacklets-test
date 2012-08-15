# these two are fixed in stone, unless you know what you're doing
HACKLETS_DIST_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
HACKLETS_EXEC_NAME="${0%/*}"

HACKLETS_BACKENDDIR_NAME=.hacklets
HACKLETS_MASTERDIR_NAME="${HACKLETS_BACKENDDIR_NAME}/master"
HACKLETS_MASTER_TPL_DIR="${HACKLETS_DIST_DIR}/hacklets.d/templates/master"

#TODO: here source one file (hook) to overwrite the lines above

alias hacklets-demo_repos='hacklets_demo_repos'
alias hacklets-new_profile='hacklets_new_profile'
#alias hacklets="$HACKLETS_CMD"

##
# activate the current directory as a container
##
function hacklets_activate_this() {
    HACKLETS_CONTAINER_DIR=`pwd`
    HACKLETS_BACKENDDIR="${HACKLETS_CONTAINER_DIR}/${HACKLETS_BACKENDDIR_NAME}"
    HACKLETS_MASTERDIR="${HACKLETS_CONTAINER_DIR}/${HACKLETS_MASTERDIR_NAME}"

    ## internal variables
    LOG_ENABLED="yes"
    DONOTLOG="no"
    source "$HACKLETS_DIST_DIR/scripts.d/bsfl"
    SYSLOG_ENABLED="yes"
    DONOTLOG="no"
    LOG_FILE="${HACKLETS_BACKENDDIR}/hacklets.log"
    SYSLOG_TAG="hacklets"
}

# TODO move this call above the function
hacklets_activate_this

##
# deactivate the current directory as a container
##
function hacklets_deactivate_this() {
    unset HACKLETS_CONTAINER_DIR HACKLETS_BACKENDDIR HACKLETS_MASTERDIR
    unset LOG_ENABLED DONOTLOG SYSLOG_ENABLED LOG_FILE SYSLOG_TAG
}
##
# debug state of the key variables
##
function hacklets_debug_state() {
    echo "Key variables:
    HACKLETS_DIST_DIR: $HACKLETS_DIST_DIR
    HACKLETS_EXEC_NAME: $HACKLETS_EXEC_NAME 
    ---------------------------------------------------------------------------
    HACKLETS_MASTERDIR_NAME: $HACKLETS_MASTERDIR_NAME
    HACKLETS_BACKENDDIR_NAME: $HACKLETS_BACKENDDIR_NAME
    ---------------------------------------------------------------------------
    HACKLETS_CONTAINER_DIR: $HACKLETS_CONTAINER_DIR
    HACKLETS_BACKENDDIR: $HACKLETS_BACKENDDIR
    HACKLETS_MASTERDIR: $HACKLETS_MASTERDIR
    HACKLETS_MASTER_TPL_DIR: $HACKLETS_MASTER_TPL_DIR"
}

##
# executes git with the right values for --git-dir and --work-tree
#
# it catches the output and logs it accordingly, and returns the
# status of the git command
##
function hacklets_cmd() {
    #working:
    #   array=( "$@" );
    #   OUT=`cat "${array[@]}"`
    ########
    argv=("$@");
    local HACKLETS_RESULT=`git --git-dir=${HACKLETS_MASTERDIR} --work-tree=${HACKLETS_CONTAINER_DIR} "${argv[@]}" 2>&1`
    local ERROR="$?"

    ############ begin: building the command, preserve quotes around parameters
    # the idea: multi-words params need to be quoted
    local COMMAND="hacklets_cmd"
    local SHORT_COMMAND="hacklets_cmd"
    for word in "${argv[@]}"; do
        words="${word//[^\ ]} "
        if [[ ${#words} > 1 ]]; then
            local SHORT_COMMAND="$SHORT_COMMAND \"${word:0:32}...\""
            local COMMAND="$COMMAND \"${word}\""
        else
            local SHORT_COMMAND="$SHORT_COMMAND ${word:0:32}"
            local COMMAND="$COMMAND $word"
        fi
    done
    ############ end: building command

    if [[ $ERROR == 0 ]]; then
        msg_ok "${SHORT_COMMAND:0:$[COLUMNS-15]}"
    else
        msg_fail "${SHORT_COMMAND:0:$[COLUMNS-15]}"
    fi
    #TODO long along with this, also $HACKLETS_MASTERDIR and HACKLETS_CONTAINER_DIR
    log "Command: $COMMAND gave: '$HACKLETS_RESULT'"
    if [[ ! -z $HACKLETS_RESULT ]]; then
        echo "-------------------------------------------------------------------------------"
        echo "$HACKLETS_RESULT"
        echo "-------------------------------------------------------------------------------"
    fi
    return "$ERROR"
}
##
# initialize $HACKLETS_MASTERDIR_NAME (in the CWD) as a hacklets container
# 
# @param alternative CWD
##
function hacklets_init() {
    if [[ ! -z $1 ]]; then
        HACKLETS_CONTAINER_DIR="$1"
    else
        HACKLETS_CONTAINER_DIR=`pwd`
    fi

    HACKLETS_BACKENDDIR="${HACKLETS_CONTAINER_DIR}/${HACKLETS_BACKENDDIR_NAME}"
    HACKLETS_MASTERDIR="${HACKLETS_CONTAINER_DIR}/${HACKLETS_MASTERDIR_NAME}"
    HACKLETS_CMD="git --git-dir=${HACKLETS_MASTERDIR} --work-tree=${HACKLETS_CONTAINER_DIR}"

    cmd "mkdir -p ${HACKLETS_MASTERDIR}"
    if [[ 0 != $? ]]; then return $?; fi
    cd ${HACKLETS_MASTERDIR}
    if [[ 0 != $? ]]; then
        msg_fail "cd ${HACKLETS_MASTERDIR}"
        return $?;
    fi
    msg_ok "cd ${HACKLETS_MASTERDIR}"
    #TODO: use $GIT_TEMPLATE_DIR, to give the user the chance to override it via --template or GIT_TEMPLATE_DIR
    cmd "git init --bare --template=${HACKLETS_MASTER_TPL_DIR}"
    if [[ 0 != $? ]]; then return $?; fi
    cd $HACKLETS_CONTAINER_DIR
    msg_ok "cd $HACKLETS_CONTAINER_DIR"
}

##
# fetch a hacklet, it's like fetching a repo, but a little bit more twisted (so we maintain flexibility for commads like "hacklet checkout")
##
function hacklets_fetch() {
    if [[ ! -n $1 ]]; then
        msg_fail "first param: URL or name, if name, provide URL as second param"
        return 1;
    fi
    local hname="$1"
    local hurl="$2"
    if [[ -z $hurl ]]; then
        local hurl="${hname}"
        #TODO normalize hurl and set value to hname
        msg_debug "hname: $hname"
        msg_debug "hurl: $hurl"
        msg_fail "TODO"
        return 1
    fi
    cmd "git clone --recursive --bare "${hurl}" "${HACKLETS_BACKENDDIR}/${hname}.git""
    if [[ 0 != $? ]]; then return $?; fi
    hacklets_cmd remote add hacklet/${hname} ${HACKLETS_BACKENDDIR}/${hname}.git
    if [[ 0 != $? ]]; then return $?; fi
    # TODO the following gives "warning: no common commits", see how you can fix it
    hacklets_cmd fetch hacklet/${hname}
    if [[ 0 != $? ]]; then return $?; fi
    hacklets_cmd config --local --add remotes.hacklets hacklet/${hname}
    if [[ 0 != $? ]]; then return $?; fi
    return 0
}

function hacklets_update() {
    return 1 # TODO
}

##
# lists all the available hacklets in the current container
##
function hacklets_list() {
    hacklets_cmd config --local --get-all remotes.hacklets
    return $?
}

##
# create a new empty profile
# 
# @param the name of the profile
##
function hacklets_new_profile() {
    if [[ ! -n $1 ]]; then
        msg_fail "you must supply a profile name"
        return 1;
    fi
    local profname="$1"
    if ! _hacklets_profile_exists "${profname}"; then
        msg_fail "Profile $profname already exists"
        return 1
    fi
    hacklets_cmd checkout --orphan profile/${profname}
    if [[ 0 != $? ]]; then return $?; fi
    echo "This is the beginning of profile ${profname}." > "${HACKLETS_CONTAINER_DIR}/README.txt"
    hacklets_cmd add "${HACKLETS_CONTAINER_DIR}/README.txt"
    hacklets_cmd commit -q -m "This is the beginning of profile ${profname}"
    hacklets_cmd rm -q "${HACKLETS_CONTAINER_DIR}/README.txt"
    hacklets_cmd commit -q -m "profile ready to be populated with hacklets"
    hacklets_cmd tag -a -m "profile $profname" start-$profname
}

##
# adopt an existing (fetched) hacklet into the current profile
##
function hacklets_adopt() {
    eval $(_hacklets_get_active_profile)
    if [[ ! $RETURN ]]; then
        msg_fail "Please activate a profile first"
        unset RETURN
        return 1
    fi
    local profname=$RETURN
    unset RETURN
    if [[ ! -n $1 ]]; then
        msg_fail "adopt <hacklet-name> [hacklet's branch]"
        return 1
    fi
    if [[ ! -n $2 ]]; then
        local branchname="master"
    else
        #TODO check if branch $2 exists
        local branchname="$2"
    fi
    local hname="$1"

    hacklets_cmd tag -a -m "before installing $hname" "before-install-$hname"
    local mergemsg="using hacklet/$hname/$branchname in profile $profname"
    hacklets_cmd merge -m "$mergemsg" "hacklet/${hname}/${branchname}"
    local isconflict=0
    local conflictsolved=0
    if [[ -f "${HACKLETS_MASTERDIR}/MERGE_MSG" ]]; then
        grep -q '^Conflicts:' "${HACKLETS_MASTERDIR}/MERGE_MSG"
        isconflict=1
        if [[ 0 == $? ]]; then 
            hacklets_cmd mergetool -y
            if [[ 0 == $? ]]; then
                hacklets_cmd commit -a
                conflictsolved=1
            fi
        fi
    fi
    if [[ $isconflict && $conflictsolved ]]; then
        msg_info "TODO: there was a conflict, now it's solved. Show notification, prompt for action"
    fi
    hacklets_cmd tag -a -m "installed $hname" install-$hname
    if [[ 0 != $? ]]; then return $?; fi
    local HEAD=`${HACKLETS_CMD} rev-parse HEAD`
    hacklets_cmd config --local --add profiles.$profname.$hname.$branchname $HEAD
    if [[ 0 != $? ]]; then return $?; fi
    return 0
}

##
# uninstalls a hacklet from the current profile
#
# work in progress
##
function _hacklets_disown() {
    if [[ ! -n $1 ]]; then
        msg_fail "Please provide a hacklet name"
        return 1
    fi
    local hname="$1"
    eval $(_hacklets_get_active_profile)
    local profname=$RETURN
    if [[ ! $RETURN ]]; then
        msg_fail "Please activate a profile first"
        unset RETURN
        return 1
    fi
    unset RETURN
    local COMMIT=`$HACKLETS_CMD config --local --get-regexp profiles.$profname.$hname.*`
    if [[ 0 != $? ]]; then
        msg_fail "hacklets_cmd config --local --get-regexp profiles.$profname.$hname.*"
        return $?;
    fi
    msg_ok "hacklets_cmd config --local --get-regexp profiles.$profname.$hname.*"
    #TODO check if 1 == `echo "$COMMIT" | wc -l`, if not, then error
    local COMMIT=`echo "$COMMIT" | cut -d ' ' -f 2`
    hacklets_cmd revert -m 1 $COMMIT
}

###############################################################################
# internal function, do not rely on these
###############################################################################
function _hacklets_profile_exists() {
    if [[ 0 != `hacklets_cmd branch --no-color --list "profile/$1"` ]]; then
        return 0
    else
        return 1
    fi
}


function _hacklets_get_active_profile() {
    local RETURN=`hacklets_cmd branch -a --no-color --list "profile/*" | grep '^* ' | sed 's/* profile\///'`
    if [[ -z $RETURN ]];
        then return 1
    fi
    echo "RETURN="${RETURN}""
    return 0
}

##
# create some testing bare repos in /tmp/hacklets-mocs/*.git/
# 
# TODO: move this somewhere else (part of the working copy, not of the distribution in bin/)
##

function _hacklets_mock_repo() {
    local name="$1"
    local file="$2"

    cmd "mkdir -p /tmp/hacklets-mocs/checkouts/"
    pushd /tmp/hacklets-mocs/
    mkdir "${name}repo.git"
    cd "${name}repo.git"
    git --bare init
    cd ../checkouts/
    git clone --recursive "../${name}repo.git"
    cd "${name}repo"
    echo "testing $name repo" > $file
    git add $file
    git commit -m "initial commit of $name repo"
    git push origin master
    popd
}
function hacklets_demo_repos() {
    rm -rf /tmp/hacklets-mocs/
    _hacklets_mock_repo first README.txt
    _hacklets_mock_repo second README.txt
    _hacklets_mock_repo third README.txt
    _hacklets_mock_repo unrelated INSTALL.txt
}
