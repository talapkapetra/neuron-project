#  Neuron Data Science Project

## Project Overview

For this neuroscience project I used my own dataset. Our aim was the complete morphometric analysis of dendrites and synapses of inhibitory neurons (mouse visual cortex). The neurons were identified by immunohistochemistry using markers of different types of calcium-binding proteins they contain (calbindin, calretinin, parvalbumin). The data collected from volume electron microscopy. 

Briefly, ultrathin sections (50 nanometer) were made from histological brain samples and captured by a transmission electron microscope. Image stacks covering the dendrites and their axon terminals (synaptic boutons) were used for segmentation (outline) the structures on each single image and 3D structures were built from the stacks with the help of different software (FIJI, Reconstruct, Neurolucida, Blender).

We utilized these softwares to gain morphometric features of the terminals and synapses at the micron and nano level: volume and surface area of the boutons, surface area (extent) of the synapses, distance of the synapses from the soma, synaptic vesicle data.

## Objectives

 - Organizing of the huge datasets and create a database which can be integrated into international storage systems.
 - Statistical analysis of the effect of compression which could be observed due to the ultrathin sectioning. 
 - Statistical analysis of the morphometric synaptic features. Are there any differences between markers as well as different synapse types (excitatory vs. inhibitory)?

## Tools:
 - Excel: organizing and collecting of datasets
 - Python, PyCharm: data cleaning, data preparation, exploratory data analysis, statistics
 - PostgreSQL, DataGrip: creating database
 - PowerBI: data visualization

## Abbreviations

|ABBREVIATION|FULL NAME|
|--------------------|----------------|
|as|asymmetric synapse|
|CB|calbidnin|
|CR|calretinin|
|den|dendrite|
|exc|excitatory|
|inh|inhibitory|
|PV|parvalbumin|
|ss|symmetric synapse|

## Supplementary information
I attached some representative figures and movie to make easier the overview of the project.

**1. Representative image made by a light microscope with three calbindin positive neurons**

![LM_image_small](https://github.com/user-attachments/assets/fdc2f33e-2f98-416f-b242-6600e5a4216e)

**2. Representative images made by a transmission electron microscope (TEM) to present asymmetric and symmetric synapses.**

Important to note, that that the expressions ’asymmetric’ and ’symmetric’ are used in neuroanatomy and corresponds to excitatory and inhbitory synapse types, respectively. I used *exc.* and *inh.* abbrevations in the visualtisations to make easier to interpret the results. However, in the main dataset, data were stored as *as* and *ss*.

These TEM images were used to collect vesicle data: area, form factor, nearest neighbour distance.

![EM_figure](https://github.com/user-attachments/assets/b6cd1fe4-ab25-4b15-90b4-bfc351a43e8c)

The contour of vesicles located less than 50 nm from the active zones (~ surface of the chemical synaptic connections) were drawn using Neurolucida reconstruction system. That meant to be measured  approximately 10-30 vesicles / synapse. 
In general, excitatory (asymmetric) synapses have vesicles approaching the regular circle, while inhibitory (symmetric) synapse vesicles are oval. *Exc.* vesicles located closer to each other than *inh.* vesicles. Therefore statistical analysis and comparison of the morphometric properties of the vesicles like area, form factor and nearest neighbour distance help in the characterization of synapses.

**3. I used Blender for final smoothing and editing the 3D reconstruction of the dendrites.
Representative image of all dendrites.**

![3D_Blender_figure](https://github.com/user-attachments/assets/ad6d6c1f-5086-404c-a738-0185198f4e57)

**4. Movie of one calbindin-positive neuron and their two dendrites (den1 and den2)**

https://talapkapetra.github.io/neuron-project/calbindin_neuron_3D.html

## Data Preparation

### Preparation of csv files

I had two excel files:
-  neuron_dataset_shrinkage.xlsx

- neuron_dataset_summary.xlsx

( For the raw dataset please contact me.)

[neuron_dataset.ipynb](https://talapkapetra.github.io/neuron-project/neuron_dataset.ipynb)

### Transformation of csv files containing vesicle data

[neuron_dataset.ipynb](https://talapkapetra.github.io/neuron-project/neuron_dataset.ipynb)

Identification of boutons: b1, b2, b3…

However, in case of vesicle datasets, one bouton had 10-30 data (rows). Therefore I had to introduce a new, unique labelling for each vesicles: b1_1, b1_2, b1_3, b2_1, b2_2…

### Transformation CB_den1 and CB_den2 before vesicle csv files and calculation to determine the nearest neighbour distance

For the statistical analysis of the effects of compression correction I needed data not only after but also before performing the compression corrections.

When I got the dataset, I realised, that nearest neighbour distance calculations were missing for CB_den1 and CB_den2 before corrections. (For other groups, data were available in the excel files.) I figured out that my collegue made the calculation in excel with a formula counting the Manhattan and Euclidean distance for each vesciles. But it was not added to the excel files.

- remove of NaN values
- *X and Y and Z coordinates* : I transformed the numbers (string format, points etc.) and removed Z coordinates. Since measurements were made on images (on the 2D pane), Z value was always 0.
- I created two new columns for the X and Y corrdinates (x_coord, y_coord)
- Nearest neighbour distance measurement was performed in two steps in case of each vesicles:
   - Firstly, *Manhattan distance* was calculated to determine which point is the closest to the current   point within the vesicle group of one synapse. Manhattan distance is simpler and computationally less expensive to calculate.
   - Afterwards, *Euclidean Distance* was calculated to measure the actual spatial distance between the current point and the closest point. Euclidean distance provides a precise measure of the straight-line distance in 2D space.

```python
data = CB_den1_clean

# Function to calculate Manhattan distance
def manhattan_distance(point1, point2):
    return abs(point1[0] - point2[0]) + abs(point1[1] - point2[1])

# Function to calculate Euclidean distance
def euclidean_distance(point1, point2):
    return np.sqrt((point1[0] - point2[0])**2 + (point1[1] - point2[1])**2)

# Initialize a list to store the results
results = []

# Loop through each bouton_number group
for bouton_number, group in CB_den1_clean.groupby('bouton_number'):
    for index, row in group.iterrows():
        original_point = (row['x_coord'], row['y_coord'])
        
        # Calculate Manhattan distances to all other points in the group, excluding the original point
        distances = group.apply(
            lambda r: manhattan_distance(original_point, (r['x_coord'], r['y_coord'])) if r.name != index else np.inf, 
            axis=1
        )
         # Identify the index of the closest point based on Manhattan distance
        closest_point_index = distances.idxmin()
        closest_point = (group.loc[closest_point_index, 'x_coord'], group.loc[closest_point_index, 'y_coord'])
        
        # Calculate the Euclidean distance between the original point and the closest point
        euclidean_dist = euclidean_distance(original_point, closest_point)
        
        # Store the results
        results.append({
            'bouton_number': bouton_number,
            'original_point': original_point,
            'closest_point': closest_point,
            'euclidean_distance': euclidean_dist
        })

# Convert results to a DataFrame
CB_den1_clean_results_df = pd.DataFrame(results)

# Display the results
CB_den1_clean_results_df
```

- euclidean_distance column: contain data in micron

- euclidean_distance_corr_nanometer column: I multipled the values in *euclidean_distance column* by 10. During the measurements in Neurolucida, original images were multipled with 100 beacause software could not handle datasets in the nanometer level. Therefore at this data processing step only multiple by 10 was needed for exchanging the values to the final nanometer.

- Finally, I checked duplicates and transferred numeric data to float64 format.

- Final cleaned datasets were exported to csv and Python codes of the full process stored:

[CB_den1_vesicle_before_shrink.ipynb](https://talapkapetra.github.io/neuron-project/CB_den1_vesicle_before_shrink.ipynb)

[CB_den2_vesicle_before_shrink.ipynb](https://talapkapetra.github.io/neuron-project/CB_den2_vesicle_before_shrink.ipynb)

## Compression correction

[neuron_dataset_shrinkage_stat.ipynb]( https://talapkapetra.github.io/neuron-project/neuron_dataset_shrinkage_stat.ipynb)

### Data Cleaning/ Preparation

- Loading csv files after the first data cleaning step (see above).
- Adding a new column to all dataframes cover dendrite data for later identification and concatonation of the datasets: dendrite_name_compr
- Creating three new dataframes: bouton_df, synapse_df, vesicle_df
- Remove duplicated values
- Remove NaN values

### Exploratory Data Analysis

**Descriptive statistics**

bouton_df

![bouton_descr_stats](https://github.com/user-attachments/assets/02edf6c8-2fda-4c43-ba94-ddbfee4c33a3)

synapse_df

![synapse_descr_stats](https://github.com/user-attachments/assets/40f61375-3ccf-491d-8636-076193d554c8)

vesicle_df

![vesicle_descr_stats](https://github.com/user-attachments/assets/3050a1c8-63e5-4be9-b151-2f7be64f4287)

**Normality test**

Shapiro-Wilk normality test was used to investigate if the datasets are fit to the Gaussian distirbution.

All of the datasets were non-normally distributed (p < 0.05)

bouton_df

![bouton_shapiro](https://github.com/user-attachments/assets/30aa3204-b2a0-4d13-8d63-7329a7447abe)

synapse_df

![synapse_shapiro](https://github.com/user-attachments/assets/0d103795-11ab-4770-bdcf-8dc227869db1)

vesicle_df

![vesicle_shapiro](https://github.com/user-attachments/assets/cdf1447e-5d8e-406c-b99f-a74845040515)

**Boxplots**

Vesicle area 

![vesicle_area_boxplot](https://github.com/user-attachments/assets/e34be1ff-b790-40f8-be21-cbf3a8b6d212)

Vesicle form factor

![form_factor](https://github.com/user-attachments/assets/48d34f59-b434-4187-bbc5-d005aa9b9d8b)

Nearest neighbour distance of the vesicles

![nearest_neighbour_distance](https://github.com/user-attachments/assets/0bc34abd-fefe-40db-a8d5-0322f4fb4de7)

Note: Boxplots were not made of bouton (surface, volume) and synapse (surface area, distance from soma) datasets, because I have choosen other plotting methods (see later).

### Statistical analysis

Mann-Whitney U test was used for pairweis comparison of data collected before and after the compression correction.

Outliers were removed only in case of vesicle data. 
 - The main objective of the whole project to get morphometric details of each synapses of the dendrites. Therefore, in case of synapse and bouton data, I always presented all, only those were removed, where the segmentation and 3D reconstruction was not complete for some reasons.
 - In case of vesicle data, ~10-30 vesicle belonged to one synapse and vesicle dataset was only used for the compression correction statistics. Therefore, here was reasonable to omit outliers before statistics.

bouton

```
Comparison: CB_den1_before vs. CB_den1_after
Mann-Whitney U Test for surface_area_micron^2:
Group 1 vs Group 2 U statistic: 5167.0, p-value: 0.1479307866294479

Mann-Whitney U Test for volume_micron^3:
Group 1 vs Group 2 U statistic: 4991.0, p-value: 0.06723488871103635

Comparison: CB_den2_before vs. CB_den2_after
Mann-Whitney U Test for surface_area_micron^2:
Group 1 vs Group 2 U statistic: 537.0, p-value: 0.2133218503263593

Mann-Whitney U Test for volume_micron^3:
Group 1 vs Group 2 U statistic: 532.0, p-value: 0.19332882103218263
```

synapse 
```
Comparison: CB_den1_before vs. CB_den1_after
Mann-Whitney U Test for surface_area_micron^2:
Group 1 vs Group 2 U statistic: 5597.0, p-value: 0.6096319686688123

Mann-Whitney U Test for distance_from_soma_micron:
Group 1 vs Group 2 U statistic: 4083.0, p-value: 0.0001405642914087126

Comparison: CB_den2_before vs. CB_den2_after
Mann-Whitney U Test for surface_area_micron^2:
Group 1 vs Group 2 U statistic: 598.0, p-value: 0.5771972405902599

Mann-Whitney U Test for distance_from_soma_micron:
Group 1 vs Group 2 U statistic: 511.0, p-value: 0.12421924078970249
```

vesicle
```
Comparison: CB_den1_before vs. CB_den1_after
Mann-Whitney U Test for vesicle_area_micron^2:
Group 1 vs Group 2 U statistic: 230238.5, p-value: 5.665342402761894e-35

Mann-Whitney U Test for form_factor:
Group 1 vs Group 2 U statistic: 373603.0, p-value: 0.03803398474759792

Mann-Whitney U Test for nearest_neighbour_distance:
Group 1 vs Group 2 U statistic: 259350.0, p-value: 4.901888398121175e-21

Comparison: CB_den2_before vs. CB_den2_after
Mann-Whitney U Test for vesicle_area_micron^2:
Group 1 vs Group 2 U statistic: 29314.0, p-value: 3.5876354225166217e-12

Mann-Whitney U Test for form_factor:
Group 1 vs Group 2 U statistic: 54348.0, p-value: 3.7272286584063873e-07

Mann-Whitney U Test for nearest_neighbour_distance:
Group 1 vs Group 2 U statistic: 33840.0, p-value: 1.7826284520898987e-06
```

### Results
- synapse: Significant difference was observed only in surface area CB_den1_before vs. CB_den1_after.
- bouton: No significant differences have been determined.
- vesicle: Significant differences were observed in all cases regarding the vesicle dataset.

As a final conclusion, remarkable changes have always been observed in the morphometric parameters of synapses because of compression but significant differences were proved only in vesicle data.

## Morphometric properties of synapses of calbindin-, calretinin- and parvalbumin-immunopositive neurons

[neuron_dataset_summary_stat.ipynb]( https://talapkapetra.github.io/neuron-project/neuron_dataset_summary_stat.ipynb)

For this analysis, only datasets after compression corrections were used.

### Data Cleaning/ Preparation

- Loading csv files after the first data cleaning step (see above).
- Adding a new column to all dataframes cover dendrite data for later identification and concatonation of the datasets: marker
- Creating three new dataframes according to markers: CB_combined, CR_combined, PV_combined
- Certain columns were organised to dataframes according to the statistic tests
- Remove duplicated values
- Remove NaN values
- Filtering and organising of *as* (excitatory) and *ss* (inhibitory) datasets: full_dataframe_cleaned, full_dataframe_cleaned_as, full_dataframe_cleaned_ss

### Exploratory Data Analysis

**Descriptive statistics**

full_dataset

![full_dataset_descr_stat](https://github.com/user-attachments/assets/297e9989-09f5-4f9e-84e3-d14f927785fb)

as_dataset

![full_dataset_as_descr_stat](https://github.com/user-attachments/assets/23ee5b16-9892-43a4-b131-bf24fe8e6a02)

ss_dataset

![full_dataset_ss_descr_stat](https://github.com/user-attachments/assets/98ffec63-3d6f-4efd-b208-ed040b5d495c)

**Normality test**

Shapiro-Wilk normality test was used to investigate if the datasets are fit to the Gaussian distirbution.

All of the datasets were non-normally distributed (p < 0.05)

full_dataset

![full_dataset_shapiro](https://github.com/user-attachments/assets/44d0f822-65c6-4549-a110-1eddf253a01c)

as_dataset

![full_dataset_as_shapiro](https://github.com/user-attachments/assets/6f16cec3-f958-4cf3-941d-80c5bbe1b719)

ss_dataset

![full_dataset_ss_shapiro](https://github.com/user-attachments/assets/9b372572-457d-47f7-b4c6-79aa7db8cf01)

**Boxplots**

Datasets were reorganised according to markers: calbindin_df, calretinin_df, parvalbumin_df

Bouton

Bouton morphometry was presented as surface area/ volume ratio.

![bouton_ratio_summary_boxplot](https://github.com/user-attachments/assets/2404e704-9dac-4baa-a6af-6095e2745a9c)

Synapse Surface Area

![synapse_surface_summary_boxplot](https://github.com/user-attachments/assets/4f590ab7-1cb9-4993-9958-6f9004c3d6a5)

**Histograms**

Distribution of synapses along the dendrites

full_dataset

![synapse_full_histoplot](https://github.com/user-attachments/assets/ebe769a9-cc8c-4708-96ec-365f476f8979)

as_dataset

![synapse_as_histoplot](https://github.com/user-attachments/assets/b80d5419-e29c-4d63-8690-142503e9625e)

ss_dataset

![synapse_ss_histoplot](https://github.com/user-attachments/assets/7e6fdaa3-0d28-4be1-ac6a-9a0918947259)

### Statistical analysis

Mann-Whitney U test was performed to compare *as vs. ss* data.

Newmanm-Keuls test (with Tukey) was performed to make pairweis comparisons between markers.

Bouton Surface area / Volume ratio

```
### Mann-Whitney U Test Results (Within Markers) ###


Analyzing marker: calbindin
Mann-Whitney U Test Results for calbindin: U-statistic = 2267.0000, p-value = 1.7569e-01
No significant difference found between as and ss for calbindin (p >= 0.05)

Analyzing marker: calretinin
Mann-Whitney U Test Results for calretinin: U-statistic = 1198.0000, p-value = 1.2078e-02
Significant difference found between as and ss for calretinin (p < 0.05)

Analyzing marker: parvalbumin
Mann-Whitney U Test Results for parvalbumin: U-statistic = 21917.0000, p-value = 2.9933e-08
Significant difference found between as and ss for parvalbumin (p < 0.05)

### Newman-Keuls Test Results (Between Markers) ###

ANOVA Table:
                sum_sq     df          F        PR(>F)
group      3019.233822    5.0  28.083728  3.667043e-26
Residual  16362.763179  761.0        NaN           NaN
Significant differences found, performing Newman-Keuls test...
Multiple Comparison of Means - Tukey HSD, FWER=0.05         
====================================================================
    group1         group2     meandiff p-adj   lower   upper  reject
--------------------------------------------------------------------
  calbindin_as   calbindin_ss  -1.1893 0.7831 -3.7957  1.4171  False
  calbindin_as  calretinin_as   2.5141 0.0009  0.7265  4.3017   True
  calbindin_as  calretinin_ss  -0.2335    1.0 -3.6684  3.2015  False
  calbindin_as parvalbumin_as   4.5251    0.0  3.1501  5.9002   True
  calbindin_as parvalbumin_ss   1.3843 0.3337 -0.5769  3.3456  False
  calbindin_ss  calretinin_as   3.7034  0.001  1.0503  6.3565   True
  calbindin_ss  calretinin_ss   0.9559  0.983 -2.9992  4.9109  False
  calbindin_ss parvalbumin_as   5.7144    0.0  3.3198  8.1091   True
  calbindin_ss parvalbumin_ss   2.5737 0.0865 -0.1994  5.3467  False
 calretinin_as  calretinin_ss  -2.7475 0.2112 -6.2181   0.723  False
 calretinin_as parvalbumin_as    2.011 0.0013  0.5493  3.4727   True
 calretinin_as parvalbumin_ss  -1.1297 0.6018 -3.1527  0.8932  False
 calretinin_ss parvalbumin_as   4.7586 0.0005  1.4814  8.0357   True
 calretinin_ss parvalbumin_ss   1.6178 0.7866 -1.9453  5.1809  False
parvalbumin_as parvalbumin_ss  -3.1408    0.0 -4.8104 -1.4712   True
--------------------------------------------------------------------
```

Synapse Surface Area

```
### Mann-Whitney U Test Results (Within Markers) ###


Analyzing marker: calbindin
Mann-Whitney U Test Results for calbindin: U-statistic = 2966.0000, p-value = 7.5350e-06
Significant difference found between as and ss for calbindin (p < 0.05)

Analyzing marker: calretinin
Mann-Whitney U Test Results for calretinin: U-statistic = 1026.0000, p-value = 2.2872e-01
No significant difference found between as and ss for calretinin (p >= 0.05)

Analyzing marker: parvalbumin
Mann-Whitney U Test Results for parvalbumin: U-statistic = 16858.0000, p-value = 2.7421e-01
No significant difference found between as and ss for parvalbumin (p >= 0.05)

### Newman-Keuls Test Results (Between Markers) ###

ANOVA Table:
            sum_sq     df          F        PR(>F)
group     0.124609    5.0  24.655838  4.629918e-23
Residual  0.769207  761.0        NaN           NaN
Significant differences found, performing Newman-Keuls test...
Multiple Comparison of Means - Tukey HSD, FWER=0.05         
====================================================================
    group1         group2     meandiff p-adj   lower   upper  reject
--------------------------------------------------------------------
  calbindin_as   calbindin_ss  -0.0374    0.0 -0.0553 -0.0195   True
  calbindin_as  calretinin_as  -0.0295    0.0 -0.0417 -0.0172   True
  calbindin_as  calretinin_ss  -0.0393    0.0 -0.0628 -0.0157   True
  calbindin_as parvalbumin_as   -0.035    0.0 -0.0444 -0.0256   True
  calbindin_as parvalbumin_ss  -0.0375    0.0 -0.0509  -0.024   True
  calbindin_ss  calretinin_as    0.008 0.8121 -0.0102  0.0261  False
  calbindin_ss  calretinin_ss  -0.0018    1.0  -0.029  0.0253  False
  calbindin_ss parvalbumin_as   0.0024 0.9983  -0.014  0.0188  False
  calbindin_ss parvalbumin_ss     -0.0    1.0  -0.019   0.019  False
 calretinin_as  calretinin_ss  -0.0098 0.8484 -0.0336   0.014  False
 calretinin_as parvalbumin_as  -0.0055 0.6145 -0.0156  0.0045  False
 calretinin_as parvalbumin_ss   -0.008 0.5681 -0.0219  0.0059  False
 calretinin_ss parvalbumin_as   0.0043 0.9944 -0.0182  0.0267  False
 calretinin_ss parvalbumin_ss   0.0018 0.9999 -0.0226  0.0262  False
parvalbumin_as parvalbumin_ss  -0.0025   0.99 -0.0139   0.009  False
--------------------------------------------------------------------
```

Synapse Distance from Soma

```
### Mann-Whitney U Test Results (Within Markers) ###


Analyzing marker: calbindin
Mann-Whitney U Test Results for calbindin: U-statistic = 2126.0000, p-value = 4.6907e-01
No significant difference found between as and ss for calbindin (p >= 0.05)

Analyzing marker: calretinin
Mann-Whitney U Test Results for calretinin: U-statistic = 967.0000, p-value = 4.4988e-01
No significant difference found between as and ss for calretinin (p >= 0.05)

Analyzing marker: parvalbumin
Mann-Whitney U Test Results for parvalbumin: U-statistic = 18988.0000, p-value = 3.0137e-03
Significant difference found between as and ss for parvalbumin (p < 0.05)

### Newman-Keuls Test Results (Between Markers) ###

ANOVA Table:
                sum_sq     df          F        PR(>F)
group     3.385853e+05    5.0  28.542369  1.423007e-26
Residual  1.805480e+06  761.0        NaN           NaN
Significant differences found, performing Newman-Keuls test...
Multiple Comparison of Means - Tukey HSD, FWER=0.05         
=====================================================================
    group1         group2     meandiff p-adj   lower    upper  reject
---------------------------------------------------------------------
  calbindin_as   calbindin_ss  -5.2464 0.9941 -32.6246 22.1318  False
  calbindin_as  calretinin_as -28.0339 0.0003 -46.8113 -9.2565   True
  calbindin_as  calretinin_ss -30.4082 0.1547 -66.4897  5.6733  False
  calbindin_as parvalbumin_as  28.6734    0.0  14.2296 43.1173   True
  calbindin_as parvalbumin_ss  10.0663 0.7295 -10.5353  30.668  False
  calbindin_ss  calretinin_as -22.7875 0.1809 -50.6566  5.0816  False
  calbindin_ss  calretinin_ss -25.1618  0.512 -66.7066 16.3831  False
  calbindin_ss parvalbumin_as  33.9199 0.0018   8.7659 59.0738   True
  calbindin_ss parvalbumin_ss  15.3128 0.6632 -13.8167 44.4422  False
 calretinin_as  calretinin_ss  -2.3743    1.0 -38.8297 34.0812  False
 calretinin_as parvalbumin_as  56.7073    0.0  41.3533 72.0614   True
 calretinin_as parvalbumin_ss  38.1002    0.0  16.8505   59.35   True
 calretinin_ss parvalbumin_as  59.0816    0.0  24.6573 93.5059   True
 calretinin_ss parvalbumin_ss  40.4745 0.0253   3.0468 77.9023   True
parvalbumin_as parvalbumin_ss -18.6071 0.0302 -36.1452  -1.069   True
---------------------------------------------------------------------
```

### Results

**Bouton Surface Area/ Volume ratio**

- *exc. vs. inh.* synapses
  - Significant difference was revealed only in case of *parvalbumin* dendrites between exc. and inh. synapses.
- markers:
  - Significant differences were revealed in all cases comparing the *exc.*  synapses of markers.
  - No significant differences were revealed comparing the inh. synapses of markers.

**Synapse Surface Area**

- *exc. vs. inh.* synapses
  - Significant difference was revealed only in case of *calbindin* dendrites.
- markers:
  - Significant differences were revealed calbindin vs. other markers comparing the *exc.* synapses of markers.
  - No significant differences were revealed comparing the inh. synapses of markers.

**Synapse Distance from Soma**

- *exc. vs. inh.* synapses
  - Significant difference was revealed only in case of *parvalbumin* dendrites.
- markers:
  - Significant differences were revealed between all markers comparing the *exc.* synapses of markers.
  - Significant differences were revealed between *calretinin and parvalbumin* comparing the inh. synapses of markers.

## Database

I created a database with all of the datasets in PostgreSQL system.

[Neuron_dataset_database.sql]( https://talapkapetra.github.io/neuron-project/Neuron_dataset_database.sql)

Part of the codes used to create database and tables for representation:

```sql
CREATE DATABASE neuron_dataset;

CREATE SCHEMA neuron_dataset;

SET search_path TO neuron_dataset;

-- 1. dendrite_data table
DROP TABLE neuron_dataset.dendrite_data
CREATE TABLE neuron_dataset.dendrite_data(
    dendrite_number VARCHAR (256) PRIMARY KEY,
    branch_number INT,
    marker VARCHAR (256),
    lenght_micron DECIMAL,
    surface_area_micron2 DECIMAL,
    as_bouton_number INT,
    ss_bouton_number INT
);

-- 2. cb_den1_before_shrink_bouton table
DROP TABLE neuron_dataset.CB_den1_before_shrink_bouton;
CREATE TABLE neuron_dataset.CB_den1_before_shrink_bouton(
    bouton_number VARCHAR (256) PRIMARY KEY,
    location VARCHAR (256),
    comment VARCHAR (256),
    bouton_surface_area_micron2 DECIMAL,
    bouton_volume_micron3 DECIMAL
);

-- 3. cb_den1_before_shrink_synapse table
DROP TABLE neuron_dataset.CB_den1_before_shrink_synapse;
CREATE TABLE neuron_dataset.CB_den1_before_shrink_synapse(
    bouton_number VARCHAR (256) PRIMARY KEY,
    synapse_number VARCHAR (256),
    synapse_surface_area_micron2 DECIMAL,
    distance_from_soma_micron DECIMAL,
    CONSTRAINT fk_CB_den1_before_shrink_bouton FOREIGN KEY (bouton_number) REFERENCES neuron_dataset.CB_den1_before_shrink_bouton(bouton_number) ON DELETE CASCADE
);

-- 4. cb_den1_before_shrink_vesicle table
DROP TABLE neuron_dataset.CB_den1_before_shrink_vesicle;
CREATE TABLE neuron_dataset.CB_den1_before_shrink_vesicle(
    bouton_number VARCHAR (256) PRIMARY KEY,
    synapse_type VARCHAR (256),
    vesicle_area_micron2 DECIMAL,
    form_factor DECIMAL,
    nearest_neighbour_distance_micron DECIMAL
);
```

## Data Visualisation in PowerBI

Database in PostgreSQL was connected to PowerBI Desktop where I made a report with three pages to present data analysed in Python.

In case of investigation the effect of compression correction on bouton and synapse morphometry, DAX expressions were written to plot the mean proportion (%) of differences. 

[neuron_project.pbix]( https://talapkapetra.github.io/neuron-project/neuron_project.pbix)

```DAX
CB den1 Synapse Surface Area Percentage Difference = 
AVERAGEX(
    'neuron_dataset cb_den1_after_shrink_synapse',
    DIVIDE(
        'neuron_dataset cb_den1_after_shrink_synapse'[synapse_surface_area_micron2] - RELATED('neuron_dataset cb_den1_before_shrink_synapse'[synapse_surface_area_micron2]),
        RELATED('neuron_dataset cb_den1_before_shrink_synapse'[synapse_surface_area_micron2]),
        0
    )
)
```

```DAX
CB den2 Synapse Surface Area Percentage Difference = 
AVERAGEX(
    'neuron_dataset cb_den2_after_shrink_synapse',
    DIVIDE(
        'neuron_dataset cb_den2_after_shrink_synapse'[synapse_surface_area_micron2] - RELATED('neuron_dataset cb_den2_before_shrink_synapse'[synapse_surface_area_micron2]),
        RELATED('neuron_dataset cb_den2_before_shrink_synapse'[synapse_surface_area_micron2]),
        0
    )
)
```

### Report Snapshot I

![snapshot_dashboard_01](https://github.com/user-attachments/assets/c88bbb1a-76c3-4f41-ad29-baf56dd6a361)

### Report Snapshot II

![snapshot_dashboard_02](https://github.com/user-attachments/assets/1898ac8e-d0ee-487d-8474-9b68c19e752e)

### Report Snapshot III

![snapshot_dashboard_03](https://github.com/user-attachments/assets/e37b42b2-a32f-426a-a7d4-f1ce5ceb5e72)

The report was published to Power BI Service.

[PowerBI report](https://app.powerbi.com/groups/me/reports/7c29cebd-036c-4a92-b9f5-1195953f8563/5163fd55600d096d0c28?redirectedFromSignup=1,1&experience=power-bi)

![snapshot_PBI_service](https://github.com/user-attachments/assets/a627fa6a-e7a2-4f9f-91fe-9ce913f6d2c5)

## References

One scientific manuscript was published based on my results and the second one is under the revision process.

[Frontiers manuscript]( https://pubmed.ncbi.nlm.nih.gov/33958990/)










