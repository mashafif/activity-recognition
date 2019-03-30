
library(dplyr)
library(stringr)
library(ggplot2)


#Loading the measurement data set
x_train<-read.table("train/X_train.txt")
#Loading the dataset for activity labels
y_train<-data.frame(ActivityLabel=read.table("train/Y_train.txt"))

#Loading the feature name for each column
label<-read.table("features.txt")

#correct the label dataset, so it can be used to name the measurement data set "x_train"
true_label<-make.names(label[,2],unique=TRUE)
write.csv(true_label, file="true_label.csv")

#Add name to the measurement data set
x_train<-setNames(x_train,true_label)

#Converting the activity label to activity name
y_train<-setNames(y_train,"ActivityLabel")
y_train<-y_train %>% mutate(ActivityName=case_when(ActivityLabel==1~"WALKING",
                                          ActivityLabel==2~"WALKING_UPSTAIRS",
                                          ActivityLabel==3~"WALKING_DOWNSTAIRS",
                                          ActivityLabel==4~"SITTING",
                                          ActivityLabel==5~"STANDING",
                                          ActivityLabel==6~"LAYING"))

y_train$ActivityName<- as.factor(y_train$ActivityName)
                    

#Combining both measurement data set to its activity label dataset
human.activity<-cbind(x_train,y_train)
human.activity$index<-as.numeric(row.names(human.activity))

#Create new data set that only consists of angle() variables
gravity.Mean<-human.activity%>% select(index,ActivityName,contains("gravityMean"))
write.csv(gravity.Mean,file="gravity_Mean.csv")
