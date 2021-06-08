#!/bin/bash
initial=0.1
end=0.9
inc=0.1

for i in $(LC_ALL=en_US.UTF-8 seq $initial $inc $end);
do 
  # Clean all images from previous run
  cd mve/images 
  rm -fr *
  cd ../..
  # Generate new images
  make run COEFF="$i";
  # Get number of images
  cd mve/images 
  shopt -s nullglob
  numfiles=(*)
  numfiles=${#numfiles[@]}
  cd ../..
  # Start reconstruction
  start=$(date +%s);
  cd mve
  mve.makescene -i ./images "scene$i" || true
  mve.sfmrecon "scene$i" || true 
  mve.dmrecon -s2 "scene$i" || true 
  mve.scene2pset -F2 "scene$i" "scene$i"/pset-L2.ply || true
  mve.fssrecon "scene$i"/pset-L2.ply "scene$i"/surface-l2.ply || true
  mve.meshclean -t10 "scene$i"/surface-l2.ply "scene$i"/surface-l2-clean.ply || true
  end=$( date +%s );
  timetaken=$((end - start))
  cd .. 
  # Write data in file
  echo "$i $timetaken $numfiles" >> "measurements"
done
