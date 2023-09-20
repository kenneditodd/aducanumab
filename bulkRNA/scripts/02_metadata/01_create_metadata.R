# Kennedi Todd
# September 15, 2023
# Merge sample info to create master metadata file

setwd(".")

mika.meta <- read.table("../../refs/mika_metadata.tsv", sep = "\t", header = TRUE)
colnames(mika.meta) <- c("mouse_id","week","treatment","sex","RIN")

core.meta <- read.table("../../refs/core_metadata.tsv", sep = "\t", header = TRUE)
colnames(core.meta)<- "filename"
core.meta$mouse_id <- str_match(core.meta$filename, "([0-9]+)_[AduIgG]+")[,2]
core.meta$mouse_id <- as.numeric(core.meta$mouse_id)

df <- dplyr::left_join(mika.meta, core.meta, by = "mouse_id")
df$sex <- gsub("Female","F",df$sex)
df$sex <- gsub("Male","M",df$sex)

df$sample <- paste(df$treatment, df$week, df$sex, df$mouse_id, sep = ".")

df <- df[,c(7,3,2,4,1,5,6)]

write.table(df, "../../refs/metadata.tsv", quote = FALSE, sep = "\t")

# display groups
table(paste(df$treatment, df$week, df$sex, sep = "."))
