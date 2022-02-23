#!/bin/bash
gunzip -c chm13.draft_v1.1.gene_annotation.v4.gff3.gz > chm13_v1.1.gene_annotation.gff3

gffread chm13_v1.1.gene_annotation.gff3 -T -o chm13_v1.1.gene_annotation.gtf -F

grep 'LOFF_' chm13_v1.1.gene_annotation.gtf | \
awk '{OFS="\t"}{print $10,$12,$22,$14,$16,$18}' > loff_tmp.txt

grep 'CHM13_' chm13_v1.1.gene_annotation.gtf | \
awk '{OFS="\t"}{print $10,$12,$14,$16,$18,$22}' > chm13_tmp.txt

cat loff_tmp.txt chm13_tmp.txt | \
grep 'ENST' | \
sed 's/\"//g' | \
sed 's/\;//g' > chm13_v1.1.transcript_ids.txt

gunzip -c ../fasta/chm13.draft_v1.1.fasta.gz > ../fasta/chm13.draft_v1.1.fasta

gffread -w ../fasta/chm13_v1.1.transcripts.fa -g ../fasta/chm13.draft_v1.1.fasta chm13_v1.1.gene_annotation.gtf

zcat < chm13.draft_v1.1.gene_annotation.v4.gff3.gz | \
grep 'source_gene_common_name' | \
awk '$3 == "gene" {print $1,$4,$5,$7,$9}' | \
# sed -e 's/.*source_gene_common_name=\(.*\);gene_id=.*/\1/' | \
sed 's/;/\t/g' | \
awk '{OFS="\t"}{print $1,$2,$3,$4,$5,$6,$7}' | \
sed -e s/source_gene_common_name=//g | \
sed -e s/source_gene=//g | \
sed -e s/gene_biotype=//g | \
sed -e s/gene_name=//g | \
awk '{OFS="\t"}{if ($6 == "rRNA"){print $1,$2,$3,$4,$5,"None",$6} if ($6 != "rRNA") {print $1,$2,$3,$4,$5,$6,$7 }}' \
> chm13_v1.1.genes_gff_coordinates.txt

awk '{print $7}' chm13_v1.1.genes_gff_coordinates.txt | sort -u > chm13_v1.1.biotype_categories.txt

gzip chm13_v1.1.gene_annotation.gtf #> chm13_v1.1.gene_annotation.gtf.gz
gzip ../fasta/chm13_v1.1.transcripts.fa #> chm13_v1.1.transcripts.fa.gz

rm chm13_v1.1.gene_annotation.gff3
#rm ../fasta/chm13.draft_v1.1.fasta
rm loff_tmp.txt
rm chm13_tmp.txt

if ! [ -x "$(command -v kallisto)" ]
then
  mkindex = true
else
  mkindex = false
fi
if [ "$mkindex" == true ]
then
  kallisto index -i chm13_v1.1_transcriptome.idx ../fasta/chm13_v1.1.transcripts.fa
#  rm ../fasta/chm13_v1.1.transcripts.fa
fi
