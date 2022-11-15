## setup environment
while getopts "sf:v:hr:n:m" flag
do
    case "${flag}" in
        s)  source /opt/intel/oneapi/setvars.sh  
            ;;
        f)  sudo cpupower -c ${OPTARG} frequency-set -g performance
            ;;
        v)  WORK_CORE=${OPTARG}
            ;;
        r)  RUNS=${OPTARG}
            ;;
        n)  SIZE=${OPTARG}
            ;;
        m)  MODE="memory"
            ;;
        h)  echo "Give argument :"
            echo "-s to source intel OneApi setvars script"
            echo "-f n to set cpu core n to performance"
            echo "-v to set which cpu to pin the programme to (default 4)"
            echo "-r to set the number of repetitions (default 20)"
            echo "-n to set the size of object (default 200)"
            echo "-m to run program to compare bandwidth (hight memory footprint, long run)"
            echo "-h for how to use"
            echo "none if environment is already setup"
            exit 0
            ;;
    esac
done

fmax () {
    if (( $(echo "$1>$2" | bc -l) ))
    then
        echo $1
    else
        echo $2
    fi
}

fmin () {
    if (( $(echo "$1<$2" | bc -l) ))
    then
        echo $1
    else
        echo $2
    fi
}

mkdir -p data/optis graphs/optis log
mean_max=0
mean_min=-1
core=${WORK_CORE:-4}
runs=${RUNS:-20}
size=${SIZE:-200}
echo run on core $core
echo repeat $runs times
echo with objects of size $size

## Compare compil flags
for opti in O0 O1 O2 O3 Ofast
do
    ## Compare compilers
    mkdir -p data/optis/$opti
    for comp in icc icx gcc clang
    do
        make clean
        make CC=$comp OFLAGS=-${opti}
        taskset -c $core ./dgemm $size $runs > data/optis/${opti}/${comp}.dat
    done
    ## Pass path to files and output picture as args
    gnuplot -c bar_chart.gp data/optis/${opti}/ graphs/optis/${opti}_mean_time.png "mean" "Mean runtime (ns) per version"

    temp=$(cat log/MaxVal.log)
    mean_max=$(fmax $mean_max $temp)
    temp=$(cat log/MinVal.log)
    if (( $(echo "$mean_min<0" | bc -l) ))
    then
        mean_min=$tempd
    else
        mean_min=$(fmin $mean_min $temp)
    fi

    gnuplot -c bar_chart.gp data/optis/${opti}/ graphs/optis/${opti}_bandwidth.png "MiB/s" "Bandwidth (MiB/s) per version" 
    gnuplot -c stddev.gp data/optis/${opti}/ graphs/optis/${opti}_stddev.png  "Standard deviation of mean runtime (%) per version"
    make clean
    
done
echo "min & max : $mean_min & $mean_max"
mean_max=$(echo "$mean_max+$mean_max/5" | bc -l)
mean_min=$(echo "$mean_min-$mean_max/5" | bc -l)
mean_min=$(fmax $mean_min 0)
gnuplot -c grouped.gp data/optis/ graphs/optis/grouped_optims_mean.png $mean_max $mean_min


if [ "$MODE" = "memory" ]
then
    mkdir -p data/memory graphs/memory

    make CC=gcc

    ## Compare speed / memory footprint (bandwidth)
    # cache size : 48KiB -- 1280K -- 12288K
    # l1 : 3 x matrix_size(n*n*#f64) < 48K -> n = sqrt(48*1024/3/8) -> ~45
    taskset -c $core ./dgemm 45 1000 > data/memory/under_l1_size.dat

    # l2 : 3 x matrix_size(n*n*#f64) < 1280K -> n = sqrt(1280*1024/3/8) -> ~233
    taskset -c $core ./dgemm 233 10 > data/memory/under_l2_size.dat

    # l3 : 3 x matrix_size(n*n*#f64) < 12288K -> n = sqrt(12288*1024/3/8) -> ~724
    taskset -c $core ./dgemm 724 5 > data/memory/under_l3_size.dat

    # ram
    taskset -c $core ./dgemm 900 5 > data/memory/over_l3_size.dat

    gnuplot -c bar_chart.gp data/memory/ graphs/memory/memory_footprint.png "MiB/s" "Bandwidth (MiB/s) per version"
fi