#!/bin/bash
#
# Author: Quan Zhuo
#

function usage() {
    cat <<EOF
Usage: auto_patch.sh d1c_src_path ple_src_path

Generate patch in each project in d1c repo, then
apply the patch to the corresponging ple project.

NOTE: 'd1c_src_path' is your d1c source code directory,
and 'ple_src_path' is your ple source code directory.
EOF
    exit 0
}

if [ $# -ne 2 ];then
    echo -e "\e[31mERROR\e[0m: argument count"
    usage
fi

if ! [ -d $1/.repo -a -d $2/.repo ]; then
    echo -e "\e[31mERROR\e[0m: $1 or $2 is not a repository"
    echo
    usage
fi

d1c_base=`realpath $1`
ple_base=`realpath $2`

# 1. Save the current HEAD

cd $d1c_base
tbrepo forall -p -c '
git rev-parse @ > prevHEAD
'

# 2. Sync code from tb
repotb sync;
while ! [ $? -ne 0 ]
do
    repotb sync
done

# 3. Statistics the changes
tbrepo forall -p -c '
prevHEAD=`cat prevHEAD`
count=`git log --oneline ${prevHEAD}..@ | wc -l`
if [ $count -ne 0 ];then
  echo "commits: $count"
fi
' >> ~/result

tbrepo forall -p -c '
prevHEAD=`cat prevHEAD`
count=`git log --oneline ${prevHEAD}..@ | wc -l`
echo "commits: $count"
' | grep commits: | awk -F: '{sum += $2}; \
END{print "Total commits: ", sum}'  >> ~/result


# 4. Generate patches

tbrepo forall -p -c '
prevHEAD=`cat prevHEAD`
git format-patch ${prevHEAD}..@
'

# 5. Copy patches in d1c project to ple project

tbrepo forall -p -c '
d1c_proj_path=`pwd`
git_path=`get_git_path $d1c_base $d1c_proj_path`
ple_proj_path=$ple_base/$git_path/
if ls 0*.patch &> /dev/null;then
  if [ -d $ple_proj_path ];then
    cp -v $d1c_proj_path/0*.patch $ple_proj_path/
  else
    echo "ERROR: git project $git_path does not exist in ple" >> ~/result
  fi
fi
'

# 6. Apply patches in ple projects

cd $ple_base
zzrepo forall -p -c '
if ls 0*.patch &> /dev/null; then
  if git am --ignore-space-change
