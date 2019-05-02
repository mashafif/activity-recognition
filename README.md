Human Activity Recognition using Smartphone Capstone Project
================

Full Report and Link to the Dataset
-----------------------------------

Full report in html format can be accessed from the following link:

[Full Report for Human Activity Recognition's Capstone Project](https://rawcdn.githack.com/mashafif/activity-recognition/995a5d462a5b0c7c1899b0db489ce4b00e86b320/activity-recognition.html)

Dataset can be downloaded from the following link:

[Human Activitiy Recognition UCI](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)

Introduction
------------

### Background

This project is the capstone project for Introduction to Data Science's Coures from Springboard

### Objectives

The main objective of this project is to explore, visualize, and finally to create machine learning model that is capable to decently classify smartphone users activity based on the smartphones sensors reading data (Accelerometer & Gyroscope).

Human activitiy recognition algorithm is very crucial in mobile application development industry, especially to develop activity based apps such as excercise apps, or even augmented reality based games.

![](smartphone-HAPT.PNG)

### About the Dataset

The database used in this project was collected from the accelerometers and gyroscope from the Samsung Galaxy S Smartphone and was obtained from the UCI Machine Learning Repository below:

[Human Activitiy Recognition UCI](https://d396qusza40orc.cloudfront.net/getdata%2Fprojectfiles%2FUCI%20HAR%20Dataset.zip)

From the readme of this dataset, it is mentioned that the experiments have been carried out with a group of 30 volunteers within an age bracket of 19-48 years. Each person performed six activities (WALKING, WALKING\_UPSTAIRS, WALKING\_DOWNSTAIRS, SITTING, STANDING, LAYING) wearing a smartphone (Samsung Galaxy S II) on the waist. Using its embedded accelerometer and gyroscope, 3-axial linear acceleration and 3-axial angular velocity at a constant rate of 50Hz were captured. The experiments have been video-recorded to label the data manually. The obtained dataset has been randomly partitioned into two sets, where 70% of the volunteers was selected for generating the training data and 30% the test data.

The sensor signals (accelerometer and gyroscope) were pre-processed by applying noise filters and then sampled in fixed-width sliding windows of 2.56 sec and 50% overlap (128 readings/window). This means that 1 row of each dataset represents 1.28 sec of measurement.

The most important files from the database that will be used for this project are as the following:

-   "activity\_labels.txt" - this file was used as reference to label activity numbers' column included in y\_train.txt and y\_test.txt to their corresponding activity name (STANDING, SITTING, LAYING, WALKING, WALKING DOWNSTAIRS, or WALKING UPSTAIRS)

-   "features\_info.txt" - This file contains details of about the variables used on the feature vector mentioned in features.txt.

-   "features.txt" - This file lists the variable names of the 561 variables. Vectors in this files later will be used to name all columns included in x\_test.txt, and x\_train.txt.

-   "subject\_test/train.txt" - This file contains the data for all participants who performed the experiments.

-   "X\_test/train.txt" - This file contains data for all engineered data (not the raw data) from smartphone sensors reading. It has all the feature from "features.txt" (561 variables in total) for each participant performing each activity.

-   "y\_test/train.txt" -This dataset gave assigned number (between 1 and 6) of the activity from which each row of data in the "X-test/train.txt" was derived.

-   Inertial Signals" folder that contains the preprocessed data of the actual sensors reading. Inertial signals consist of the following:

-   Gravitational acceleration data files for x, y and z axes: total\_acc\_x\_train.txt, total\_acc\_y\_train.txt, total\_acc\_z\_train.txt.

-   Body acceleration data files for x, y and z axes: body\_acc\_x\_train.txt, body\_acc\_y\_train.txt, body\_acc\_z\_train.txt.

-   Body gyroscope data files for x, y and z axes: body\_gyro\_x\_train.txt, body\_gyro\_y\_train.txt, body\_gyro\_z\_train.txt.

Conclusion
----------

The results from the report can be summarised as follow:

-   Random forest model is used to classify the activities from the 561 variables of the dataset.
-   The random forest model, which has been tuned with hyperparameters of mtry=24 and ntree = 500, achieved Accuracy of 92.7%, and the Kappa value of 91.2% when applied to the test dataset. Both of the values of accuracy and kappa obtained by above model are cosidered quite high.

-   Our model above also shows the Area Under the Curve (AUC) very close to 1, which indicates that our model is very capable in distinguishing or classifying between classes of activities.

-   Among all 561 variables Time.Body.Acc.correlation.X.Y is the most significant variable.

-   Between Body Acceleration, Body Gravity, and Body Gyroscope, body's gravitational components from accellerometer is the most impactful.

-   Among all engineered variables, Angle and correlations are the most impactful by large margins if compared to the other variables
