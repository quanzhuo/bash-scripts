#!/bin/bash

for name in $1
do
    ln -s $1/name /usr/bin/name
done
