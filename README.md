# PPG Heart Rate Estimation

## Description
This project implements heart rate estimation from PPG signals using adaptive filtering and signal processing techniques. Accelerometer signals are used as a noise reference for motion artifact reduction.

---

## Main Script: `Main_ppg`
This is the main script of the project. Running it generates 22 figures representing:
- Filtered signals
- Estimated heart rates
- Final results


---

## Function: `hr_estimate`
This function implements the full heart rate estimation pipeline described in the report, including:
- Bandpass filtering
- Adaptive filtering
- Heart rate detection
- Heart rate validation

---

## Function: `adaptive_filtering_and_HR_detection`
This function estimates heart rate from the adaptively filtered PPG signal using the highest peak frequency.

Differences from `hr_estimate`:
- No heart rate validation
- No failure handling of adaptive filtering
- Only adaptive filtering + peak detection

---

## Adaptive Filtering Algorithms

### `lms_filtering`
Least Mean Squares (LMS) adaptive filtering algorithm.

### `nlms`
Normalized Least Mean Squares (NLMS) adaptive filtering algorithm.

### `rls_ppg`
Recursive Least Squares (RLS) adaptive filtering algorithm.

---

## Pipeline Flow
Main_ppg → hr_estimate → adaptive_filtering_and_HR_detection → (LMS / NLMS / RLS)
