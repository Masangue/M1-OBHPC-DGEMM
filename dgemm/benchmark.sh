## setup environment
while getopts "sf:v:h" flag
do
    case "${flag}" in
        s)  source /opt/intel/oneapi/setvars.sh  
            ;;
        f)  sudo cpupower -c ${OPTARG} frequency-set -g performance
            ;;
        v)  WORK_CORE=${OPTARG}
            ;;
        h)  echo "Give argument :"
            echo "-s to source intel OneApi"
            echo "-f n to set cpu core n to performance"
            echo "-v to set which cpu to pin the programme to (default 4)"
            echo "-h for how to use"
            echo "none if environment is already setup"
            exit 0
            ;;
    esac
done

mkdir -p data graphs
max=0
min=-1
core=${WORK_CORE:-4}
echo $core

## Compare compil flags
for opti in O0 O1 O2 O3 Ofast
do
    ## Compare compilers
    mkdir -p data/$opti
    for comp in icc icx gcc clang
    do
        make clean
        make CC=$comp OFLAGS=-${opti}
        taskset -c $core ./dgemm 100 100 > data/${opti}/${comp}.dat
    done
    ## Pass path to files and output picture as args
    gnuplot -c compilers.gp data/${opti}/ graphs/${opti}.png
    make clean
    
    temp=$(cat MaxVal.log)
    if (( $(echo "$temp>$max" | bc -l) )); then max=$temp; fi
    temp=$(cat MinVal.log)
    if (( $(echo "$min<0" | bc -l) ))
    then
        min=$temp
    else
        if (( $(echo "$temp<$min" | bc -l) )); then min=$temp; fi
    fi
    
done
echo "min & max : $min & $max"
gnuplot -c grouped.gp data/ graphs/grouped.png $max $min