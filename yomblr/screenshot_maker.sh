#!/bin/sh

for file in Resources/ScreenShot/Origin/*; do
  basename=`basename ${file}`
  basename=`echo ${basename} | sed 's/ /_/g'`
  convert -crop 2208x1242+56+54 -rotate 90 -alpha Off "${file}" "Resources/ScreenShot/${basename}"
done
