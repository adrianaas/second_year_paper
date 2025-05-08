# second_year_paper
Does the U.S. migrant mortality advantage vary by region of birth?

The following code is used to run the models and generate tables and figures for my second year paper, "Does the U.S. migrant mortality advantage vary by region of birth?"
Note, the code in 100_data_cleaning includes a portion where we take a 25% sample due to computational intensiveness of running the models. To see the actual results from the paper, comment this line out.

Each X00 document sets the global directory - change this to fit your own directory

Naming convention
XYZ_file_title - X representing a step of the analysis reflected in the sections of the paper, Y representing a subsection or alternative version of the calculations (e.g. model based vs. raw data based analysis), Z representing a do file linked to a step in Y. Generally, only the Z = 0 file needs to be run, and this file will automatically call to Z=1, which will call to Z=2, etc.


1 : : - data cleaning

2 : : - NVSS comparisons
: 0 : - model based
: : 0 - main file, creates output
: : 1 - runs models to estimate death counts & exposures
: : 2 - performs life table calculations
: 1 : - raw NHIS based

3 : : - NHIS life table (nMx and e30-85) calculations
: 0 : - model based
: : 0 - main file, creates output
: : 1 - runs models to estimate death counts & exposures
: : 2 - performs life table calculations
: 1 : - raw NHIS based
: : 0 - main file, creates output
: : 1 - uses raw data to calculate death counts & exposures
: : 2 - performs life table calculations

4 : : - regressions

9 : : - makes tables
: : 0 - descriptives
: : 1 - death counts & exposures descriptives

