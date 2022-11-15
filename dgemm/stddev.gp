reset session

INPUT_PATH = ARG1
OUTPUT_FILE = ARG2
TITLE = ARG3

set terminal png size 1280,720
set output OUTPUT_FILE

set style data histogram
set style histogram cluster gap 1
set style fill solid
set boxwidth 0.9

set key autotitle columnhead
set datafile separator ";"

set grid ytics
set yrange [0:100]

set title TITLE

FILES = system("ls ".INPUT_PATH."*.dat")

plot for [file in FILES] file using (($10/$9)*100):xtic(1) title system("basename ".file." .dat") noenhanced