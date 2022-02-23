#!/bin/bash

helpFunction()
{
   echo ""
   echo "Converts genomic coordinate positions between 1-start full-closed, 0-start full-closed, and 0-start half-closed."
   echo
   echo "For full-closed coordinates, both the start and end coordinates are included as part of the interval. Example: an annotation spanning the first 10 nucleotides of a chromosome would be denoted as [1,10] or [0,9] in 1- and  0-based, full-closed systems, respectively."
   echo
   echo "For half-closed coordinates, only the start coordinate is included. The end coordinate is not. Example: the same annotation described above would be denoted as [0,10) in a 0-based, half-closed system."
   echo
   echo "This script requires the coordinates to be in columns 1-3 in tab-delimited format as chromosome start end. Other columns after these will get reprinted as-is."
   echo
   echo "If coordinates are in position format (i.e. chr:start-end), defining -e will split the coordinates into tab-delimited format and save to a new file. This assumes the coordinates are in column 1. "
   echo
   echo "Usage: $0 -a parameterA -b parameterB -c parameterC -d parameterD -e parameterE"
   echo -e "\t-a The input file."
   echo -e "\t-b The output file."
   echo -e "\t-c The coordinate system of the input file. Possible options: 1_fc, 0_fc, 0_hc."
   echo -e "\t-d The coordinate system of the output file. Possible options: 1_fc, 0_fc, 0_hc."
   echo -e "\t-e (Optional) If true, will assume that the first column of the data is in position format and will convert it to tab-delimited format."
   exit 1 # Exit script after printing help
}

parameterE=false
while getopts "a:b:c:d:e:" opt
do
   case "$opt" in
      a ) parameterA="$OPTARG" ;;
      b ) parameterB="$OPTARG" ;;
      c ) parameterC="$OPTARG" ;;
      d ) parameterD="$OPTARG" ;;
      e ) parameterE=true ;;
      ? ) helpFunction ;; # Print helpFunction in case parameter is non-existent
   esac
done

if $parameterE;
then
  if [ -z "$parameterA" ] || [ -z "$parameterB" ] || [ -z "$parameterC" ] || [ -z "$parameterD" ]
  then
     echo "Some or all of the parameters are empty. You must define input/output files and the coordinate systems for both.";
     helpFunction
  fi

  if [[ $parameterC = "1_fc" && $parameterD == "0_fc" ]]
  then
    awk  '{gsub(":","\t",$0); print;}' $parameterA | \
    awk '{gsub("-","\t",$2); print;}' | \
    awk '{OFS = "\t"} {$2 = $2-1} {$3 = $3-1} 1' > $parameterB
  fi

  if [[ $parameterC = "1_fc" && $parameterD == "0_hc" ]]
  then
    awk  '{gsub(":","\t",$0); print;}' $parameterA | \
    awk '{gsub("-","\t",$2); print;}' | \
    awk '{OFS = "\t"} {$2 = $2-1} {$3 = $3} 1' > $parameterB
  fi

  if [[ $parameterC = "0_fc" && $parameterD == "0_hc" ]]
  then
    awk  '{gsub(":","\t",$0); print;}' $parameterA | \
    awk '{gsub("-","\t",$2); print;}' | \
    awk '{OFS = "\t"} {$2 = $2} {$3 = $3+1} 1' > $parameterB
  fi

  if [[ $parameterC = "0_fc" && $parameterD == "1_fc" ]]
  then
    awk  '{gsub(":","\t",$0); print;}' $parameterA | \
    awk '{gsub("-","\t",$2); print;}' | \
    awk '{OFS = "\t"} {$2 = $2+1} {$3 = $3+1} 1' > $parameterB
  fi

  if [[ $parameterC = "0_hc" && $parameterD == "0_fc" ]]
  then
    awk  '{gsub(":","\t",$0); print;}' $parameterA | \
    awk '{gsub("-","\t",$2); print;}' | \
    awk '{OFS = "\t"} {$2 = $2} {$3 = $3-1} 1' > $parameterB
  fi

  if [[ $parameterC = "0_hc" && $parameterD == "1_fc" ]]
  then
    awk  '{gsub(":","\t",$0); print;}' $parameterA | \
    awk '{gsub("-","\t",$2); print;}' | \
    awk '{OFS = "\t"} {$2 = $2+1} {$3 = $3} 1' > $parameterB
  fi

else

  if [ -z "$parameterA" ] || [ -z "$parameterB" ] || [ -z "$parameterC" ] || [ -z "$parameterD" ]
  then
     echo "Some or all of the parameters are empty. You must define input/output files and the coordinate systems for both.";
     helpFunction
  fi

  if [[ $parameterC = "1_fc" && $parameterD == "0_fc" ]]
  then
    awk '{OFS = "\t"} {$2 = $2-1} {$3 = $3-1} 1' $parameterA > $parameterB
  fi

  if [[ $parameterC = "1_fc" && $parameterD == "0_hc" ]]
  then
    awk '{OFS = "\t"} {$2 = $2-1} {$3 = $3} 1' $parameterA > $parameterB
  fi

  if [[ $parameterC = "0_fc" && $parameterD == "0_hc" ]]
  then
    awk '{OFS = "\t"} {$2 = $2} {$3 = $3+1} 1' $parameterA > $parameterB
  fi

  if [[ $parameterC = "0_fc" && $parameterD == "1_fc" ]]
  then
    awk '{OFS = "\t"} {$2 = $2+1} {$3 = $3+1} 1' $parameterA > $parameterB
  fi

  if [[ $parameterC = "0_hc" && $parameterD == "0_fc" ]]
  then
    awk '{OFS = "\t"} {$2 = $2} {$3 = $3-1} 1' $parameterA > $parameterB
  fi

  if [[ $parameterC = "0_hc" && $parameterD == "1_fc" ]]
  then
    awk '{OFS = "\t"} {$2 = $2+1} {$3 = $3} 1' $parameterA > $parameterB
  fi

fi
