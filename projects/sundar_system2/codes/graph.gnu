
reset

unset key
set grid xtics ytics ls 3 lw 1 lc rgb 'gray'

#filename = 'salida.txt'
stats filename using 2 nooutput name 'Y_'
stats filename using 1 every ::Y_index_min::Y_index_min nooutput
X_min = STATS_min
stats filename using 1 every ::Y_index_max::Y_index_max nooutput
X_max = STATS_max

#set xrange[X_min:X_max]
#set yrange[Y_min:Y_max]
set xlabel 'x_{n}'
set ylabel 'y_{n}'
set title "Titulo"
#plot filename u ($1):($2) t "Grafica" linetype 1 linecolor -1 pointsize 0.05
plot filename u ($1):($2) t "Grafica" w l lc -1 lw 1
pause -1
# Ejecutar en terminal de la siguiente manera
# gnuplot -e "filename='salida.txt'" graph.gnu
