# Casus Transcriptomics van personen met Reumatoïde artritis
---
## Inleiding

Reumatoïde artritis (RA) is een chronische auto-immuunziekte die wordt gekenmerkt door aanhoudende ontsteking van de gewrichten, wat kan leiden tot pijn, functieverlies en gewrichtsschade. De ziekte wordt gekenmerkt door een ontregelde immuunrespons. Hoewel de precieze oorzaak van RA nog niet volledig bekend is, is het duidelijk dat genetische en omgevingsfactoren bijdragen aan het ontstaan van de ziekte (McInnes & Schett, 2011).

In dit project worden RNA-seq datasets van 4 RA-patiënten en 4 gezonde controles geanalyseerd met behulp van een differentiële expressieanalyse, KEGG analyse en een GO enrichment op gealignde en gesorteerde samples. Door deze analyses kunnen genen geïdentificeerd worden die significant anders tot expressie komen bij RA, wat inzicht geeft in ziekte-geassocieerde processen en kan bijdragen aan de ontwikkeling van gerichte therapieën (Smolen et al., 2016).

Hier zijn de volgende onderzoeksvragen bij opgesteld.
*  Welke genen hebben een significant verschil in expressie bij mensen met Reuma?
* Bij welke biologische processen zijn deze genen betrokken? 
* welke pathways worden beinvloed door de verschillen in expressie
---
## Methode
De RNA-seq data-analyse werd uitgevoerd op monsters van vier personen met reuma en vier gezonde personen in R versie 4.4.0. Er is een referentie-index gebouwd met als referentie het GRCh38.p14 genoom van Homo sapiens verkregen via NCBI. Hierbij werd gebruikgemaakt van het buildindex()-commando uit het Rsubread-pakket (Liao et al., 2019). De ruwe FASTQ-bestanden werden gealigned met behulp van de align() functie, ook uit Rsubread. De resulterende BAM-bestanden werden gesorteerd en geïndexeerd met het Rsamtools-pakket (Morgan et al., 2023).

Vervolgens werd een count-matrix gegenereerd op basis van een bijbehorend GTF-bestand verkregen via Ensembl. De differentiële expressieanalyse werd uitgevoerd met het DESeq2-pakket (Love et al., 2014). Genen met een aangepaste p-waarde kleiner dan 0.05 werden beschouwd als significant.

Voor de gene ontology (GO) verrijking werd goseq (Young et al., 2010) gebruikt, in combinatie met de annotatiepakketten org.Hs.eg.db en GO.db, om biologische processen (BP) van de differentieel tot expressie komende genexpressie te identificeren. Significante termen werden gevisualiseerd met ggplot2

Tot slot werd pathway-analyse uitgevoerd met pathview (Luo & Brouwer, 2013), gericht op de KEGG-pathway “Toll-like receptor signaling” (hsa04610), die is bepaald met de GO resultaten.




---
## conclusie
de GO enrichment liet een duidelijke oververtegenwoordiging zien van immuun-gerelateerde processen zoals immuunrespons, leukocytenactivatie en adaptieve immuniteit. Deze bevindingen onderstrepen de centrale rol van het immuunsysteem bij RA en vormen een basis voor verdere exploratie van betrokken pathways via KEGG-analyse.

