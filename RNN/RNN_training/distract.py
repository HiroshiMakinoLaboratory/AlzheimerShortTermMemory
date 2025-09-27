import FORCE
import numpy as np
import numpy.random as npr
import matplotlib.pyplot as plt
import os
from scipy.io import loadmat, savemat
import argparse
import pickle as pkl
import os

# Saved RNNs folder
savedir = 'data/RNNs'

items_in_logs = os.listdir(savedir)
items_in_logs.sort()
temp = []
for item in items_in_logs:
    if 'Control_RNN' in item:
        temp.append(item)

for drname in temp:
    if 'APP' in drname:
        d = 'APP'
    else:
        d = 'control'

    datadir = f'/data/{d}_data.mat'
    
    folder_name = os.path.join(savedir, drname)
    print(folder_name)

    rnn_dr = os.path.join(folder_name, 'RNN.pkl')

    # Only need to change these
    ###############################################
    matfiledir = os.path.join(folder_name, 'distractor_2_5_no_ablation')
    dist = 2.5 # Amplitude of distractor
    dist_std = 0.25
    stim_std = 0.1
    abl_prop = 0.2 # Percentage of units to ablate e.g. 0.05 = 5%
    dist_type = 'mid' # Distractor position
    dist_dur = 0.5 # Duration of distractor in s
    ###############################################
    
    if os.path.exists(matfiledir) is False:
        os.mkdir(matfiledir)

    p = FORCE.create_hyperparameters(datadir, folder_name)
    net = FORCE.RNN(p, folder_name)

    # For reproducibility of Figure 5. 
    net.distract(distractor_amp=dist,
                 distractor_std=dist_std,
                 stim_std=stim_std,
                 ablation_proportion=abl_prop,
                 number_of_ablation_trials=1, # Number of ablations.
                 number_of_distraction_trials=100,
                 savedir=matfiledir,
                 ablation_type = 'internal',
                 distractor_type=dist_type,
                 distractor_duration=dist_dur)
    
    # For reproducibility of Figure S5e.
    net.distract_individual_region(distractor_amp=dist,
                distractor_std=dist_std,
                stim_std=stim_std,
                ablation_proportion=abl_prop,# Percentage weights to decrease e.g. set as 0.1 or 0.2 for 10% or 20% ablation
                number_of_ablation_trials=1, # Number of ablations. default is 1.
                number_of_distraction_trials=100, # Number of distraction trials. default is 100.
                savedir=matfiledir,
                ablation_type = 'all',
                distractor_type=dist_type,
                distractor_duration=dist_dur)
      
