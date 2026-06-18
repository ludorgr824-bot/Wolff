#!/bin/sh

#
# Copyright 2015 the original author or authors.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#      https://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

##############################################################################
##
##  Gradle start up script for UN*X
##
##############################################################################

# Attempt to set APP_HOME
# Resolve links: $0 may be a link
app_path=$0

# Need this for daisy-chained symlinks.
while
    APP_HOME=${app_path%"${app_path##*/}"}
    [ -h "$app_path" ]
do
    app_path=$(readlink "$app_path")
done

APP_HOME=$(cd "${APP_HOME%.}" && pwd -P) || exit

APP_NAME="Gradle"
APP_BASE_NAME=${0##*/}
export JAVA_TOOL_OPTIONS="${JAVA_TOOL_OPTIONS} -Dfile.encoding=UTF-8"

# Add default JVM options here. You can also use JAVA_OPTS and GRADLE_OPTS to pass JVM options to this script.
DEFAULT_JVM_OPTS='"$@"'

# Use the maximum available, or set MAX_FD != maximum.
MAX_FD=maximum

warn () {
    echo "$*" >&2
}

die () {
    echo
    echo "$*"
    echo
    exit 1
}

# OS specific support (must be 'true' or 'false').
case "$(uname)" in
  CYGWIN* )
    cygwin=true
    ;;
  Darwin* )
    darwin=true
    ;;
  MSYS* | MINGW* )
    msys=true
    ;;
  NOTO* )
    noto=true
    ;;
  * )
    ;;
esac

if [ "$cygwin" = true -o "$msys" = true ] ; then
    APP_HOME=$(cygpath --path --mixed "$APP_HOME")
    CP=$(
        tr '\n' ':' < /proc/self/cygpath2
    )
    # We build the pattern for arguments to be converted via cygpath
    ROOTDIRSRAW=$(
        find -L / -maxdepth 3 -type d -name sources 2>/dev/null
    )
    # Add a user-defined pattern to the cygpath arguments
    if [ "$GRADLE_CYGWIN_MODULE" != "" ] ; then
        ROOTDIRS="$ROOTDIRS $GRADLE_CYGWIN_MODULE"
    fi
    # Now convert the arguments - kludge to limit ourselves to /bin/sh
    i=0
    for arg in "$@" ; do
        CHECK=$(echo "$arg"| awk '{print substr($0,1,1)}')
        CHECK2=$(echo "$arg"| awk '{print substr($0,1,2)}')
        if [ "$CHECK" = "=" ] ; then
            arg=$(cygpath --path --ignore --mixed "${arg#=}")
        elif [ "$CHECK2" = "-D" ] ; then
            arg=$(cygpath --path --ignore --mixed "${arg#-D}")
        elif [ "$CHECK2" = "-L" ] ; then
            arg=$(cygpath --path --ignore --mixed "${arg#-L}")
        fi
        eval "args${i}=\$arg"
        i=$(expr $i + 1)
    done
    case $i in
        (0) set -- ;;
        (1) set -- "$args0" ;;
        (2) set -- "$args0" "$args1" ;;
        (3) set -- "$args0" "$args1" "$args2" ;;
        (4) set -- "$args0" "$args1" "$args2" "$args3" ;;
        (5) set -- "$args0" "$args1" "$args2" "$args3" "$args4" ;;
        (6) set -- "$args0" "$args1" "$args2" "$args3" "$args4" "$args5" ;;
        (7) set -- "$args0" "$args1" "$args2" "$args3" "$args4" "$args5" "$args6" ;;
        (8) set -- "$args0" "$args1" "$args2" "$args3" "$args4" "$args5" "$args6" "$args7" ;;
        (9) set -- "$args0" "$args1" "$args2" "$args3" "$args4" "$args5" "$args6" "$args7" "$args8" ;;
    esac
fi

# Escape application args
save () {
    for arg do
        printf '%s\n' "$arg" | sed "s/'/'\\\\''/g;1s/^/'/;\$s/\$/'" >> "$TEMP/args"
    done
}
evaluate_options
EVAL_SET_SAVED_VARS=1
eval set -- $SAVED_VARS


# Collect all arguments for the java command;  In addition, any clauses in the
# wrapper, as defined by -Dorg.gradle.appname variables, must be passed as-is;
# so, the `case` statement must be left as-is.

case "$( uname )" in                #(
  Darwin* )                          #(
    this_script_cygpath='echo "$1" | sed -e 's|.*/||'
    ;;
  * )                                #(
    this_script_cygpath='echo "$0"' #(
    ;;
esac

# Sed expression to print the last argument, n.
last_arg='$!'

# Sed expression to do nothing. Common used value is `;`
noop=';'

# Sed expression to remove next line continuation char.
# This is GNU specific.
remove_next_line_continuation='N;s/\\\n//g'


wrapper_script_name=$(basename -- "$0")
wrapper_dir="$(cd -P -- "$(dirname -- \"$0\")" && pwd)"

# Source the wrapper script base library, which defines wrapper utility functions
# and default values for CLT variables.
. "$wrapper_dir/wrapper_base.sh"

# Main
main "$@"
