# Simulation Toolbox for Infant Growth with focus on Metabolism (STIG-met)

- STIG-met is an integrated platform for simulation of human growth. We combine the experience from traditional growth models with GEMs to provide predictions of metabolic fluxes with enzyme level resolution on a day-to-day basis.

- Abstract:

An estimated 165 million children globally have stunted growth, and extensive growth data are available. Genome scale metabolic
models allow the simulation of molecular flux over each metabolic enzyme, and are well adapted to analyze biological systems. We
used a human genome scale metabolic model to simulate the mechanisms of growth and integrate data about breast-milk intake
and composition with the infant’s biomass and energy expenditure of major organs. The model predicted daily metabolic fluxes
from birth to age 6 months, and accurately reproduced standard growth curves and changes in body composition. The model
corroborates the finding that essential amino and fatty acids do not limit growth, but that energy is the main growth limiting factor.
Disruptions to the supply and demand of energy markedly affected the predicted growth, indicating that elevated energy
expenditure may be detrimental. The model was used to simulate the metabolic effect of mineral deficiencies, and showed the
greatest growth reduction for deficiencies in copper, iron, and magnesium ions which affect energy production through oxidative
phosphorylation. The model and simulation method were integrated to a platform and shared with the research community. The
growth model constitutes another step towards the complete representation of human metabolism, and may further help improve
the understanding of the mechanisms underlying stunting.

- KeyWords:

**Utilisation:** maximising growth, predictive simulation, experimental data reconstruction; **Model Source:** HMR2.00; **Taxonomy:** Homo sapiens  **Condition:** Malnourishment, Starvation, 

- Reference: [Nilsson, A., Mardinoglu, A., and Nielsen, J. (2017). Predicting growth of the healthy infant using a genome scale metabolic model. Npj Systems Biology and Applications, 3(1), 3.](http://www.nature.com/articles/s41540-017-0004-5)

- Pubmed ID: 28649430

- Last update: 2021-08-11




This repository is administered by name @avlant, Division of Systems and Synthetic Biology, Department of Biology and Biological Engineering, Chalmers University of Technology


## Installation

### Required Software:

* *_PROGRAMMING LANGUAGE/Version_*  (e.g.):
  * You need a functional Matlab installation of **Matlab_R_2015_b**
  * The [RAVEN](https://github.com/SysBioChalmers/RAVEN) toolbox for MATLAB. Installation instructions [here](https://github.com/SysBioChalmers/RAVEN/wiki/Installation#installation)

### Run
To reproduce figure 1 run main.m. For other figures run main[name of simulation].m

### Aditional information
For a visual guide to the structure of the simulation toolbox, view readme.pptx


## License
This work is licensed under a Creative Commons Attribution-
NonCommercial-ShareAlike 4.0 International License. The images or
other third party material in this article are included in the article’s Creative Commons
license, unless indicated otherwise in the credit line; if the material is not included under
the Creative Commons license, users will need to obtain permission from the license
holder to reproduce the material. To view a copy of this license, visit http://
creativecommons.org/licenses/by-nc-sa/4.0/