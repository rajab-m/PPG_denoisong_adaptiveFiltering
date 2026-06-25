 1. Experiment descriptions and data format 

Two-channel PPG signals, three-axis acceleration signals, and one-channel ECG signals were simultaneously recorded from subjects with age from 18 to 35. For each subject, the PPG signals were recorded from wrist by two pulse oximeters with green LEDs (wavelength: 515nm). Their distance (from center to center) was 2 cm. The acceleration signal was also recorded from wrist by a three-axis accelerometer. Both the pulse oximeter and the accelerometer were embedded in a wristband, which was comfortably worn. The ECG signal was recorded simultaneously from the chest using wet ECG sensors. All signals were sampled at 125 Hz and sent to a nearby computer via Bluetooth. 

Each dataset with the similar name 'DATA_01_TYPE01' contains a variable 'sig'. It has 6 rows. The first row is a simultaneous recording of ECG, which is recorded from the chest of each subject. The second row and the third row are two channels of PPG, which are recorded from the wrist of each subject. The last three rows are simultaneous recordings of acceleration data (in x-, y-, and z-axis). 

During data recording, each subject ran on a treadmill with changing speeds. For datasets with names containing 'TYPE01', the running speeds changed as follows: 
                    rest(30s) -> 8km/h(1min) -> 15km/h(1min) -> 8km/h(1min) -> 15km/h(1min) -> rest(30s) 

For datasets with names containing 'TYPE02', the running speeds changed as follows: 
                    rest(30s) -> 6km/h(1min) -> 12km/h(1min) -> 6km/h(1min) -> 12km/h(1min) -> rest(30s) 

For each dataset with the similar name 'DATA_01_TYPE01', the ground-truth of heart rate can be calculated from the simultaneously recorded ECG signal (i.e. the first row of the variable 'sig'). For convenience, we also provide the calculated ground-truth heart rate, stored in the datasets with the corresponding name, say 'DATA_01_TYPE01_BPMtrace'. In each of this kind of datasets, there is a variable 'BPM0', which gives the BPM value in every 8-second time window. Note that two successive time windows overlap by 6 seconds. Thus the first value in 'BPM0' gives the calcualted heart rate ground-truth in the first 8 seconds, while the second value in 'BPM0' gives the calculated heart rate ground-truth from the 3rd second to the 10th second. 
2. Citation and copyright 

All datasets have copyrights. But you can freely use them for the Signal Processing Cup or your own academic research, as long as you suitably cite the data in your works. Please do not cite this competition website, because it may not be available after this competition. Instead, please cite the following paper, since all training datasets come from it: 

Z. Zhang, Z. Pi, B. Liu, TROIKA: A general framework for heart rate monitoring using wrist-type photoplethysmographic signals during intensive physical exercise, IEEE Transactions on Biomedical Engineering, vol. 62, no. 2, pp. 522-531, February 2015, DOI: 10.1109/TBME.2014.2359372 
3. Contact Information 
If you have any questions, feel free to contact: 
Zhilin Zhang 
zhilinzhang@ieee.org 
zhangzlacademy@gmail.com

We have renamed the data sets to make it easy in the loading process in the main code, this table define the original name of each dataset, you can find the original data in the folders (training data, competition data);
No.	Renamed data	Original name
1.		Train1	DATA_01_TYPE01
2.		Train2	DATA_02_TYPE02
3.		Train3	DATA_03_TYPE02
4.		Train4	DATA_04_TYPE02
5.		Train5	DATA_05_TYPE02
6.		Train6	DATA_06_TYPE02
7.		Train7	DATA_07_TYPE02
8.		Train8	DATA_08_TYPE02
9.		Train9	DATA_09_TYPE02
10.		Train10	DATA_10_TYPE02
11.		Train11	DATA_11_TYPE02
12.		Train12	DATA_12_TYPE02
13.		Test1	TEST_S01_T01
14.		Test2	TEST_S02_T01
15.		Test3	TEST_S02_T02
16.		Test4	TEST_S03_T02
17.		Test5	TEST_S04_T02
18.		Test6	TEST_S05_T02
19.		Test7	TEST_S06_T01
20.		Test8	TEST_S06_T02
21.		Test9	TEST_S07_T02
22.		Test10	TEST_S08_T01

