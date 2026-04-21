#load packages
library(dplyr)
library(ggplot2)
library(tibble)
library(LundTaXR)

#load data
load("data/uc_genome_tpm.Rdata")
load("data/tcga_salmon_getpm.Rdata")
load("data/leeds_rma.Rdata")

#apply log2 transformation where applicable
tcga_salmon_getpm <- log2(tcga_salmon_getpm + 1)
uc_genome_tpm <- log2(uc_genome_tpm + 1)

#run LundTaxR `classify_samples`
pred_uc_genome = classify_samples(this_data = uc_genome_tpm, log_transform = FALSE, include_data = FALSE)
pred_tcga = classify_samples(this_data = tcga_salmon_getpm, log_transform = FALSE, include_data = FALSE)
pred_leeds = classify_samples(this_data = leeds_rma, log_transform = FALSE, include_data = FALSE)

#save data
save(pred_uc_genome, file = "out/prediction_calls/pred_uc_genome.Rdata")
save(pred_tcga, file = "out/prediction_calls/pred_tcga.Rdata")
save(pred_leeds, file = "out/prediction_calls/pred_leeds.Rdata")
