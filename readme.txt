This project is structured as follows:

MAIN_PPG:
This is the main script of the project. Running this script generates 22 figures,
which represent the results including filtered signals and estimated heart rates.
HR_ESTIMATE:
This function returns the estimated heart rate using the proposed pipeline. The pipeline includes:
- Bandpass filtering
- Adaptive filtering
- Heart rate detection
- Heart rate validation

ADAPTIVE_FILTERING_AND_HR_DETECTION:
This function estimates the heart rate from the adaptively filtered PPG signal by
extracting the dominant (highest peak) frequency component.

Unlike HR_ESTIMATE, this function does NOT perform:
- Heart rate validation
- Failure handling of adaptive filtering

It performs only adaptive filtering followed by peak-based heart rate estimation.

LMS_FILTERING:
Implements the Least Mean Squares (LMS) adaptive filtering algorithm.

NLMS:
Implements the Normalized Least Mean Squares (NLMS) adaptive filtering algorithm.

RLS_PPG:
Implements the Recursive Least Squares (RLS) adaptive filtering algorithm.

--------------------------------------------------------------------------

PROJECT FLOW (FUNCTION CALL HIERARCHY):

Main_PPG
   └──> HR_ESTIMATE
           └──> ADAPTIVE_FILTERING_AND_HR_DETECTION
                   └──> (one of the adaptive filtering algorithms: LMS / NLMS / RLS)
