#load packages
library(dplyr)
library(ggplot2)
library(tibble)
library(LundTaXR)

#load expression data
load("data/uc_genome_tpm.Rdata")
load("data/tcga_salmon_getpm.Rdata")
load("data/leeds_rma.Rdata")

#load prediction calls
load("out/prediction_calls/pred_uc_genome.Rdata")
load("out/prediction_calls/pred_tcga.Rdata")
load("out/prediction_calls/pred_leeds.Rdata")

devtools::load_all('../../LBCG/LundTaxR/')

#construct metadata
meta_uc_genome = as.data.frame(colnames(uc_genome_tpm)) %>% 
  rename(sample_id = `colnames(uc_genome_tpm)`) %>% 
  mutate(Dataset = "UC Genome")

meta_tcga = as.data.frame(colnames(tcga_salmon_getpm)) %>% 
  rename(sample_id = `colnames(tcga_salmon_getpm)`) %>% 
  mutate(Dataset = "TCGA")

meta_leeds = as.data.frame(colnames(leeds_rma)) %>% 
  rename(sample_id = `colnames(leeds_rma)`) %>% 
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
LundTaxR::plot_classification_heatmap(these_predictions = pred_uc_genome, 
                                      this_data = uc_genome_tpm, 
                                      custom_annotation = uc_genome_annotations,
                                      subtype_annotation = "7_class", 
                                      plot_scores = TRUE, 
                                      plot_signature_scores = TRUE, 
                                      show_ann_legend = TRUE, 
                                      show_hm_legend = TRUE,
                                      ann_height = 6,
                                      plot_height = 11,
                                      col_width = 0.5,
                                      plot_title = "UC Genome", 
                                      out_path = "out/classification_heatmaps/", 
                                      out_format = "pdf")

LundTaxR::plot_classification_heatmap(these_predictions = pred_tcga, 
                                      this_data = tcga_salmon_getpm, 
                                      custom_annotation = tcga_annotations,
                                      subtype_annotation = "7_class", 
                                      plot_scores = TRUE, 
                                      plot_signature_scores = TRUE, 
                                      ann_height = 6,
                                      plot_height = 11,
                                      col_width = 0.5,
                                      plot_title = "TCGA", 
                                      out_path = "out/classification_heatmaps/", 
                                      out_format = "pdf")

LundTaxR::plot_classification_heatmap(these_predictions = pred_leeds, 
                                      this_data = leeds_rma, 
                                      custom_annotation = leeds_annotations,
                                      subtype_annotation = "7_class", 
                                      plot_scores = TRUE, 
                                      plot_signature_scores = TRUE, 
                                      ann_height = 6, 
                                      plot_height = 11,
                                      col_width = 0.5,
                                      plot_title = "Leeds", 
                                      out_path = "out/classification_heatmaps/", 
                                      out_format = "pdf")
