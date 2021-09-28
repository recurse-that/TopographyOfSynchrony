kable_maker <- function(scene_index, scene_names, 
                        pearson_results, spearman_results) {
  table_png = paste(results_path,scene_names[scene_index],"tbl.png",sep='/')
  
  P_p_vals <- c(pearson_results$elev_pearson_P[scene_index],
              pearson_results$esd_pearson_P[scene_index],
              pearson_results$mxvi_pearson_P[scene_index],
              pearson_results$msd_pearson_P[scene_index])
  P_p_vals <- round(P_p_vals, digits = 4)
  
  P_corr_vals <- c(pearson_results$elev_pearson_corr[scene_index],
                pearson_results$esd_pearson_corr[scene_index],
                pearson_results$mxvi_pearson_corr[scene_index],
                pearson_results$msd_pearson_corr[scene_index])
  P_corr_vals <- round(P_corr_vals, digits = 4)
  
  S_p_vals <- c(spearman_results$elev_spearman_P[scene_index],
              spearman_results$esd_spearman_P[scene_index],
              spearman_results$mxvi_spearman_P[scene_index],
              spearman_results$msd_spearman_P[scene_index])
  S_p_vals <- round(S_p_vals, digits = 4)
  
  S_corr_vals <- c(spearman_results$elev_spearman_corr[scene_index],
                 spearman_results$esd_spearman_corr[scene_index],
                 spearman_results$mxvi_spearman_corr[scene_index],
                 spearman_results$msd_spearman_corr[scene_index])
  S_corr_vals <- round(S_corr_vals, digits = 4)
  
  df <- data.frame(PP <- P_p_vals,
                   PR <- P_corr_vals,
                   SP <- S_p_vals,
                   SR <- S_corr_vals)
  
  rownames(df) <- c("Elevation", "Elevation SD", "MXVI", "MXVI SD")
  colnames(df) <- c('P', 'R', 'P', 'R')
  
  
  kbl(df)
  
  # < 0.05 p vals
  
  
  df %>%
    kbl(caption = scene_names[scene_index], booktabs = T) %>%
    kable_paper("striped", full_width = F) %>%
    kable_classic(full_width = F) %>%
    add_header_above(c(" " = 1, "Pearson" = 2, "Spearman" = 2)) %>%
    column_spec(1, color = "black", background="#bfbfbf") %>%
    column_spec(2, color = ifelse(P_p_vals[1:4] < 0.05, "white", "black"),
                background = ifelse(P_p_vals[1:4] < 0.05, "green", "white")) %>%
    column_spec(3, color = ifelse(P_p_vals < 0.05, "white", "black"),
                background = ifelse(P_p_vals < 0.05, ifelse(P_corr_vals<0, "red", "blue"), "white")) %>%
    column_spec(4, color = ifelse(S_p_vals[1:4] < 0.05, "white", "black"),
                background = ifelse(S_p_vals[1:4] < 0.05, "green", "white")) %>%
    column_spec(5, color = ifelse(S_p_vals < 0.05, "white", "black"), 
                  background = ifelse(S_p_vals < 0.05, ifelse(S_corr_vals<0, "red", "blue"), "white")) %>%
    save_kable(file = table_png, zoom=1.5)
  
  webshot(table_png)
}  # end function 

