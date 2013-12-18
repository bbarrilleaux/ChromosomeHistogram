#!/bin/bash          
for i in *bed; do date; echo processing $i; time Rscript drawHist.r $i 2 3 0; done 