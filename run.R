#!/usr/local/bin/Rscript

task <- dyncli::main()

# load libraries
library(dyncli, warn.conflicts = FALSE)
library(dynwrap, warn.conflicts = FALSE)
library(dplyr, warn.conflicts = FALSE)
library(purrr, warn.conflicts = FALSE)

#####################################
###           LOAD DATA           ###
#####################################
expression <- task$expression
params <- task$params
priors <- task$priors

# TIMING: done with preproc
timings <- list(method_afterpreproc = Sys.time())

#####################################
###        INFER TRAJECTORY       ###
#####################################

num_milestones <- 15

# generate network
milestone_ids <- paste0("milestone_", seq_len(num_milestones))

gr <- igraph::ba.game(num_milestones)
milestone_network <-
  igraph::as_data_frame(gr) %>%
  mutate(
    from = paste0("milestone_", from),
    to = paste0("milestone_", to),
    length = 1,
    directed = FALSE
  )

# put cells on random edges of network
cell_ids <- rownames(expression)

progressions <- data.frame(
  cell_id = cell_ids,
  milestone_network[sample.int(nrow(milestone_network), length(cell_ids), replace = TRUE), 1:2],
  percentage = runif(length(cell_ids)),
  stringsAsFactors = FALSE
)

# TIMING: done with trajectory inference
timings$method_aftermethod <- Sys.time()

#####################################
###     SAVE OUTPUT TRAJECTORY    ###
#####################################
output <-
  wrap_data(
    cell_ids = rownames(expression)
  ) %>%
  add_trajectory(
    milestone_ids = milestone_ids,
    milestone_network = milestone_network,
    progressions = progressions,
    divergence_regions = NULL
  ) %>%
  add_timings(
    timings = timings
  )

dyncli::write_output(output, task$output)
