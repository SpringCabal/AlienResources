#!/bin/sh
#mogrify \( -alpha extract \) -background "#5886e7" -alpha shape *.png
#color="#526ac3"
#color="#5a71c6"
color="#7a91e6"
#colorOff="#3f5185"
#colorOff="#354470"
#colorOff="#152450"
colorOff="#313a5c"

mkdir -p output
rm *_off.png
for i in *.png; do 
    #convert \( $i -alpha extract \) -background $color -alpha shape PNG32:output/"output_$i"; 
    #convert \( $i -alpha extract \) -background $colorOff -alpha shape PNG32:output/"output_$i"".off"; 
    convert $i  -modulate 50 -modulate 100,0  -type Grayscale PNG32:output/"output_$i"".off"; 
done
cd output
rename "output_" "" output_*
rename ".png.off" "_off.png" *.png.off
cd ../
mv output/* ./
rmdir output
