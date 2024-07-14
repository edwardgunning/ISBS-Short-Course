library(data.table)
library(fda)
data_path <- here::here("practicals", "data", "interpolated-data.rds")
interpolated_data <- readRDS(data_path)
GRF_dataset_PRO_meta <- interpolated_data$GRF_dataset_PRO_meta
bspl_35 <- interpolated_data$bspl_35
GRF_dataset_PRO_meta[, uniqueN(SESSION_ID), by = SUBJECT_ID][, stopifnot(V1 == 1)]

# remove discrete values from dataset now we just working with basis coefficients.
GRF_dataset_PRO_meta[, paste0("time_",0:100) := NULL]
GRF_dataset_PRO_averages <- GRF_dataset_PRO_meta[,
                                                 as.list(apply(.SD, 2, mean)), # average basis coefficients of all trials
                                                 by = .(SUBJECT_ID, SESSION_ID, side, component, CLASS_LABEL, CLASS_LABEL_DETAILED, SEX, AGE, HEIGHT, 
                                                        BODY_WEIGHT, BODY_MASS, SHOE_SIZE, AFFECTED_SIDE, SHOD_CONDITION, # defines averaging
                                                        ORTHOPEDIC_INSOLE, SPEED),
                                                 .SDcols = paste0("bspl4.",1:35)] # says which columns to average


dt <- GRF_dataset_PRO_averages[component == "anterior_posterior"]
dt <- dt[(CLASS_LABEL == "HC" & side == "right") |
           (AFFECTED_SIDE == 0 & side == "left") |
           (AFFECTED_SIDE == 1 & side == "right") |
           (AFFECTED_SIDE == 2 & side == "right")]


fdobj <- fd(coef = t(as.matrix(dt[, paste0("bspl4.",1:35)])), # basis coefs
            basisobj = bspl_35) # basis

dt[, CLASS_LABEL := factor(
  CLASS_LABEL,
  levels = c("HC", "A", "K", "H", "C"),
  labels = c("Healthy Control", "Ankle", "Knee", "Hip", "Calcaneous"))]

class_label <- dt[, CLASS_LABEL]

saveRDS(object = list(ap_fd = fdobj, class_label = class_label), 
        file = here::here("practicals", "fosr-data.rds"))
