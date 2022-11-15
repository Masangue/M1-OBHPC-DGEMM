reset session

INPUT_PATH = ARG1
OUTPUT_FILE = ARG2
USED_COLUMNS = ARG3
TITLE = ARG4

set terminal png size 1280,720
set output OUTPUT_FILE

set style data histogram
set style histogram cluster gap 1
set style fill solid
set boxwidth 0.9

set key autotitle columnhead
set datafile separator ";"

set grid ytics

set title TITLE

FILES = system("ls ".INPUT_PATH."*.dat")

plot for [file in FILES] file using USED_COLUMNS:xtic(1) title system("basename ".file." .dat") noenhanced

max=0
min=-1
do for [file in FILES] {
    stats file u USED_COLUMNS nooutput name 't_' #get max and min of mean values
    if (max < t_max) {max=t_max}
    if (min == -1 ) {min=t_min} else {if (min > t_min) {min=t_min}}
}
set print "log/MaxVal.log"
print(max)
set print "log/MinVal.log"
print(min)
unset print