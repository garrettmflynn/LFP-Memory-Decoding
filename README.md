# LFP-Memory-Decoding

## Summary
**LFP-Memory-Decoding** is a machine learning pipeline developed for the USC Restoring Active Memory (RAM) research conducted in Song Lab. 


## Scripts
### Dashboard.m
*Set pipeline settings for desired data types, ML methods, etc*
#### Options
  ##### Data File
    1. ClipArt2
    2. Recording003
    3. Rat_Data
    4. Other
  
  ##### Data Format
  *Choice Formatting : (optional band parameter)Signal/Spectrum*
  
    1. theta (4 - 8 Hz)
    2. alpha (8 - 12 Hz)
    3. beta (16 - 24 Hz)
    4. lowGamma (25 - 55 Hz)
    5. highGamma (65 - 140 Hz)
    
  
  ##### Scope of Machine Learning
    1. Multi-Channel Analysis (MCA)
    2. Hippocampal Output Analysis (CA1)
    3. Hippocampal Input Analysis (CA3)
  
  ##### ML Algorithm
    1. kMeans
    2. lassoGLM
    3. naiveBayes
    4. SVM
    5. linear
    6. kernel
    7. knn
    8. tree
    9. RUSBoost
    10. CNN_SVM
  
  ##### ML Methods Parameters
  *1 = on | 0 = off*
  
    1. Reduce Channels (using PCA)?
    2. Use Bsplines?
      - Bspline Order? (number)
      - Resolution Choices? (range)
    3. Use the Average Power of Each Band?
  
  ##### Data Processing Parameters
    1. Use a 60 Hz notch filter? (1/0)
    2. Frequency to downsample to? (leave empty to keep at original sampling rate)
    3. Normalize? (1/0)
    4. Output Format? (either 'zScore' or 'percentChange')
    5. FFT Window? ('Hanning' or others)
    6. Time Bin? (in # of sampling points)
    7. Frequency Bin? (in Hz)
  
  ##### Currently Hardcoded
    1. Window of Interest: 1 second
    2. Center Event: SAMPLE_RESPONSE

### LFPMD_0_Structure
*Load NSx and nex files into a standardized data structure (HHDataStructure)*


### LFPMD_1_Preprocess
*Band, normalize, and/or interval the data in HHDataStructure to create a data structure to analyze (dataML)*


### LFPMD_2_Model
*Run dataML through the machine learning pipeline specified here (settings in dashboard.m)*


### LFPMD_3_Visualize
*Visualize signal in HHDataStructure OR model performance*
