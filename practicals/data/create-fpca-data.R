library(data.table) # CRAN v1.14.2
library(fda)        # CRAN v5.5.1

data_path <- here::here("practicals", "data", "interpolated-data.rds")
interpolated_data <- readRDS(data_path)
GRF_dataset_PRO_meta <- interpolated_data$GRF_dataset_PRO_meta
bspl_35 <- interpolated_data$bspl_35
GRF_dataset_PRO_meta[, uniqueN(SESSION_ID), by = SUBJECT_ID][, stopifnot(V1 == 1)]
GRF_dataset_PRO_meta[, paste0("time_",0:100) := NULL]
GRF_dataset_PRO_averages <- GRF_dataset_PRO_meta[,
                                                 as.list(apply(.SD, 2, mean)), # average basis coefficients of all trials
                                                 by = .(SUBJECT_ID, SESSION_ID, side, component, CLASS_LABEL, CLASS_LABEL_DETAILED, SEX, AGE, HEIGHT, 
                                                        BODY_WEIGHT, BODY_MASS, SHOE_SIZE, AFFECTED_SIDE, SHOD_CONDITION, # defines averaging
                                                        ORTHOPEDIC_INSOLE, SPEED),
                                                 .SDcols = paste0("bspl4.",1:35)] # says which columns to average
averages_vertical <- GRF_dataset_PRO_averages[component == "vertical" & CLASS_LABEL == "HC" & side == "right"]
                    # create fd object defined by coefficients and basis object
fdobj_averages_vertical <- fd(coef = t(as.matrix(averages_vertical[, paste0("bspl4.",1:35)])),
                              basisobj = bspl_35)

averages_anterior_posterior <- GRF_dataset_PRO_averages[component == "anterior_posterior"  & CLASS_LABEL == "HC" & side == "right"]
                    # create fd object defined by coefficients and basis object
fdobj_averages_anterior_posterior <- fd(coef = t(as.matrix(averages_anterior_posterior[, paste0("bspl4.",1:35)])),
                                        basisobj = bspl_35)

max_anterior_posterior <- apply(eval.fd(0:100, fdobj_averages_anterior_posterior), 2, max)


saveRDS(object = list(grf_fd = fdobj_averages_vertical, max_ap = max_anterior_posterior), 
        file = here::here("practicals", "fpca-data.rds"))
  