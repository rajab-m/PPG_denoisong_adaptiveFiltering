# PPG Heart Rate Estimation Project

## Overview
This project estimates heart rate from PPG signals using adaptive filtering and signal processing techniques.  
The pipeline includes bandpass filtering, adaptive noise cancellation, and peak-based heart rate detection.

---

## Main Script: `Main_ppg`
Running this script generates **22 figures**, showing:
- Filtered signals
- Estimated heart rates
- Final evaluation results

The selected algorithm can be specified in **line 11**.

---

## Core Function: `hr_estimate`
This function implements the full heart rate estimation pipeline described in the report.

### Steps included:
- Bandpass filtering  
- Adaptive filtering  
- Heart rate detection  
- Heart rate validation  

---

## Function: `adaptive_filtering_and_HR_detection`
This function estimates heart rate from the adaptively filtered PPG signal using the **dominant frequency peak**.

### Differences from `hr_estimate`:
- No heart rate validation  
- No failure handling of adaptive filtering  
- Only adaptive filtering + peak detection  

---

## Adaptive Filtering Methods

### `lms_filtering`
Implements the Least Mean Squares (LMS) algorithm.

### `nlms`
Implements the Normalized Least Mean Squares (NLMS) algorithm.

### `rls_ppg`
Implements the Recursive Least Squares (RLS) algorithm.

---

## Pipeline Flow
