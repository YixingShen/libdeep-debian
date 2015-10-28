#!/bin/bash

# Generates packaging for libdeep

rm -f Makefile

packagemonkey -n "libdeep" --version "1.00" --cmd --dir "." -l "bsd" -e "Bob Mottram (4096 bits) <bob@robotics.uk.to>" --brief "C Library for deep learning" --desc "Makes using deep learning easy to include within any C/C++ application." --homepage "https://github.com/bashrc/libdeep" --repository "https://github.com/bashrc/libdeep.git" --section "libs" --categories "Development/ArtificialIntelligence" --cstandard "c99" --compile "-lm -fopenmp" --dependsdeb "gnuplot, doxygen"
