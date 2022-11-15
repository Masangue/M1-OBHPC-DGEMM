#!/bin/bash

if [ $# -eq 0 ]
  then
    echo "Give argument :"
    echo "-i to save current cpu config"
    echo "-p set all cpu to use performance governor"
    echo "-q set all cpu to use powersave governor" #quiet
    echo "-r to restore saved cpu config"
    exit 0
fi

mkdir -p procinfo
doi=0
dop=0
doc=0
dor=0

while getopts ipqrc: flag
do
    case "${flag}" in
        i)  doi=1   
            ;;
        p)  dop=1
            doq=0
            ;;
        q)  doq=1
            dop=0
            ;;
        r)  dor=1
            ;;
    esac
done

if [ $doi -eq 1 ]
  then
    cat /sys/devices/system/cpu/cpufreq/cppolicy*/related_cpus > procinfo/prev_state_cpus
    cat /sys/devices/system/cpu/cpufreq/policy*/scaling_governor > procinfo/prev_state_governor
    echo "Saved current cpu config"
fi

if [ $dop -eq 1 ]
  then
    sudo cpupower -c all frequency-set -g performance
    echo "Set cpu governor to performance"
fi

if [ $doq -eq 1 ]
  then
    sudo cpupower -c all frequency-set -g powersave
    echo "Set cpu governor to powersave"
fi

if [ $dor -eq 1 ]
  then
    readarray -t CPUS <procinfo/prev_state_cpus
    readarray -t GOVERNOR <procinfo/prev_state_governor
    i=0
    for cpu in ${CPUS[@]}
    do
        sudo cpupower -c $cpu frequency-set -g ${GOVERNOR[$i]}
        i=$((i+1))
    done
    echo "Restored saved cpu config"
fi