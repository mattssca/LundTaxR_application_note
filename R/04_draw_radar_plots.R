#load required libraries
library(gridExtra)
library(dplyr)
library(ggplot2)
library(tibble)
library(LundTaxR)
library(ggradar)

#load prediction calls
load("out/prediction_calls/pred_tcga.Rdata")

#source required functions
source("R/fun_plot_radar.R")
source("R/fun_combine_radar_plots.R")

#define the color palette
lund_colors <- LundTaxR::lund_colors

#subset samples by subtype
samples <- as.data.frame(pred_tcga$predictions_7classes) %>%
  rename(subtype = `pred_tcga$predictions_7classes`)

#define subtypes and their corresponding indices for plotting
subtype_indices <- list(
  UroA = c(3, 2, 6, 53, 1),
  UroB = c(3, 2, 6, 53, 1),
  UroC = c(3, 1, 8, 9, 2),
  GU = c(3, 4, 7, 53, 20),
  BaSq = c(3, 2, 6, 53, 1),
  Mes = c(3, 2, 6, 9, 4),
  ScNE = c(3, 1, 10, 9, 4)
)

#iterate over subtypes and save radar plots
for (subtype in names(subtype_indices)) {
  subtype_samples <- samples %>% filter(subtype == !!subtype)
  sample_ids <- rownames(subtype_samples)[subtype_indices[[subtype]]]
  
  combine_radar_plots(
    sample_ids = sample_ids,
    file_name = paste0("out/radar_plots/radar_", subtype, ".pdf")
  )
}
