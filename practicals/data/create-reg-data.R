data <- readRDS(file = here::here("practicals", "data/GRF_dataset_PRO_meta.rds"))
data <- as.data.table(data)
data <- data[side == "left" & TRIAL_ID == 1 & TRAIN_BALANCED ==1 & component == "anterior_posterior"]
set.seed(123)
sample_inds <- sample(seq_len(nrow(data)), size = 30)
data <- data[sample_inds,]
Y <- t(as.matrix(data[, `time_0`:`time_100`]))
t <- 0:100
y_fd <- Data2fd(argvals = t, y = Y, 
                basisobj = create.bspline.basis(rangeval = c(0,100), nbasis = 50, norder = 4))
data[, paste0("time_", 0:100) := NULL]
info_df <- data

saveRDS(object = list(y_fd = y_fd,
                      info_df = info_df), 
        file = here::here("practicals", "data/reg-data.rds"))
