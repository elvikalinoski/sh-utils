#!/bin/bash

if [ `whoami` == 'root' ]; then
    echo I am root
else
    echo I am not root
fi