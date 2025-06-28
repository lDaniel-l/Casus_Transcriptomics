#matrix

library(readr)
library(dplyr)
library(Rsamtools)
library(Rsubread)

# Inlezen en filteren van gtf bestand
gff <- read_tsv(
  "Homo_sapiens_gff3/Homo_sapiens.GRCh38.114.chr.gff3",
  comment = "#", col_names = FALSE)
colnames(gff) <- c("seqid", "source", "type", "start", "end", "score", "strand", "phase", "attributes")
gff_gene <- gff %>% filter(type == "gene")
gff_gene$type <- "exon"
bam_chr <- names(scanBamHeader("./BAM/cntr1.BAM")[[1]]$targets)[1]
gff_gene$seqid <- bam_chr
#opslaan als ready GTF
write_delim(gff_gene, "./Homo_sapiens_gff3/HS__featureCounts_ready.gtf", delim = "\t", col_names = FALSE)

# Je definieert een vector met namen van BAM-bestanden. Elke BAM bevat reads van een RNA-seq-experiment (bijv. behandeld vs. controle).
samples <- c('cntr1', 'cntr2', 'cntr3', 'cntr4', 'RA1', 'RA2', 'RA3', 'RA4')
allsamples <- file.path("BAM", paste0(samples, ".bam"))

count_matrix <- featureCounts(
  files = allsamples,
  annot.ext = "Homo_sapiens_gff3/HS__featureCounts_ready.gtf",
  isPairedEnd = TRUE,
  isGTFAnnotationFile = TRUE,
  GTF.attrType = "gene_id",
  useMetaFeatures = FALSE
)

head(count_matrix$annotation)
head(count_matrix$counts)
str(count_matrix)

# Haal alleen de matrix met tellingen eruit
counts <- count_matrix$counts
colnames(counts) <- c( "control1", "control2", "control3", "control4", "RA1", "RA2", "RA3", "RA4")

#bestand opslaan als csv
write.csv(counts, "countmatrix_HS.csv")
