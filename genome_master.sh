#!/bin/bash
mkdir -p fasta
mkdir -p annotations
mkdir -p chain_files
mkdir -p BSgenome

cd fasta
wget https://s3-us-west-2.amazonaws.com/human-pangenomics/T2T/CHM13/assemblies/analysis_set/chm13v2.0.fa.gz
cd ..

cd chain_files
wget https://s3-us-west-2.amazonaws.com/human-pangenomics/T2T/CHM13/assemblies/chain/v1_nflo/grch38-chm13v2.chain
wget https://s3-us-west-2.amazonaws.com/human-pangenomics/T2T/CHM13/assemblies/chain/v1_nflo/chm13v2-grch38.chain
wget https://s3-us-west-2.amazonaws.com/human-pangenomics/T2T/CHM13/assemblies/chain/v1_nflo/hg19-chm13v2.chain
wget https://s3-us-west-2.amazonaws.com/human-pangenomics/T2T/CHM13/assemblies/chain/v1_nflo/chm13v2-hg19.chain
cd ..

cd annotations
wget http://courtyard.gi.ucsc.edu/~mhauknes/T2T/t2t_Y/annotation_set/CHM13.v2.0.gff3
if [ -x "$(command -v gffread)" ]
then
  ../annotation_processing.sh
else
  echo
  echo "Annotation processing requires gffread."
  echo "gffread is available at https://anaconda.org/bioconda/gffread or https://github.com/gpertea/gffread"
  echo
  echo "Unzipping genome fasta file for downstream steps..."
  gunzip -c fasta/chm13v2.0.fa.gz > fasta/chm13v2.fa
fi

cd ..

# gunzip -c fasta/chm13v2.0.fa.gz > fasta/chm13v2.fa
./fasta_split.sh -i <(gzcat ../fasta/chm13v2.0.fa.gz) -n fasta/multi_collapsed.fa -d fasta/split_fasta
# rm fasta/chm13v2.fa

# mv BSgenome.R BSgenome/BSgenome.R
# cd BSgenome
# touch BSgenome/BSgenome.Hsapiens.chm13v2.dms
# echo "Package: chm13v2" >> BSgenome/BSgenome.Hsapiens.chm13v2.dms
# echo "Title: Full genome sequences for Homo sapiens (CHM13v2)" >> BSgenome/BSgenome.Hsapiens.chm13v2.dms
# echo "Description: Full genome sequences for Homo sapiens (Human) as provided by Telomere2Telemore Consortium (CHM13v2.0, 03/31/2022) and stored in Biostrings objects." >> BSgenome/BSgenome.Hsapiens.chm13v2.dms
# echo "Version: 2.0" >> BSgenome/BSgenome.Hsapiens.chm13v2.dms
# echo "organism: Homo sapiens" >> BSgenome/BSgenome.Hsapiens.chm13v2.dms
# echo "common_name: Human" >> BSgenome/BSgenome.Hsapiens.chm13v2.dms
# echo "provider: T2T Consortium" >> BSgenome/BSgenome.Hsapiens.chm13v2.dms
# echo "provider_version: CHM13v2.0" >> BSgenome/BSgenome.Hsapiens.chm13v2.dms
# echo "release_date: 2022-03-31" >> BSgenome/BSgenome.Hsapiens.chm13v2.dms
# echo "release_name: CHM13 T2T v2" >> BSgenome/BSgenome.Hsapiens.chm13v2.dms
# echo "source_url: https://s3-us-west-2.amazonaws.com/human-pangenomics/T2T/CHM13/assemblies/analysis_set/chm13v2.0.fa.gz" >> BSgenome/BSgenome.Hsapiens.chm13v2.dms
# echo "organism_biocview: Homo_sapiens" >> BSgenome/BSgenome.Hsapiens.chm13v2.dms
# echo "BSgenomeObjname: Hsapiens" >> BSgenome/BSgenome.Hsapiens.chm13v2.dms
# echo "seqnames: c(paste(\"chr\", 1:22, sep=\"\"), \"chrX\", \"chrY\", \"chrM\")" >> BSgenome/BSgenome.Hsapiens.chm13v2.dms
# echo "circ_seqs: \"chrM\"" >> BSgenome/BSgenome.Hsapiens.chm13v2.dms
# echo "seqs_srcdir: $PWD/fasta/split_fasta" >> BSgenome/BSgenome.Hsapiens.chm13v2.dms
# echo "seqfiles_suffix: .fa.gz" >> BSgenome/BSgenome.Hsapiens.chm13v2.dms
# echo "ondisk_seq_format: 2bit" >> BSgenome/BSgenome.Hsapiens.chm13v2.dms
# Rscript ./BSgenome.R
# cd BSgenome
# R CMD build BSgenome.Hsapiens.chm13v2
# R CMD check BSgenome.Hsapiens.chm13v2_2.0.tar.gz
# R CMD INSTALL cBSgenome.Hsapiens.chm13v2_2.0.tar.gz
# cd ..
echo
echo DONE!
