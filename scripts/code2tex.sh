#!/bin/bash
#
# This file converts the given source code file to a .tex file.
if [ $# -lt 1 ]
then
  echo "At least one file required!"
fi
for infile in "$@"
do
  outfile=${infile}".tex"
  echo "\begin{verbatim}" > ${outfile}
  awk '// {print $0}' ${infile} >> ${outfile}
  echo "\end{verbatim}" >> ${outfile}
done

