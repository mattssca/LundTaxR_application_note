plot_radar = function(these_predictions = NULL, 
                      this_sample_id = NULL, 
                      these_samples_metadata = NULL,
                      draw_plot = TRUE, 
                      plot_type = "radar",
                      font_size = 5){
  
  desired_levels_5 <- c("Uro", "GU", "BaSq", "Mes", "ScNE")
  desired_levels_7 <- c("UroA", "UroB", "UroC")
  
  prediction_class_5 = as.data.frame(these_predictions$predictions_5classes) %>% 
    rownames_to_column("sample_id") %>% 
    rename(predicted_subtype = `these_predictions$predictions_5classes`) %>% 
    filter(sample_id %in% this_sample_id)
  
  prediction_scores = as.data.frame(these_predictions$subtype_scores) %>% 
    rownames_to_column("sample_id") %>% 
    filter(sample_id %in% this_sample_id)
  
  sample_data_5 = prediction_class_5 %>% 
    left_join(prediction_scores, by = "sample_id") %>% 
    select(sample_id, predicted_subtype, Uro, GU, BaSq, Mes, ScNE)
  
  long_data_5 = pivot_longer(sample_data_5, cols = Uro:ScNE, names_to = "subtype_score", values_to = "score")
  long_data_5$subtype_score <- factor(long_data_5$subtype_score, levels = desired_levels_5)
  
  if(draw_plot){
    if(plot_type != "radar"){
      class_5_plot = ggplot(long_data_5, aes(x = subtype_score, y = score, fill = subtype_score)) +
        scale_fill_manual(values = lund_colors$lund_colors) +
        geom_bar(stat = "identity") +
        xlab("Subtype") +
        ylab("Score") +
        ggtitle("Scores for Each Subtype") +
        theme_minimal()
    }else if(plot_type == "radar"){
      plot_data <- sample_data_5 %>%
        select(-sample_id) %>%
        rename(group = predicted_subtype)
      
      if(sample_data_5$predicted_subtype == "Uro"){
        prediction_class_7 = as.data.frame(these_predictions$predictions_7classes) %>% 
          rownames_to_column("sample_id") %>% 
          rename(predicted_subtype = `these_predictions$predictions_7classes`) %>% 
          filter(sample_id %in% this_sample_id)
        
        sample_data_7 = prediction_class_7 %>% 
          left_join(prediction_scores, by = "sample_id") %>% 
          select(sample_id, predicted_subtype, UroA, UroB, UroC)
        
        plot_data_7 <- sample_data_7 %>%
          select(-sample_id) %>%
          rename(group = predicted_subtype)
        
        plot_data <- full_join(plot_data, plot_data_7, by = "group")
        
        plot_data[is.na(plot_data)] <- 0
        
        radar_plot = ggradar(plot_data, 
                             values.radar = c("", "", ""),
                             grid.min = 0, 
                             grid.mid = 0.5, 
                             grid.max = 1, 
                             grid.label.size = font_size * 1.5,
                             axis.label.size = font_size, 
                             axis.line.colour = "black", 
                             grid.line.width = 0.1, 
                             gridline.max.linetype = 1,
                             group.line.width = 0.2, 
                             group.point.size = 0.3, 
                             background.circle.colour = "white", 
                             gridline.mid.colour = "black", 
                             gridline.min.colour = "black", 
                             gridline.max.colour = "black", 
                             group.colours = c(lund_colors$lund_colors[sample_data_5$predicted_subtype[1]], lund_colors$lund_colors[sample_data_7$predicted_subtype[1]]), 
                             fill = TRUE,
                             legend.position = "none",
                             fill.alpha = 0.8) +
          ggtitle(paste(sample_data_5$sample_id[1])) +
          theme(plot.title = element_text(hjust = 0.5, size = font_size * 2))
        
        radar_plot$layers[[8]]$aes_params$linewidth <- 0.3
        
      }else{
        radar_plot = ggradar(plot_data, 
                             values.radar = c("", "", ""),
                             grid.min = 0, 
                             grid.mid = 0.5, 
                             grid.max = 1, 
                             grid.label.size = font_size * 1.5,
                             axis.label.size = font_size, 
                             axis.line.colour = "black", 
                             grid.line.width = 0.1, 
                             gridline.max.linetype = 1,
                             group.line.width = 0.2, 
                             group.point.size = 0.3, 
                             background.circle.colour = "white", 
                             gridline.mid.colour = "black", 
                             gridline.min.colour = "black", 
                             gridline.max.colour = "black", 
                             group.colours = lund_colors$lund_colors[sample_data_5$predicted_subtype[1]], 
                             fill = TRUE,
                             legend.position = "none",
                             fill.alpha = 0.8) +
          ggtitle(paste(sample_data_5$sample_id[1])) +
          theme(plot.title = element_text(hjust = 0.5, size = font_size * 2))
        
        radar_plot$layers[[8]]$aes_params$linewidth <- 0.3
        
      }
    }else{
      stop("Not a valid plot option...")
    }
  }
  return(radar_plot)
}