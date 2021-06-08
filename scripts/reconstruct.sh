#!/bin/bash
cd mve
rm -fr scene
mve.makescene -i ./images scene
mve.sfmrecon scene/
mve.dmrecon -s2 scene/
mve.scene2pset -F2 scene/ scene/pset-L2.ply
mve.fssrecon scene/pset-L2.ply scene/surface-l2.ply
mve.meshclean -t10 scene/surface-l2.ply scene/surface-l2-clean.ply

