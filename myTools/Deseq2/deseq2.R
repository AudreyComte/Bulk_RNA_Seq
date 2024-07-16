# #################################################################
# 
#                               DESeq2
#                          
# #################################################################


# How to execute this tool
# $Rscript my_r_tool.R --input input.txt --output output.txt

# Send R errors to stderr
options(show.error.messages = FALSE, error = function() {
  cat(geterrmessage(), file = stderr())
  q("no", 1, FALSE)
})

# Avoid crashing Galaxy with a UTF8 error on German LC settings
loc <- Sys.setlocale("LC_MESSAGES", "en_US.UTF-8")

# Take in trailing command line arguments
args <- commandArgs(trailingOnly = TRUE)

# Function to get the value of an option from command line arguments
getOptionValue <- function(option) {
  idx <- match(option, args)
  if (!is.na(idx) && (idx + 1) <= length(args)) {
    return(args[idx + 1])
  }
  return(NULL)
}


# Get options
input <- getOptionValue("--galaxy_input")

output_1 <- getOptionValue("--galaxy_output1")
output_2 <- getOptionValue("--galaxy_output2")
output_2 <- getOptionValue("--galaxy_output2")

thread_param <- getOptionValue("--galaxy_param_thread")
param1_ref_level <- getOptionValue("--galaxy_param1")
param2_coldata <- getOptionValue("--galaxy_param2")
#param3_rmproj_list <- getOptionValue("--galaxy_param3")

# Print options to stderr for debugging
#cat("\n input: ", input_file)
#cat("\n output: ", output_file)


########################################################################################################################################################################################################################################################################################################################################################################################################


library(DESeq2)
library(readr)

parallel <- FALSE
if (thread_param > 1) {
    library("BiocParallel")
    setup parallelization
    register(MulticoreParam(thread_param))
    parallel <- TRUE
}

file_list <- strsplit(input, ",")[[1]]
ref_level <- param1_ref_level
normalized_counts_file <- output_1

for (i in 1:length(file_list)) {
  cts <- file_list[i]
  dds <- DESeqDataSetFromMatrix(countData = cts,
                              colData = param2_coldata,
                              design = ~ condition)

  sample_names_cts <- colnames(cts)
  sample_names_coldata <- rownames(param2_coldata)

  conditions <- unique(param2_coldata[sample_names_cts, "condition"])

  reference_1 <- conditions[1]
  reference_2 <- conditions[2]
  
  for (c in 1:2){
    dds$condition <- relevel(dds$condition, ref = reference_,c)
    dds <- DESeq(dds, parallel = parallel)
    all_rds = output_2
    saveRDS(dds, file = all_rds)
    dds <- estimateSizeFactors( dds)
    print(sizeFactors(dds))
    # Save the normalized data matrix
    normalized_counts <- counts(dds, normalized=TRUE)
    write.table(normalized_counts, file = normalized_counts_file, sep="\t", quote=F, col.names=NA)
  }
}

