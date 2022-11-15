## lscpu
lscpu > lscpu.txt
lscpu -e > lscpu_cores_states.txt
lscpu -C > lscpu_caches.txt

## /cpuinfo (1 core)
sed -n '/^$/q;p' /proc/cpuinfo > cpuinfo.txt

## Cache
echo "index" > cache.txt
ls -1 /sys/devices/system/cpu/cpu0/cache/index0/ >> cache.txt
echo "0" > temp
cat /sys/devices/system/cpu/cpu0/cache/index0/* >> temp
paste -d ' ' cache.txt temp > temp2
column -t temp2 > cache.txt
echo "2" > temp
cat /sys/devices/system/cpu/cpu0/cache/index2/* >> temp
paste -d ' ' cache.txt temp > temp2
column -t temp2 > cache.txt
echo "3" > temp
cat /sys/devices/system/cpu/cpu0/cache/index3/* >> temp
paste -d ' ' cache.txt temp > temp2
column -t temp2 > cache.txt
rm temp temp2

#compiler
echo "gcc :" > compiler_version.txt
gcc --version >> compiler_version.txt
echo "" >> compiler_version.txt; echo "" >> compiler_version.txt; echo "icc :" >> compiler_version.txt
icc --version -diag-disable=10441 >> compiler_version.txt
echo "" >> compiler_version.txt; echo "" >> compiler_version.txt; echo "icx :" >> compiler_version.txt
icx --version >> compiler_version.txt
echo "" >> compiler_version.txt; echo "" >> compiler_version.txt; echo "clang :" >> compiler_version.txt
clang --version >> compiler_version.txt
