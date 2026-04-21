#load packages
library(dplyr)
library(ggplot2)
library(tibble)
library(LundTaXR)

#load prediction calls
load("out/prediction_calls/pred_uc_genome.Rdata")
load("out/prediction_calls/pred_tcga.Rdata")
load("out/prediction_calls/pred_leeds.Rdata")

#source function
sourece("R/fun_create_delta_boxplot.R")

#set subtype order
subtype_order_5 <- c("Uro", "GU", "BaSq", "Mes", "ScNE")
subtype_order_7 <- c("UroA", "UroB", "UroC")

#set subtype colors
subtype_colors <- c(
  "Uro" = "#3cb44b",
  "GU" = "#4363d8",
  "BaSq" = "#CD2626",
  "Mes-like" = "#f58231",
  "ScNE-like" = "#A020F0",
  "UroA" = "#3cb44b",
  "UroB" = "#8B1A1A",
  "UroC" = "#006400"
)

#draw plots
create_delta_boxplot(
  prediction_object = pred_uc_genome,
  subtype_order_5 = subtype_order_5,
  subtype_order_7 = subtype_order_7,
  subtype_colors = subtype_colors,
  plot_title = "UC Genome",
  output_file = "out/delta_plots/delta_boxplot_UC_Genome.pdf"
)

create_delta_boxplot(
  prediction_object = pred_tcga,
  subtype_order_5 = subtype_order_5,
  subtype_order_7 = subtype_order_7,
  subtype_colors = subtype_colors,
  plot_title = "TCGA",
  output_file = "out/delta_plots/delta_boxplot_TCGA.pdf"
)

create_delta_boxplot(
  prediction_object = pred_leeds,
  subtype_order_5 = subtype_order_5,
  subtype_order_7 = subtype_order_7,
  subtype_colors = subtype_colors,
  plot_title = "Leeds",
  output_file = "out/delta_plots/delta_boxplot_Leeds.pdf"
)
