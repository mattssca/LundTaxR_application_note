#load packages
library(dplyr)
library(ggplot2)
library(tibble)
library(LundTaXR)

#load data
uc_geneome_expr = readRDS("data/UC_GENOME_byGene.Rds")
tcga_expr = readRDS("data/TCGA_BLCA_byGene.Rds")
leeds_expr = readRDS("data/Leeds_byGene.Rds")

#apply log2 transformation where applicable
uc_geneome_expr <- log2(uc_geneome_expr + 1)
tcga_expr <- log2(tcga_expr + 1)

#run LundTaxR `classify_samples`
pred_uc_genome = classify_samples(this_data = uc_geneome_expr, log_transform = FALSE, include_data = TRUE)
pred_tcga = classify_samples(this_data = tcga_expr, log_transform = FALSE, include_data = TRUE)
pred_leeds = classify_samples(this_data = leeds_expr, log_transform = FALSE, include_data = TRUE)

#save data
save(pred_uc_genome, file = "out/prediction_calls/pred_uc_genome.Rdata")
save(pred_tcga, file = "out/prediction_calls/pred_tcga.Rdata")
save(pred_leeds, file = "out/prediction_calls/pred_leeds.Rdata")
