#!/usr/bin/env bash

now=$(date +"%y-%m-%d_%H-%M-%S")
tmpbg='/tmp/'${now}'.png'
scrot "$tmpbg"
mkdir --parents ~/Screens/; mv $tmpbg $_
