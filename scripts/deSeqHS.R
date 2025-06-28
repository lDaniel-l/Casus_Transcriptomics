#deSeq

library(DESeq2)
library(KEGGREST)
library(EnhancedVolcano)
library(pathview)

counts <- read.csv("count_matrix_HS.csv", row.names = 1)

treatment <- c("Control", "Control", "Control", "Control", "Reuma", "Reuma", "Reuma", "Reuma")
treatment_table <- data.frame(treatment)
rownames(treatment_table) <- c('control1', 'control2', 'control3', 'control4', 'RA1', 'RA2', 'RA3', 'RA4')

# Maak DESeqDataSet aan
dds <- DESeqDataSetFromMatrix(countData = counts,
                              colData = treatment_table,
                              design = ~ treatment)

# Voer analyse uit
dds <- DESeq(dds)
resultaten <- results(dds)

# Resultaten opslaan in een bestand.
write.table(resultaten, file = 'dds_Resultaten.csv', row.names = TRUE, col.names = TRUE)

#hoeveel significante genen
sum(resultaten$padj < 0.05 & resultaten$log2FoldChange > 1, na.rm = TRUE)
sum(resultaten$padj < 0.05 & resultaten$log2FoldChange < -1, na.rm = TRUE)

#sorteer voor belangrijkste genen
hoogste_fold_change <- resultaten[order(resultaten$log2FoldChange, decreasing = TRUE), ]
laagste_fold_change <- resultaten[order(resultaten$log2FoldChange, decreasing = FALSE), ]
laagste_p_waarde <- resultaten[order(resultaten$padj, decreasing = FALSE), ]
head(hoogste_fold_change)
head(laagste_p_waarde)

#volcano plot
EnhancedVolcano(resultaten,
                lab = rownames(resultaten),
                x = 'log2FoldChange',
                y = 'padj')

# Alternatieve plot zonder p-waarde cutoff (alle genen zichtbaar)
EnhancedVolcano(resultaten,
                lab = rownames(resultaten),
                x = 'log2FoldChange',
                y = 'padj',
                pCutoff = 0)

#plot opslaan
dev.copy(png, 'VolcanoplotRA.png', 
         width = 8,
         height = 10,
         units = 'in',
         res = 500)
dev.off()

resultaten[1] <- NULL
resultaten[2:5] <- NULL

pathview(
  gene.data = resultaten,
  pathway.id = "hsa04610",  # KEGG ID voor Complement and coagulation cascades – H. sapiens
  species = "hsa",          # 'hsa' = H. sapiens in KEGG
  gene.idtype = "SYMBOL",     # Geef aan dat het KEGG-ID's zijn mis "symbol"
  limit = list(gene = 5)    # Kleurbereik voor log2FC van -5 tot +5
)
