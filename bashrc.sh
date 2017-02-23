# This file contains various setup for my bash


# clone a project quickly

function clone() {
    unset http_proxy
    unset https_proxy
    git clone ssh://H2404689@10.195.229.38:29418/"$@"
}
