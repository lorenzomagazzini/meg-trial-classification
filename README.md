# Trial classification: automatic detection of trials containing artefacts in MEG data

## meg-trial-classification

This repository is a project in collaboration between [dianadima](https://github.com/dianadima/) and [lorenzomagazzini](https://github.com/lorenzomagazzini/). The code was written for two purposes:

1. [Features extraction](https://github.com/lorenzomagazzini/meg-trial-classification/wiki/Features-extraction): extract informative summary statistics from epoched MEG data (directory [trialfeatures](https://github.com/lorenzomagazzini/meg-trial-classification/tree/master/trialfeatures));
2. [Classification](https://github.com/lorenzomagazzini/meg-trial-classification/wiki/Trial-classification): use the features as input to a Support Vector Machine (SVM) classifier, in order to automatically identify trials containing artefacts (directory [trialclassification](https://github.com/lorenzomagazzini/meg-trial-classification/tree/master/trialclassification)).

The code can be run using the example .mat files included within this repository (directory [data](https://github.com/lorenzomagazzini/meg-trial-classification/tree/master/data)).

## Dependencies

This code requires the [Fieldtrip toolbox](http://www.fieldtriptoolbox.org/) and was last tested with [FieldTrip version](ftp://ftp.fieldtriptoolbox.org/pub/fieldtrip/) _20180630_ in [MATLAB](https://www.mathworks.com/) _R2015a_.

The SVM classifier requires two libraries, [liblinear](https://github.com/cjlin1/liblinear) and [libsvm](https://github.com/cjlin1/libsvm), both included within this repository.

The colour maps in some of the figures were generated using [cmocean](https://github.com/matplotlib/cmocean) [for MATLAB](https://uk.mathworks.com/matlabcentral/fileexchange/57773-cmocean-perceptually-uniform-colormaps).