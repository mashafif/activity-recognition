library(dplyr)
library(stringr)

#Loading the measurement data set
x_test<-read.table("test/X_test.txt")
#Loading the dataset for activity labels
y_test<-data.frame(ActivityLabel=read.table("test/Y_test.txt"))

#Loading the feature name for each column
label<-read.table("features.txt")

#correct the label dataset, so it can be used to name the measurement data set "x_test"
true_label<-make.names(label[,2],unique=TRUE)
true_label
which(duplicated(true_label))

#Add name to the measurement data set
x_test<-setNames(x_test,true_label)

#Add new columns which contain the mean, and standard deviation of each row
x_test<-x_test%>% mutate(average.val=rowMeans(.,na.rm=TRUE),
                         std.dev=apply(.,1,sd))
x_test%>%select(average.val,std.dev)

#Converting the activity label to activity name
y_test<-setNames(y_test,"ActivityLabel")
y_test<-y_test %>% mutate(ActivityName=case_when(ActivityLabel==1~"WALKING",
                                          ActivityLabel==2~"WALKING_UPSTAIRS",
                                          ActivityLabel==3~"WALKING_DOWNSTAIRS",
                                          ActivityLabel==4~"SITTING",
                                          ActivityLabel==5~"STANDING",
                                          ActivityLabel==6~"LAYING")) 

#Combining both measurement data set to its activity label dataset
human.activity<-cbind(x_test2,y_test2)

