#!/bin/bash
sudo dmidecode | grep -e Date -e Vendor -e Version -e Product | head -n 4