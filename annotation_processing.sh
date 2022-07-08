#!/bin/bash
# echo "Decompressing gff file..."
# gunzip -c CHM13.v2.0.gff3.gz > chm13v2.gff3

echo "Creating gtf file for easier feature extraction..."
gffread <(gzcat chm13v2.gff3) -T -o chm13v2.gtf -F

echo "Creating necessary temporary files..."
grep 'LOFF_' chm13v2.gtf | \
awk '{OFS="\t"}{print $10,$12,$22,$14,$16,$18}' > loff_tmp.txt

grep 'CHM13_' chm13v2.gtf | \
awk '{OFS="\t"}{print $10,$12,$14,$16,$18,$22}' > chm13_tmp.txt

echo "Creating list of matched feature IDs..."
cat loff_tmp.txt chm13_tmp.txt | \
grep 'ENST' | \
sed 's/\"//g' | \
sed 's/\;//g' > chm13v2_transcript_ids.txt

# echo "Decompressing genome fasta file..."
# gunzip -c ../fasta/chm13v2.0.fa.gz > ../fasta/chm13v2.fa

echo "Extracting genome transcripts..."
gffread -w ../fasta/chm13v2_transcripts.fa -g <(gzcat ../fasta/chm13v2.0.fa.gz) chm13v2.gtf

echo "Extracting gene coordinates..."
zcat < CHM13.v2.0.gff3.gz | \
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
> chm13v2_genes_gff_coordinates.txt

echo "Creating list of biotype categories..."
awk '{print $7}' chm13v2_genes_gff_coordinates.txt | sort -u > chm13_v2_biotype_categories.txt

if [ -x "$(command -v kallisto)" ]
then
  echo "Creating kallisto index..."
  kallisto index -i chm13v2_transcriptome.idx ../fasta/chm13v2_transcripts.fa
else
  echo "Skipping kallisto index..."
fi

echo "Compressing large files..."
# gzip chm13v2.gtf
gzip ../fasta/chm13v2_transcripts.fa

# rm chm13v2.gff3
rm loff_tmp.txt
rm chm13_tmp.txt

echo "Done!"
