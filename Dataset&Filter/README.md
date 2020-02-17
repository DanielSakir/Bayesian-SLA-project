Data was obtained by The Pooled Resource Open-Access ALS Clinical Trials (PRO-ACT), which includesinformation from over 8500 ALS patients who participated in different industry clinical trials and representsthe largest aggregation of ALS clinical trial data available. For this reason it is very heterogeneous with manymissing values.
 Each subject is identified by a SubjectID and thespecific assessment for this subject is identified by a record (each subject has multiple records). The assessmentsare separated into 14 different files according to type. It includes information about the patience background(like age, sex or race), his family neurological diseases, his weight and height, treatments, respiratory data,symptoms, laboratory tests and vital parameters. There is also a file with death information, and another oneabout a test periodically filled in by the patience. Some of those files are time varying.For each dataset, the time at which an assessment was taken (a record was created) is listed as the assessment’sdelta. Delta is given as days since the trial onset, with the trial onset referred to as Time 0. A negative deltalists events occurring before the official beginning of the trial.

Demographics
Demographic information is available in the Demographics file including for each subject the Age, the timewhen the age was measured
(Demographics_Delta, typically Time 0; for some patients age was measuredat different times, maximum 35 days before the start of the trial).  For some patients the Date_of_Birthis available, measured as the number of days from Demographics_Delta (negative values). Also informationavailable about Ethnicity (available for a subset of cases and distinguishing between “non hispanico or latino”or “hispanico or latino”), Race (Americ_Indian_Alaska_Native, Asian, Black_African_American, Hawai-ian_Pacific_Islander, Unknown, Caucasian – the most frequent race – and Other, specified in Other_Specify),and Gender.
Age has been calculated where missing using Birth when available. Dummy columns for the Races have beencreated.

ALS History Subject Symptoms
In the file Subject ALS History there are: Symptom, Symptom Other: Specify, and Location.

ALS History Subject Site
The site of disease onset as experienced by the patient can be a limb (“limb onset”) or the muscles control-ling speaking and swallowing (“bulbar onset”) or occasionally both.
Onset_Site dummy variables have been created.

Amyotrophic Lateral Sclerosis Functional Rating Score (ALS-FRS)
Symptom severity is frequently assessed using two functional scales: ALSFRS (ALS Functional Rating Scale)and its modified version ALSFRS-R.
he ALSFRS scale is a list of 10 assessments regard-ing motor function, with each measure ranging from 0 to 4, with 4 being the highest
(normal function) and0 being no function.
ALSFRS-R is a modified version of the ALSFRS. Whereas in the ALSFRS there are 10 assessments, in theALSFRS-R one of the assessments, Q10 (respiratory function) was further divided into three questions (Dysp-nea, Orthopnea, Respiratory Insufficiency) to better reflect the importance (weighting) of respiratory changeswithin the scale.
Q10 score has been calculated where missing as the mean of R1, R2 and R3 scores when available; every scorehas been shifted from 0-4 to 1-5, setting to 0 all of missing values; finally Total scores have been recalculated.

Forced Vital Capacity
Forced vital capacity is the volume of air that can forcibly be blown out after full inspiration,measured in liters.
For somepatients the FVC was measured only once (at a given time), while for others was measured more than once(max 3 trials).
A column with FVC mean relative to the carried out tests has been created, together with a column containingmean percentage of normal values.

Weight and Height
The dataset WeightHeight_RP.csv contains information about height and weight, and BMI, which is considereda relevant indicator of health conditions in ALS patients.
 For these patients, the variable Final_Weight is available by transformingpounds into kilograms, and the variable BMI (body mass index) was built. Nonetheless, for most of the cases,the unit of measurement is missing.
 As for the height, Final_height reports the final height (in cm). Finally theBMI is reported for each patient (weight in kg / (height in cm)2).
Only Final measurements have been considered.

Laboratory Data
Laboratory data contains results of 143 different tests (Albumin, Lymphocite, Basophil and Eosinophil Count,Creatinine, Glucose, Lactic Acid, Protein, Uric Acid, ... ) that have been carried out during the trial and therespective date in which they were taken.
Since Laboratory Data was very huge and there were a lot of missing values, only Albumin results in g/L wereconsidered in this analysis. The choice was made considering the fact that in other studies it has been noteda correlation between Albumin and ALS outcome in both sexes (better survival with increasing levels).

Death
Finally, for some patients, time of death is available- in the file Death Report- whether the subject died (SubjectDied) while monitored and if Yes, time measured in days from trial onset (Death Days).

Censored Data and final dataset
First of all, it has been searched among all PRO-ACT the date of the last visit for each patient in order tocollect censored data, necessary for the subsequent analysis.Then two different dataset have been assembled: one containing only information recorded at Time 0, theother containing time varying data. Both of them have been assembled by merging as much as possible afore-mentioned variables by subject and - for the time dependent one - by time. Finally, all rows of both datasetcontaining missing values have been filtered out, thus creating two homogeneous dataset of: Time0: 1494 patients, 1494 rows, 145 variables ; Time dependent: 1065 patients, 6069 rows, 36 variables.
