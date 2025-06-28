#GO enrichment

library(BiocManager)
library(readr)
library(ggplot2)
library(goseq)
library(org.Hs.eg.db)
library(GO.db)
library(stringr)

resultaten <- read.csv("dds_Resultaten.csv", row.names = 1, sep = " ")

#lijst van significante genen
sig_genes <- rownames(resultaten)[resultaten$padj < 0.05 & !is.na(resultaten$padj)]
#lijst van alle genen
all_genes <- rownames(resultaten)
#vector van alle genen en significante genen
gene_vector <- as.integer(all_genes %in% sig_genes)
names(gene_vector) <- all_genes

pwf <- nullp(gene_vector, genome = "hg19", id = "geneSymbol")
GO_results <- goseq(pwf, genome = "hg19", id = "geneSymbol", test.cats = c("GO:BP"))

head(GO_results[GO_results$over_represented_pvalue < 0.05, ])

#significante genen en top 10 hiervan filteren
sig_GO <- GO_results[GO_results$over_represented_pvalue < 0.05, ]
top_GO <- head(sig_GO[order(sig_GO$over_represented_pvalue), ], 10)

top_GO$term <- factor(top_GO$term, levels = rev(top_GO$term))
top_GO$hit_percent <- top_GO$numDEInCat / top_GO$numInCat * 100
top_GO$wrapped_term <- str_wrap(top_GO$term, width = 40)

#GOseq dot plot
ggplot(top_GO, aes(x = hit_percent, y = reorder(wrapped_term, hit_percent))) +
  geom_point(aes(size = numDEInCat, color = -log10(over_represented_pvalue))) +
  scale_color_gradient(low = "skyblue", high = "darkblue") +
  labs(
    x = "Hits (%)",
    y = "GO term",
    color = "-log10(p-waarde)",
    size = "count"
  ) +
  theme_minimal()
