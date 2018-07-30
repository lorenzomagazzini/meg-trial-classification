# Trial classification: automatic detection of trials containing artefacts in MEG data

The code contained within this repository is a project to extract informative summary statistics from epoched MEG data (trial features) and use them as input to a Support Vector Machine (SVM) classifier in order to automatically identify artefacts (trial classification).

The pipeline currently includes 2 stages:

1. [Features extraction](https://gitlab.cubric.cf.ac.uk/c1465333/Trial-classification/wikis/Features%20extraction)
2. [Classification](https://gitlab.cubric.cf.ac.uk/c1465333/Trial-classification/wikis/Trial%20classification)

The code requires the [Fieldtrip toolbox](http://www.fieldtriptoolbox.org/) and was last tested with FieldTrip version [20180630](ftp://ftp.fieldtriptoolbox.org/pub/fieldtrip/) in MATLAB R2015a.
