create_delta_boxplot <- function(prediction_object, 
                                 subtype_order_5, 
                                 subtype_order_7, 
                                 subtype_colors, 
                                 plot_title, 
                                 output_file,
                                 width_mm = NULL,
                                 base_font_size = 7) {
  
  delta_5_class <- prediction_object$subtype_scores[, "prediction_delta_5_class"]
  delta_7_class <- prediction_object$subtype_scores[, "prediction_delta_7_class"]
  subtypes_5 <- prediction_object$predictions_5classes
  subtypes_7 <- prediction_object$predictions_7classes
  
  unified_subtype_order <- c(subtype_order_5, subtype_order_7)
  
  plot_data_5 <- data.frame(
    Delta = delta_5_class,
    Subtype = factor(subtypes_5, levels = unified_subtype_order),
    Class = "5 Class"
  )
  plot_data_7 <- data.frame(
    Delta = delta_7_class,
    Subtype = factor(subtypes_7, levels = unified_subtype_order),
    Class = "7 Class"
  )
  
  plot_data <- rbind(plot_data_5, plot_data_7)
  
  separator_position <- length(subtype_order_5) + 0.5
  
  label_size <- base_font_size / ggplot2::.pt
  
  names(subtype_colors) <- gsub("Mes-like", "Mes", names(subtype_colors))
  names(subtype_colors) <- gsub("ScNE-like", "ScNE", names(subtype_colors))
  
  plot <- ggplot2::ggplot(plot_data, ggplot2::aes(x = Subtype, y = Delta, fill = Subtype)) +
    ggplot2::geom_boxplot(width = 0.6, outlier.shape = NA, linewidth = 0.3, color = "black") +
    ggplot2::scale_fill_manual(values = subtype_colors, drop = FALSE) +
    ggplot2::scale_x_discrete(
      drop = FALSE,
      labels = c("Mes" = "Mes-like", "ScNE" = "ScNE-like")
    ) +
    ggplot2::geom_vline(xintercept = separator_position, linetype = "dotted", color = "black") +
    ggplot2::annotate("text", x = separator_position - 2.5,   y = 1.05, label = "5 Class", size = label_size, hjust = 0.5) +
    ggplot2::annotate("text", x = separator_position + 1.5, y = 1.05, label = "7 Class", size = label_size, hjust = 0.5) +
    ggplot2::labs(title = plot_title, x = "", y = "Delta Value") +
    ggplot2::scale_y_continuous(breaks = seq(0, 1, by = 0.2), limits = c(0, 1.1)) +
    ggplot2::theme_minimal(base_size = base_font_size) +
    ggplot2::theme(
      axis.text.x = ggplot2::element_text(angle = 90, hjust = 1, color = "black"),
      axis.text.y = ggplot2::element_text(color = "black"),
      legend.position = "none",
      panel.border = ggplot2::element_rect(color = "black", fill = NA, linewidth = 0.3),
      panel.background = ggplot2::element_rect(fill = "white", color = NA),
      panel.grid.major = ggplot2::element_line(color = "grey85", linewidth = 0.2),
      panel.grid.minor = ggplot2::element_line(color = "grey85", linewidth = 0.2)
    )
  num_boxes <- length(levels(plot_data$Subtype))
  plot_width_in <- if (!is.null(width_mm)) width_mm / 25.4 else num_boxes * 1.2
  
  ggplot2::ggsave(output_file, plot = plot, device = cairo_pdf, family = "Arial",
                  width = plot_width_in, height = 3)
  
  return(plot)
}