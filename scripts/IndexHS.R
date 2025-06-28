#index

unzip("Data_RA_raw.zip", exdir = "RA_data")
library(BiocManager)
library(Rsubread)
library(Rsamtools)

#index van het referentie genoom maken
buildindex(
  basename = 'ref_homo_sapiens',
  reference = 'HS_ncbi_dataset/ncbi_dataset/data/GCF_000001405.40/GCF_000001405.40_GRCh38.p14_genomic.fna',
  memory = 4000,
  indexSplit = TRUE)

#aanmaken van een .fna.fai voor IGV
indexFa("HS_ncbi_dataset/ncbi_dataset/data/GCF_000001405.40/GCF_000001405.40_GRCh38.p14_genomic.fna")

# RA monsters indexen
align.RA1 <- align(index = "ref_homo_sapiens/ref_homo_sapiens", readfile1 = "RA_data/SRR4785979_1_subset40k.fastq", readfile2 = "RA_data/SRR4785979_2_subset40k.fastq", output_file = "./BAM/RA1.BAM")
align.RA2 <- align(index = "ref_homo_sapiens/ref_homo_sapiens", readfile1 = "RA_data/SRR4785980_1_subset40k.fastq", readfile2 = "RA_data/SRR4785980_2_subset40k.fastq", output_file = "./BAM/RA2.BAM")
align.RA3 <- align(index = "ref_homo_sapiens/ref_homo_sapiens", readfile1 = "RA_data/SRR4785986_1_subset40k.fastq", readfile2 = "RA_data/SRR4785986_2_subset40k.fastq", output_file = "./BAM/RA3.BAM")
align.RA4 <- align(index = "ref_homo_sapiens/ref_homo_sapiens", readfile1 = "RA_data/SRR4785988_1_subset40k.fastq", readfile2 = "RA_data/SRR4785988_2_subset40k.fastq", output_file = "./BAM/RA4.BAM")

# control monsters indexen
align.cntr1 <- align(index = "ref_homo_sapiens/ref_homo_sapiens", readfile1 = "RA_data/SRR4785819_1_subset40k.fastq", readfile2 = "RA_data/SRR4785819_2_subset40k.fastq", output_file = "./BAM/cntr1.BAM")
align.cntr2 <- align(index = "ref_homo_sapiens/ref_homo_sapiens", readfile1 = "RA_data/SRR4785820_1_subset40k.fastq", readfile2 = "RA_data/SRR4785820_2_subset40k.fastq", output_file = "./BAM/cntr2.BAM")
align.cntr3 <- align(index = "ref_homo_sapiens/ref_homo_sapiens", readfile1 = "RA_data/SRR4785828_1_subset40k.fastq", readfile2 = "RA_data/SRR4785828_2_subset40k.fastq", output_file = "./BAM/cntr3.BAM")
align.cntr4 <- align(index = "ref_homo_sapiens/ref_homo_sapiens", readfile1 = "RA_data/SRR4785831_1_subset40k.fastq", readfile2 = "RA_data/SRR4785831_2_subset40k.fastq", output_file = "./BAM/cntr4.BAM")

# Bestandsnamen van de monsters
samples <- c('cntr1', 'cntr2', 'cntr3', 'cntr4', 'RA1', 'RA2', 'RA3', 'RA4')

# Voor elk monster: sorteer en indexeer de BAM-file
# Sorteer BAM-bestanden
lapply(samples, function(s) {
  sortBam(file = file.path("BAM", paste0(s, ".BAM")),
          destination = file.path("BAM", paste0(s, ".sorted")))
})

#.bai extension toevoegen
lapply(samples, function(s) {
  sorted_bam <- file.path("BAM", paste0(s, ".sorted.bam"))
  indexBam(sorted_bam)
})