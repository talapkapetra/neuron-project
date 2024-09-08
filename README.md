#  Neuron Data Science Project

## Project Overview

For this neuroscience project I used my own dataset. Our aim was the complete morphometric analysis of dendrites and synapses of inhibitory neurons (mouse visual cortex). The neurons were identified by immunohistochemistry using markers of different types of calcium-binding proteins they contain (calbindin, calretinin, parvalbumin). The data collected from volume electron microscopy. 

Briefly, ultrathin sections (50 nanometer) were made from histological brain samples and captured by a transmission electron microscope. Image stacks covering the dendrites and their axon terminals (synaptic boutons) were used for segmentation (outline) the structures on each single image and 3D structures were built from the stacks with the help of different software (FIJI, Reconstruct, Neurolucida, Blender).

We utilized these softwares to gain morphometric features of the terminals and synapses at the micron and nano level: volume and surface area of the boutons, surface area (extent) of the synapses, distance of the synapses from the soma, synaptic vesicle data.

## Objectives

 - Organizing of the huge datasets and create a database which can be integrated into international storage systems.
 - Statistical analysis of the effect of compression which could be observed due to the ultrathin sectioning. 
 - Statistical analysis of the morphometric synaptic features. Are there any differences between markers as well as different synapse types (excitatory vs. inhibitory)

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
In general, excitatory (asymmetric) synapses have vesicles approaching the regular circle, while inhibitory (symmetric) synapse vesicles are oval. *Exc.* vesicles located closer to each other than *inh.* vesciles. Therefore statistical analysis and comparison of the morphometric properties of the vesciles like area, form factor and nearest neighbour distance help in the characterization of synapses.

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

( to get the raw dataset please contact me.)

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

Descriptive statistics:

bouton_df

![bouton_descr_stats](https://github.com/user-attachments/assets/02edf6c8-2fda-4c43-ba94-ddbfee4c33a3)

synapse_df

![synapse_descr_stats](https://github.com/user-attachments/assets/40f61375-3ccf-491d-8636-076193d554c8)

vesicle_df

![vesicle_descr_stats](https://github.com/user-attachments/assets/3050a1c8-63e5-4be9-b151-2f7be64f4287)









# Neuron project

dataset: Own dataset, raw data.

https://talapkapetra.github.io/neuron-project/calbindin_neuron_3D.html

### Dashboard Link : https://app.powerbi.com/groups/me/reports/7c29cebd-036c-4a92-b9f5-1195953f8563/5163fd55600d096d0c28?redirectedFromSignup=1,1&experience=power-bi

## Problem Statement

This dashboard helps 


### Steps followed 

- Step 1 : Load data into Power BI Desktop, dataset is a csv file.
- Step 2 : Open power query editor & in view tab under Data preview section, check "column distribution", "column quality" & "column profile" options.
- Step 3 : Also since by default, profile will be opened only for 1000 rows so you need to select "column profiling based on entire dataset".
- Step 4 : It was observed that in none of the columns errors & empty values were present except column named "Arrival Delay".
- Step 5 : For calculating average delay time, null values were not taken into account as only less than 1% values are null in this column(i.e column named "Arrival Delay") 
- Step 6 : In the report view, under the view tab, theme was selected.
- Step 7 : Since the data contains various ratings, thus in order to represent ratings, a new visual was added using the three ellipses in the visualizations pane in report view. 
- Step 8 : Visual filters (Slicers) were added for four fields named "Class", "Customer Type", "Gate Location" & "Type of travel".
- Step 9 : Two card visuals were added to the canvas, one representing average departure delay in minutes & other representing average arrival delay in minutes.
           Using visual level filter from the filters pane, basic filtering was used & null values were unselected for consideration into average calculation.
           
           Although, by default, while calculating average, blank values are ignored.
- Step 10 : A bar chart was also added to the report design area representing the number of satisfied & neutral/unsatisfied customers. While creating this visual, field named "Gender" was also added to the Legends bucket, thus number of customers are also seggregated according the gender. 
- Step 11 : Ratings Visual was used to represent different ratings mentioned below,

  (a) Baggage Handling

  (b) Check-in Services
  
  (c) Cleanliness
  
  (d) Ease of online booking
  
  (e) Food & Drink
  
  (f) In-flight Entertainment

  (g) In-flight Service
  
  (h) In-flight wifi service
  
  (i) Leg Room service
  
  (j) On-board service
  
  (k) Online boarding
  
  (l) Seat comfort
  
  (m) Departure & arrival time convenience
  
In our dataset, Some parameters were assigned value 0, representing those parameters are not applicable for some customers.

All these values have been ignored while calculating average rating for each of the parameters mentioned above.

- Step 12 : In the report view, under the insert tab, two text boxes were added to the canvas, in one of them name of the airlines was mentioned & in the other one company's tagline was written.
- Step 13 : In the report view, under the insert tab, using shapes option from elements group a rectangle was inserted & similarly using image option company's logo was added to the report design area. 
- Step 14 : Calculated column was created in which, customers were grouped into various age groups.

for creating new column following DAX expression was written;
       
        Age Group = 
        
        if(airline_passenger_satisfaction[Age]<=25, "0-25 (25 included)",
        
        if(airline_passenger_satisfaction[Age]<=50, "25-50 (50 included)",
        
        if(airline_passenger_satisfaction[Age]<=75, "50-75 (75 included)",
        
        "75-100 (100 included)")))
        
Snap of new calculated column ,

![Snap_1](https://user-images.githubusercontent.com/102996550/174089602-ab834a6b-62ce-4b62-8922-a1d241ec240e.jpg)

        
- Step 15 : New measure was created to find total count of customers.

Following DAX expression was written for the same,
        
        Count of Customers = COUNT(airline_passenger_satisfaction[ID])
        
A card visual was used to represent count of customers.

![Snap_Count](https://user-images.githubusercontent.com/102996550/174090154-424dc1a4-3ff7-41f8-9617-17a2fb205825.jpg)

        
 - Step 16 : New measure was created to find  % of customers,
 
 Following DAX expression was written to find % of customers,
 
         % Customers = (DIVIDE(airline_passenger_satisfaction[Count of Customers], 129880)*100)
 
 A card visual was used to represent this perecntage.
 
 Snap of % of customers who preferred business class
 
 ![Snap_Percentage](https://user-images.githubusercontent.com/102996550/174090653-da02feb4-4775-4a95-affb-a211ca985d07.jpg)

 
 - Step 17 : New measure was created to calculate total distance travelled by flights & a card visual was used to represent total distance.
 
 Following DAX expression was written to find total distance,
 
         Total Distance Travelled = SUM(airline_passenger_satisfaction[Flight Distance])
    
 A card visual was used to represent this total distance.
 
 
 ![Snap_3](https://user-images.githubusercontent.com/102996550/174091618-bf770d6c-34c6-44d4-9f5e-49583a6d5f68.jpg)
 
 - Step 18 : The report was then published to Power BI Service.
 
 
![Publish_Message](https://user-images.githubusercontent.com/102996550/174094520-3a845196-97e6-4d44-8760-34a64abc3e77.jpg)

# Report Snapshot I (Power BI DESKTOP)

![snapshot_dashboard_01](https://github.com/user-attachments/assets/d200d407-7829-463b-b6f5-604ff5957458)
 
 # Report Snapshot II (Power BI DESKTOP)

![snapshot_dashboard_02](https://github.com/user-attachments/assets/97fd2072-56b8-4ba0-9657-79927c526baa)

# Report Snapshot III (Power BI DESKTOP)

![snapshot_dashboard_03](https://github.com/user-attachments/assets/071bd8cb-5246-4a26-bd8e-35f45e2a5c03)

# Dashboard Snapshot (Power BI Service)

![snapshot_PBI_service](https://github.com/user-attachments/assets/e8b3fee0-ca1a-44e4-a369-3c00d293be53)


A single page report was created on Power BI Desktop & it was then published to Power BI Service.

Following inferences can be drawn from the dashboard;

### [1] Total Number of Customers = 129880

   Number of satisfied Customers (Male) = 28159 (21.68 %)

   Number of satisfied Customers (Female) = 28269 (21.76 %)

   Number of neutral/unsatisfied customers (Male) = 35822 (27.58 %)

   Number of neutral/unsatisfied customers (Female) = 37630 (28.97 %)


           thus, higher number of customers are neutral/unsatisfied.
           
### [2] Average Ratings

    a) Baggage Handling - 3.63/5
    b) Check-in Service - 3.31/5
    c) Cleanliness - 3.29/5
    d) Ease of online booking - 2.88/5
    e) Food & Drink - 3.21/5
    f) In-flight Entertainment - 3.36/5
    g) In-flight service - 3.64/5
    h) In-flight Wifi service - 2.81/5
    i) Leg room service - 3.37/5
    j) On-board service - 3.38/5
    k) Online boarding - 3.33/5
    l) Seat comfort - 3.44/5
    m) Departure & arrival convenience - 3.22/5
  
  while calculating average rating, null values have been ignored as they were not relevant for some customers. 
  
  These ratings will change if different visual filters will be applied.  
  
  ### [3] Average Delay 
  
      a) Average delay in arrival(minutes) - 15.09
      b) Average delay in departure(minutes) - 14.71
Average delay will change if different visual filters will be applied.

 ### [4] Some other insights
 
 ### Class
 
 1.1) 47.87 % customers travelled by Business class.
 
 1.2) 44.89 % customers travelled by Economy class.
 
 1.3) 7.25 % customers travelled by Economy plus class.
 
         thus, maximum customers travelled by Business class.
 
 ### Age Group
 
 2.1)  21.69 % customers belong to '0-25' age group.
 
 2.2)  52.44 % customers belong to '25-50' age group.
 
 2.3)  25.57 % customers belong to '50-75' age group.
 
 2.4)  0.31 % customers belong to '75-100' age group.
 
         thus, maximum customers belong to '25-50' age group.
         
### Customer Type

3.1) 18.31 % customers have customer type 'First time'.

3.2) 81.69 % customers have customer type 'returning'.
       
       thus, more customers have customer type 'returning'.

### Type of travel

4.1) 69.06 % customers have travel type 'Business'.

4.2) 30.94 % customers have travel type 'Personal'.

        thus, more customers have travel type 'Business'.

![Publish_Message](https://user-images.githubusercontent.com/102996550/174094520-3a845196-97e6-4d44-8760-34a64abc3e77.jpg)


# Insights

A single page report was created on Power BI Desktop & it was then published to Power BI Service.

Following inferences can be drawn from the dashboard;
