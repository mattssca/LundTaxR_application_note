#load required libraries
library(dplyr)
library(ggplot2)
library(tibble)
library(LundTaxR)

#configuration
n_lowest_deltas <- 50
base_font_size <- 12

# Load prediction calls and library size data
load("out/prediction_calls/pred_tcga.Rdata")
load("data/TCGA_LibrarySizes.Rdata")
tcga_lib_size <- as.data.frame(TCGA_LibrarySizes)

#extract the prediction deltas and convert to a data frame
prediction_deltas <- pred_tcga$subtype_scores[, "prediction_delta_collapsed"]
prediction_deltas_df <- as.data.frame(prediction_deltas)
prediction_deltas_df$SampleID <- rownames(prediction_deltas_df)

#add a Rank column based on the collapsed prediction delta
prediction_deltas_df$Rank <- rank(-prediction_deltas_df$prediction_deltas, ties.method = "first")

# Sort the data frame by rank
prediction_deltas_df <- prediction_deltas_df[order(prediction_deltas_df$Rank), ]

#identify the lowest N deltas
lowest_deltas <- prediction_deltas_df %>%
  arrange(prediction_deltas) %>%
  slice(1:n_lowest_deltas)
lowest_deltas$Highlight <- "Lowest Deltas"

#add a Highlight column to the full data frame
prediction_deltas_df$Highlight <- ifelse(prediction_deltas_df$Rank > (nrow(prediction_deltas_df) - n_lowest_deltas), "Lowest Deltas", "Other")

#print the highest delta value in the low-delta group
highest_low_delta <- max(lowest_deltas$prediction_deltas)
print(paste("Highest delta in the low-delta group:", highest_low_delta))

#prepare library sizes data
library_sizes_df <- tcga_lib_size
library_sizes_df$SampleID <- rownames(library_sizes_df)
library_sizes_df$Rank <- rank(-library_sizes_df$TCGA_LibrarySizes, ties.method = "first")

#merge the lowest deltas with the library sizes
merged_data <- merge(library_sizes_df, lowest_deltas, by = "SampleID", all.x = TRUE)
merged_data$Highlight <- ifelse(!is.na(merged_data$prediction_deltas), "Lowest Deltas", "Other")

# Define the cutoff value for the lowest deltas
cutoff_value <- max(lowest_deltas$prediction_deltas)

#shared theme
shared_theme <- theme_minimal(base_size = base_font_size) +
  theme(
    axis.text.x = element_text(color = "black"),
    axis.text.y = element_text(color = "black"),
    panel.border = element_rect(color = "black", fill = NA, linewidth = 0.3),
    panel.background = element_rect(fill = "white", color = NA),
    panel.grid.major = element_line(color = "grey85", linewidth = 0.2),
    panel.grid.minor = element_line(color = "grey85", linewidth = 0.2)
  )

# Create the rank plot
rank_plot <- ggplot(prediction_deltas_df, aes(x = Rank, y = prediction_deltas)) +
  annotate("rect", xmin = -Inf, xmax = Inf, ymin = cutoff_value, ymax = Inf, fill = "#BFC9D1", alpha = 0.5) + 
  annotate("rect", xmin = -Inf, xmax = Inf, ymin = -Inf, ymax = cutoff_value, fill = "#FF9B51", alpha = 0.5) +  
  geom_hline(yintercept = cutoff_value, linetype = "dashed", color = "black", linewidth = 0.3) +
  geom_smooth(color = "#454040", linewidth = 0.5, se = FALSE, method = "loess") +
  annotate("text", x = max(prediction_deltas_df$Rank) * 0.5, y = cutoff_value + 0.05, label = "High Delta Group", color = "#454040", size = base_font_size / .pt, hjust = 0.5) +
  annotate("text", x = max(prediction_deltas_df$Rank) * 0.5, y = cutoff_value - 0.05, label = "Low Delta Group", color = "#454040", size = base_font_size / .pt, hjust = 0.5) +
  labs(
    title = "Rank Plot of Prediction Deltas (TCGA)",
    x = "",
    y = "Prediction Delta"
  ) +
  scale_x_continuous(expand = c(0, 0), limits = c(0, max(prediction_deltas_df$Rank))) +
  scale_y_continuous(expand = c(0, 0), limits = c(0, max(prediction_deltas_df$prediction_deltas))) +
  shared_theme

print(rank_plot)

library_size_plot <- ggplot(merged_data, aes(x = Rank.x, y = TCGA_LibrarySizes)) +
  geom_smooth(color = "#454040", linewidth = 0.5, se = FALSE, method = "loess") +
  geom_point(data = merged_data %>% filter(Highlight == "Lowest Deltas"),
             fill = "#FF9B51", color = "black", size = 5, shape = 21) +
  labs(
    title = "Library Size (TCGA) Rank Plot with Lowest Prediction Deltas",
    x = "Rank",
    y = "Library Size"
  ) +
  scale_x_continuous(expand = c(0, 0)) +
  scale_y_continuous(expand = c(0, 0)) +
  shared_theme

print(library_size_plot)

#export plots
ggsave("rank_plot_prediction_deltas.pdf", plot = rank_plot, device = cairo_pdf, family = "Arial", path = "out/rank_plots", width = 6, height = 4)
ggsave("library_size_rank_plot.pdf", plot = library_size_plot, device = cairo_pdf, family = "Arial", path = "out/rank_plots", width = 6, height = 4)
