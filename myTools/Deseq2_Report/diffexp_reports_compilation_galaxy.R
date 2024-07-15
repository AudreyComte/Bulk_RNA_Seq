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
input_file1 <- getOptionValue("--galaxy_input1")
output_file1 <- getOptionValue("--galaxy_output1")
output_file2 <- getOptionValue("--galaxy_output2")
output_file3 <- getOptionValue("--galaxy_output3")
output_file4 <- getOptionValue("--galaxy_output4")
param1 <- getOptionValue("--galaxy_param1")
param2 <- getOptionValue("--galaxy_param2")
param3 <- getOptionValue("--galaxy_param3")
param4 <- getOptionValue("--galaxy_param4")
param5 <- getOptionValue("--galaxy_param5")
param6 <- getOptionValue("--galaxy_param6")
param7 <- getOptionValue("--galaxy_param7")
param8 <- getOptionValue("--galaxy_param8")



# Print options to stderr for debugging
#cat("\n input: ", input_file)
#cat("\n output: ", output_file)


# ##########################################################################
# This script is used to launch the compilation of the RMarkdown report
# independently of Rstudio interface
# ##########################################################################


RDS = input_file1

rmarkdown::render( input = "/home/audrey/Documents/Bulk_RNAseq_analyses/galaxy/tools/myTools/Deseq2_Report/diffexp.Rmd",
                   output_format = "html_document",
                   output_file  = output_file1,
                   quiet = FALSE)
