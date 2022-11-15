reset session

set terminal png size 1280,720
set output ARG2

set style data histogram
set style histogram cluster gap 1
set style fill solid
set boxwidth 0.9

set key autotitle columnhead
set datafile separator ";"

set grid ytics

set title "Mean runtime per implementation"

FILES = system("ls ".ARG1."*.dat")

plot for [file in FILES] file using 9:xtic(1) title system("basename ".file." .dat")

max=0
min=-1
do for [file in FILES] {
    stats file u 9 nooutput name 't_' #get max and min of mean values
    if (max < t_max) {max=t_max}
    if (min == -1 ) {min=t_min} else {if (min > t_min) {min=t_min}}
}
set print "MaxVal.log"
print(max)
set print "MinVal.log"
print(min)
unset print