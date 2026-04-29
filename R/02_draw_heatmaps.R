#load packages
library(dplyr)
library(ggplot2)
library(tibble)
library(LundTaXR)

#load prediction calls
load("out/prediction_calls/pred_uc_genome.Rdata")
load("out/prediction_calls/pred_tcga.Rdata")
load("out/prediction_calls/pred_leeds.Rdata")

#load LundTaxR
source("R/fun_plot_classification_heatmap.R")

#construct metadata
meta_uc_genome = as.data.frame(colnames(pred_uc_genome$data)) %>% 
  rename(sample_id = `colnames(pred_uc_genome$data)`) %>% 
  mutate(Dataset = "UC Genome")

meta_tcga = as.data.frame(colnames(pred_tcga$data)) %>% 
  rename(sample_id = `colnames(pred_tcga$data)`) %>% 
  mutate(Dataset = "TCGA")

meta_leeds = as.data.frame(colnames(pred_leeds$data)) %>% 
  rename(sample_id = `colnames(pred_leeds$data)`) %>% 
  mutate(Dataset = "Leeds")

#create dataset annotations
uc_genome_annotations = LundTaxR::get_custom_annotations(metadata = meta_uc_genome, 
                                                         annotation_vars = "Dataset", 
                                                         annotation_height = 4, 
                                                         custom_colors = list(Dataset = c("UC Genome" = "#F26076")))

tcga_annotations = LundTaxR::get_custom_annotations(metadata = meta_tcga, 
                                                    annotation_vars = "Dataset", 
                                                    annotation_height = 4, 
                                                    custom_colors = list(Dataset = c("TCGA" = "#458B73")))

leeds_annotations = LundTaxR::get_custom_annotations(metadata = meta_leeds, 
                                                     annotation_vars = "Dataset", 
                                                     annotation_height = 4, 
                                                     custom_colors = list(Dataset = c("Leeds" = "#5A7ACD")))
  
#draw heatmaps
plot_classification_heatmap(these_predictions = pred_uc_genome, 
                                      custom_annotation = uc_genome_annotations,
                                      subtype_annotation = "7_class", 
                                      plot_scores = TRUE, 
                                      plot_signature_scores = TRUE, 
                                      show_ann_legend = TRUE, 
                                      show_hm_legend = TRUE,
                                      row_height = 3,
                                      ann_height = 5,
                                      plot_height = 14,
                                      col_width = 0.5,
                                      plot_title = "UC Genome", 
                                      out_path = "out/classification_heatmaps/", 
                                      out_format = "pdf")

plot_classification_heatmap(these_predictions = pred_tcga, 
                                      custom_annotation = tcga_annotations,
                                      subtype_annotation = "7_class", 
                                      plot_scores = TRUE, 
                                      plot_signature_scores = TRUE, 
                                      row_height = 3,
                                      ann_height = 5,
                                      plot_height = 14,
                                      col_width = 0.5,
                                      plot_title = "TCGA", 
                                      out_path = "out/classification_heatmaps/", 
                                      out_format = "pdf")

plot_classification_heatmap(these_predictions = pred_leeds, 
                                      custom_annotation = leeds_annotations,
                                      subtype_annotation = "7_class", 
                                      plot_scores = TRUE, 
                                      plot_signature_scores = TRUE, 
                                      row_height = 3,
                                      ann_height = 5,
                                      plot_height = 14,
                                      col_width = 0.5,
                                      plot_title = "Leeds", 
                                      out_path = "out/classification_heatmaps/", 
                                      out_format = "pdf")
