#!/bin/bash

helpFunction()
{
   echo ""
   echo "Usage: $0 -i parameterI -n parameterN -d parameterD"
   echo -e "\t-i The path to the large multi-entry fasta file."
   echo -e "\t-n The filename for the output one-entry-per-line file."
   echo -e "\t-d The directory to store the individual chromosome fasta files."
   exit 1 # Exit script after printing help
}

while getopts "i:n:d:" opt
do
   case "$opt" in
      i ) parameterI="$OPTARG" ;;
      n ) parameterN="$OPTARG" ;;
      d ) parameterD="$OPTARG" ;;
      ? ) helpFunction ;; # Print helpFunction in case parameter is non-existent
   esac
done

# Print helpFunction in case parameters are empty
if [ -z "$parameterI" ] || [ -z "$parameterN" ] || [ -z "$parameterD" ]
then
   echo "Some or all of the parameters are empty";
   helpFunction
fi

# Begin script in case all parameters are correct
echo "$parameterI"
echo "$parameterN"
echo "$parameterD"
echo

awk '/^>/ {printf("\n%s\n",$0);next;} {printf("%s",$0);}  END {printf("\n");}' ${parameterI} > ${parameterN}

mkdir ${parameterD}

while read line
do
  if [[ ${line:0:1} == '>' ]]
  then
    outfile=${line#>}.fa
    echo $line > ${parameterD}/${outfile}
  else
    echo $line >> ${parameterD}/${outfile}
  fi
done < ${parameterN}

rm ${parameterN}
gzip ${parameterD}/*.fa
