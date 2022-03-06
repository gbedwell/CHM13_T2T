#!/bin/bash
mkdir fasta
cd fasta
wget https://s3-us-west-2.amazonaws.com/human-pangenomics/T2T/CHM13/assemblies/chm13.draft_v1.1.fasta.gz
cd ..

mkdir annotations
cd annotations
wget https://s3-us-west-2.amazonaws.com/human-pangenomics/T2T/CHM13/assemblies/annotation/chm13.draft_v1.1.gene_annotation.v4.gff3.gz
wget https://s3-us-west-2.amazonaws.com/human-pangenomics/T2T/CHM13/assemblies/annotation/chm13.draft_v1.1.telomere.bed.gz
../annotation_processing.sh
cd ..

mkdir chain_files
cd chain_files
wget https://s3-us-west-2.amazonaws.com/human-pangenomics/T2T/CHM13/assemblies/changes/v1.0_to_v1.1/v1.0_to_v1.1_rdna_merged.chain
wget https://s3-us-west-2.amazonaws.com/human-pangenomics/T2T/CHM13/assemblies/changes/v1.0_to_v1.1/v1.1_to_v1.0_rdna_merged.chain
cd ..

#gunzip -c fasta/chm13.draft_v1.1.fasta.gz > fasta/chm13.draft_v1.1.fasta
../fasta_split.sh -i fasta/chm13.draft_v1.1.fasta -n fasta/multi_collapsed.fa -d fasta/single_fasta
rm fasta/chm13.draft_v1.1.fasta

mkdir BSgenome
mv BSgenome.R BSgenome/BSgenome.R
cd BSgenome
touch BSgenome.Hsapiens.T2T.CHM13v1.1.dms
echo "Package: BSgenome.Hsapiens.T2T.CHM13v1.1" >> BSgenome.Hsapiens.T2T.CHM13v1.1.dms
echo "Title: Full genome sequences for Homo sapiens (CHM13v1.1)" >> BSgenome.Hsapiens.T2T.CHM13v1.1.dms
echo "Description: Full genome sequences for Homo sapiens (Human) as provided by Telomere2Telemore Consortium (CHM13v1.1, 2021-05-07) and stored in Biostrings objects." >> BSgenome.Hsapiens.T2T.CHM13v1.1.dms
echo "Version: 1.1" >> BSgenome.Hsapiens.T2T.CHM13v1.1.dms
echo "organism: Homo sapiens" >> BSgenome.Hsapiens.T2T.CHM13v1.1.dms
echo "common_name: Human" >> BSgenome.Hsapiens.T2T.CHM13v1.1.dms
echo "provider: T2T" >> BSgenome.Hsapiens.T2T.CHM13v1.1.dms
echo "provider_version: CHM13v1.1" >> BSgenome.Hsapiens.T2T.CHM13v1.1.dms
echo "release_date: 2021-05-07" >> BSgenome.Hsapiens.T2T.CHM13v1.1.dms
echo "release_name: CHM13 T2T v1.1" >> BSgenome.Hsapiens.T2T.CHM13v1.1.dms
echo "source_url: https://s3-us-west-2.amazonaws.com/human-pangenomics/T2T/CHM13/assemblies/chm13.draft_v1.1.fasta.gz" >> BSgenome.Hsapiens.T2T.CHM13v1.1.dms
echo "organism_biocview: Homo_sapiens" >> BSgenome.Hsapiens.T2T.CHM13v1.1.dms
echo "BSgenomeObjname: Hsapiens" >> BSgenome.Hsapiens.T2T.CHM13v1.1.dms
echo "seqnames: c(paste(\"chr\", 1:22, sep=\"\"), \"chrX\", \"chrM\")" >> BSgenome.Hsapiens.T2T.CHM13v1.1.dms
echo "circ_seqs: \"chrM\"" >> BSgenome.Hsapiens.T2T.CHM13v1.1.dms
echo "seqs_srcdir: $PWD/fasta/single_fasta" >> BSgenome.Hsapiens.T2T.CHM13v1.1.dms
echo "seqfiles_suffix: .fa.gz" >> BSgenome.Hsapiens.T2T.CHM13v1.1.dms
echo "ondisk_seq_format: 2bit" >> BSgenome.Hsapiens.T2T.CHM13v1.1.dms
./BSgenome.R $PWD
cd ..
echo
echo DONE!
