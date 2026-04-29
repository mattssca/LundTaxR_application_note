combine_radar_plots <- function(sample_ids, file_name) {
  cairo_pdf(file = file_name, width = 8, height = 3, family = "Arial")
  plots <- lapply(sample_ids, function(sample_id) {
    plot_radar(  # Generate the plot
      these_predictions = pred_tcga,
      draw_plot = TRUE,
      font_size = 2,
      plot_type = "radar",
      this_sample_id = sample_id
    )
  })
  grid.arrange(grobs = plots, ncol = 5, nrow = 1)  # Arrange plots in a grid (2 columns, 3 rows)
  dev.off()  # Close the PDF device
}
