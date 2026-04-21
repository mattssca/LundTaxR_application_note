create_delta_boxplot <- function(prediction_object, 
                                 subtype_order_5, 
                                 subtype_order_7, 
                                 subtype_colors, 
                                 plot_title, 
                                 output_file){
  
  # Extract delta values and subtype predictions
  delta_5_class <- prediction_object$subtype_scores[, "prediction_delta_5_class"]
  delta_7_class <- prediction_object$subtype_scores[, "prediction_delta_7_class"]
  subtypes_5 <- prediction_object$predictions_5classes # Use the correct column for 5-class subtypes
  subtypes_7 <- prediction_object$predictions_7classes
  
  # Create a unified subtype order (all subtypes from both panels)
  unified_subtype_order <- c(subtype_order_5, subtype_order_7)
  
  # Create a data frame for plotting
  plot_data_5 <- data.frame(
    Delta = delta_5_class,
    Subtype = factor(subtypes_5, levels = unified_subtype_order), # Use unified subtype order
    Class = "5 Class"
  )
  plot_data_7 <- data.frame(
    Delta = delta_7_class,
    Subtype = factor(subtypes_7, levels = unified_subtype_order), # Use unified subtype order
    Class = "7 Class"
  )
  
  # Combine the two datasets
  plot_data <- rbind(plot_data_5, plot_data_7)
  
  # Rename Mes and ScNE for the plot
  levels(plot_data$Subtype)[levels(plot_data$Subtype) == "Mes"] <- "Mes-like"
  levels(plot_data$Subtype)[levels(plot_data$Subtype) == "ScNE"] <- "ScNE-like"
  
  # Determine the position of the vertical separator
  separator_position <- length(subtype_order_5) + 0.5
  
  # Create the box plot
  library(ggplot2)
  plot <- ggplot(plot_data, aes(x = Subtype, y = Delta, fill = Subtype)) +
    geom_boxplot(width = 0.6, outlier.shape = NA) +  # Set fixed box width
    scale_fill_manual(values = subtype_colors) +
    geom_vline(xintercept = separator_position, linetype = "dotted", color = "black") + # Add vertical separator
    annotate("text", x = separator_position - 2, y = 1.05, label = "5 Class", size = 5, hjust = 0.5) + # Add "5 Class" at the top
    annotate("text", x = separator_position + 1.5, y = 1.05, label = "7 Class", size = 5, hjust = 0.5) + # Add "7 Class" at the top
    labs(
      title = plot_title,
      x = "Subtype",
      y = "Delta Value"
    ) +
    scale_y_continuous(breaks = seq(0, 1, by = 0.2), limits = c(0, 1)) + # Set y-axis scale from 0 to 1
    theme_minimal() +
    theme(
      axis.text.x = element_text(angle = 0, hjust = 0.5), # Subtype labels not rotated
      legend.position = "none",
      panel.border = element_rect(color = "black", fill = NA, linewidth = 1) # Add black border
    )
  
  # Calculate the number of boxes and dynamic width
  num_boxes <- length(unique(plot_data$Subtype))
  width_per_box <- 1.2 # Scaling factor for width per box
  dynamic_width <- num_boxes * width_per_box
  
  # Export the plot as a high-resolution PDF
  ggsave(output_file, plot = plot, device = "pdf", width = dynamic_width, height = 6, dpi = 300)
  
  # Return the plot object (optional, for further use in R)
  return(plot)
}