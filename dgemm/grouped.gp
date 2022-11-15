reset session

INPUT_PATH=ARG1
OUTPUT_FILE=ARG2
MAX=ARG3
MIN=ARG4

set terminal png size 1280,720
set output OUTPUT_FILE

set style data histogram
set style histogram cluster gap 1
set style fill solid
set boxwidth 1
set bmargin 4
set tmargin 2

set key autotitle columnhead
set datafile separator ";"

set xtics rotate by -45 offset -1,0
set grid ytics

set yrange [MIN:MAX]
i=0
set multiplot title "Mean time (ns) by compiler with each optimization flag"

set size 0.33,0.45
FOLDERS = system("ls -d ".INPUT_PATH."*/")
do for [folder in FOLDERS] {
   
    set origin 0.33*(i-floor(i/3)*3),0.5-0.5*floor(i/3) 
    set title system("basename ".folder)

    FILES = system("ls ".folder."*.dat")
    plot for [file in FILES] file using 9:xtic(1) title system("basename ".file." .dat")
    
    i=i+1
}

unset multiplot