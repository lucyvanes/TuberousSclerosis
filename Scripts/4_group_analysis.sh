#!/bin/bash

module load mrtrix/3.0.2

cd /data/template


# make sure to include intercept

# Group comparison
#====================
fixelcfestats fd_smooth/ input_group_comparison.txt design_group_comparison.txt contrasts_group_comparison.txt matrix/ results/group_comparison/stats_fd/
fixelcfestats log_fc_smooth/ input_group_comparison.txt design_group_comparison.txt contrasts_group_comparison.txt matrix/ results/group_comparison/stats_log_fc/
fixelcfestats fdc_smooth/ input_group_comparison.txt design_group_comparison.txt contrasts_group_comparison.txt matrix/ results/group_comparison/stats_fdc/


