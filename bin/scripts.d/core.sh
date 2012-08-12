GIT_HACKLET_BASEDIR_NAME=.hacklets
GIT_HACKLET_MASTER_NAME=_master

#source ${0%/*}/scripts.d/bsfl

# initializes the current directory as a hacklets directory
function hacklet_init() {
    if [ ! -n "$1" ]; then
        return 1;
    fi
    local master="$1"
    local PWD=`pwd`
    #TODO ask for confirmation, give the chance to skip
    rm -rf ./* ./.*
    mkdir -p "$GIT_HACKLET_BASEDIR_NAME/$master"
    pushd "$GIT_HACKLET_BASEDIR_NAME/$master"
    git init --template=""
    touch .gitignore
    git add .gitignore
    git commit -m "initial commit for hacklets [$PWD]"
    popd
    echo "$master" > "$GIT_HACKLET_BASEDIR_NAME/$GIT_HACKLET_MASTER_NAME"
}

# hacklet_fetch($name, $repository)
# fetch repo at URL $repository into local directory $name
# this does not check it out, outside of GIT_HACKLET_BASEDIR_NAME
function hacklet_fetch() {
    if [ ! -n "$1" ]; then
        return 1;
    fi
    if [ ! -n "$2" ]; then
        return 1;
    fi
    local name="$1"
    local repository="$2"
    git clone --recursive --bare "$repository" "$GIT_HACKLET_BASEDIR_NAME/$name"
    git config -f "$GIT_HACKLET_BASEDIR_NAME/${name}/config" core.bare false
    git config -f "$GIT_HACKLET_BASEDIR_NAME/${name}/config" core.worktree "../../"
    mkdir -p "$GIT_HACKLET_BASEDIR_NAME/${name}/info"
    echo "$GIT_HACKLET_BASEDIR_NAME/" >> $GIT_HACKLET_BASEDIR_NAME/${name}/info/exclude
    return 0;
}

function hacklet_install2() {
    if [ ! -n "$1" ]; then
        return 1;
    fi
    local url="$1"
}

# hacklet_install($name)
# installs the locally fetched hacklet outside of GIT_HACKLET_BASEDIR_NAME
function hacklet_install() {
    if [ ! -n "$1" ]; then
        return 1;
    fi
    local name="$1"
    # TODO fix for multiple branches having _init
    for branch in `git --git-dir=$GIT_HACKLET_BASEDIR_NAME/$name for-each-ref --format="%(refname)" $LOC`; do
        local found=$(git --git-dir=$GIT_HACKLET_BASEDIR_NAME/$name ls-tree -r --name-only $branch | grep "_init")
        if [ ! -z "$found" ]; then
            local src=$(git --git-dir=$GIT_HACKLET_BASEDIR_NAME/$name show $branch:_init)
            eval "$src"
            #echo "$src"
        fi
    done

    if [[ "function" == `type -t pre_install` ]]; then
        pre_install
    fi

    git hacklet run "${name}" "git checkout"

    if [[ "function" = `type -t post_install` ]]; then
        post_install
    fi
    return 0;
}

function hacklet_uninstall() {
    if [ ! -n "$1" ]; then
        return 1;
    fi
    local name="$1"
    # TODO uninstall, remove files tracked by hacklet $name
    return 0;
}

function hacklet_remove() {
    if [ ! -n "$1" ]; then
        return 1;
    fi
    local name="$1"
    # TODO remove directory from GIT_HACKLET_BASEDIR_NAME
    return 0;
}

function hacklet_filelist() {
    if [ ! -n "$1" ]; then
        local name="master"
    else
        local name="$1"
    fi
    # TODO get file list
    return 0;
}
