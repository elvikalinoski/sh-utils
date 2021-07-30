#!/bin/bash

# Create a file containing the variables
# EXAMPLE
# mkdir conf
# touch conf/.env
# echo KEY=12345 >> conf/.env
#

# Location of the file where it contains the variables
source ./conf/.env

# Showing the value of the variable
echo $KEY