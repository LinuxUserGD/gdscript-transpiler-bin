#!/bin/sh

while [ "$(printf "%.0f\n" $(top -n 1 -b | awk '/^%Cpu/{print $2}'))" -gt 10 ];
do
echo "$(top -n 1 -b | awk '/^%Cpu/{print $2}')";
done
echo "Finished importing. Killing godot editor process";
kill -9 $(pgrep -o godot-bin)