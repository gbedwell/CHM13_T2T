#!/bin/bash

helpFunction()
{
   echo ""
   echo "Usage: $0 -i parameterI -n parameterN -d parameterD"
   echo -e "\t-i Input file. The path to the large multi-entry fasta file."
   echo -e "\t-n Collapsed input file. The filename for the one-entry-per-line fasta file created from the input file."
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
echo "Input multi-fasta file: $parameterI"
echo "Collapsed fasta file: $parameterN"
echo "Directory for individual fasta files: $parameterD"
echo

echo "Collapsing multi-fasta file..."
awk '/^>/ { print (NR==1 ? "" : RS) $1; next } { printf "%s", $0 } END { printf RS }' ${parameterI} > ${parameterN}

echo "Making directory ${parameterD}..."
mkdir -p ${parameterD}

cd ${parameterD}
echo "Extracting individual chromosome sequences..."
cat ../../${parameterN} | \
awk '{
  if (substr($0, 1, 1)==">") {filename=(substr($0,2) ".fa")}
  print $0 >> filename
  close(filename)
}'
cd ../..

rm ${parameterN}

echo "Compressing individual fasta files..."
gzip ${parameterD}/*.fa

echo "Done!"
