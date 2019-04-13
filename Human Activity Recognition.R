
library(dplyr)
library(stringr)
library(ggplot2)

#Loading the measurement data set
x_train<-read.table("train/X_train.txt")
#Loading the dataset for activity labels
y_train<-data.frame(ActivityLabel=read.table("train/Y_train.txt"))
subject_id<- data.frame(Subject=read.table("train/subject_train.txt"))
subject_id<- setNames(subject_id,"Subject")


#Loading the feature name for each column
label<-read.table("features.txt", col.names=c("id","Name"))

#correct the label dataset, so it can be used to name the measurement data set "x_train"
true_label<-label%>%
            mutate(Feature=make.names(Name,unique=TRUE))%>%
            mutate(Feature=gsub("^f","Frequency.",Feature))%>%
            mutate(Feature=gsub("^t","Time.",Feature))%>%
            mutate(Feature = gsub("^angle", "Angle", Feature)) %>%
            mutate(Feature = gsub("BodyBody", "Body", Feature)) %>%
            mutate(Feature = gsub("Acc", ".Acc", Feature)) %>%
            mutate(Feature = gsub("Gyro", ".Gyro", Feature)) %>%
            mutate(Feature = gsub("Jerk", ".Jerk", Feature)) %>%
            mutate(Feature = gsub("Mag", ".Mag", Feature)) %>%
            mutate(Feature = gsub("\\.{2,}", ".", Feature)) %>%
            mutate(Feature = gsub("\\.+$", "", Feature)) %>%
            select(Feature)%>%
            unlist()
duplicated(true_label)
duplicate<-true_label[duplicated(true_label)]
write.csv(duplicate, file="duplicate.csv")
write.csv(true_label, file="true_label.csv")

#Add name to the measurement data set
x_train<-setNames(x_train,true_label)
write.csv(x_train, file="data.csv")

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
human.activity<-cbind(subject_id,y_train,x_train)
human.activity<-human.activity%>%
                mutate(Overall.ID=as.numeric(row_number()))

human.activity <- human.activity %>% 
                  group_by(ActivityName) %>% 
                  mutate(Activity.ID=row_number()) 
human.activity <- human.activity %>% 
                  group_by(Subject) %>%
                  mutate(Subject.ID=row_number())
human.activity <- human.activity %>%
                  group_by(Subject,ActivityName)%>% 
                  mutate(Subject.Activity.ID=row_number())%>%
                  select(Overall.ID,Subject.ID,Activity.ID,Subject.Activity.ID,everything())

write.csv(human.activity,file="all_traid_data.csv")

minmax.activity<-human.activity%>%
                 group_by(ActivityName)%>%
                 summarize(max.activity=max(Activity.ID))

minmax.subject.activity <-human.activity%>%
                         group_by(Subject, ActivityName)%>%
                         summarize(max.activity=max(Subject.Activity.ID))


#to see the distribution of all activities
ggplot(human.activity, aes(x=ActivityName,fill=ActivityName))+
  geom_bar()+
  theme_bw()+
  theme(legend.position = "none", axis.text.x=element_text(angle=45,hjust=1))+
  labs(title="Distribution of Activities")

#to see the distribution of all activities done by each subject      
ggplot(human.activity, aes(x=Subject,fill=ActivityName))+
  geom_bar()+
  theme_bw()+
  theme(legend.position = "none", axis.text.x=element_text(angle=45,hjust=1))+
  labs(title="Distribution of Activities")


#to see in what order the experiment was performed in term of subject
ggplot(human.activity, aes(x=Overall.ID, y=Subject))+
  geom_line(size=2,color="blue")+
  xlab("Index")+
  ylab("Subject")+
  theme_bw() +
  labs(title="Order of Subject During Experiment")

#to see in what order the experiment was performed in term of activity
ggplot(human.activity, aes(x=Subject.ID, y=ActivityLabel, col=ActivityLabel))+
  geom_line(size=2)+
  scale_color_distiller(palette = "RdPu")+
  facet_wrap(Subject~.,ncol=7)+
  xlab("Index")+
  ylab("Activity Label")+
  theme_bw() +
  labs(title="Order of Activity done by each Subject during Experiment")

#Drawing the Mean of Body Accelration accross all Subjects

human.activity%>%filter(Activity.ID<=min(minmax.activity$max.activity))%>%
ggplot(aes(x=Activity.ID))+
  geom_line(aes(y=Time.Body.Acc.mean.X),color="red")+
  geom_line(aes(y=Time.Body.Acc.mean.Y),color="blue")+
  geom_line(aes(y=Time.Body.Acc.mean.Z),color="green")+
  facet_grid(ActivityName~.)+
  xlab("Index")+
  ylab("Mean Acceleration")+
  theme_bw() +
  theme(strip.text = element_text(size = 4.5))+
  labs(title="Mean of Body Acceleration Plot of All Subjects")
  

#Drawing the SD of Body Acceleration accross all Subjects
human.activity%>%filter(Activity.ID<=min(minmax.activity$max.activity))%>%
  ggplot(aes(x=Activity.ID))+
  geom_line(aes(y=Time.Body.Acc.std.X),color="red")+
  geom_line(aes(y=Time.Body.Acc.std.Y),color="blue")+
  geom_line(aes(y=Time.Body.Acc.std.Z),color="green")+
  facet_grid(ActivityName~.)+
  xlab("Index")+
  ylab("STD Acceleration")+
  theme_bw() +
  theme(strip.text = element_text(size = 4.5))+
  labs(title="Standard Deviation of Body Acceleration Plot of All Subjects")

#As we can see seeing reading across all subjects is not something that is easy to see
#Next will be to explore the sensors reading for only 1 subject = subject no 3
#Body Acceleration Mean of subject no 5 with geom smooth
Subjects <- minmax.subject.activity%>%
                   filter(Subject==5)
Subjects.length<- min(Subjects$max.activity)
Subjects.length
#----------------------------------------Acc Time Series Line---------------------------------------------

#Body Accelration Reading Mean of subject no 5
human.activity%>%filter(Subject==5,Subject.Activity.ID<=Subjects.length)%>%
  ggplot(aes(x=Subject.Activity.ID))+
  geom_line(aes(y=Time.Body.Acc.mean.X),color="red")+
  geom_line(aes(y=Time.Body.Acc.mean.Y),color="blue")+
  geom_line(aes(y=Time.Body.Acc.mean.Z),color="green")+
  facet_grid(ActivityName~.)+
  xlab("Index")+
  ylab("Mean Acceleration")+
  theme_bw() +
  theme(strip.text = element_text(size = 4.5))+
  labs(title="Mean of Body Acceleration Plot of Subject 5")


#Body Accelration Reading SD of subject no 5
human.activity%>%filter(Subject==5,Subject.Activity.ID<=Subjects.length)%>%
  ggplot(aes(x=Subject.Activity.ID))+
  geom_line(aes(y=Time.Body.Acc.std.X),color="red")+
  geom_line(aes(y=Time.Body.Acc.std.Y),color="blue")+
  geom_line(aes(y=Time.Body.Acc.std.Z),color="green")+
  facet_grid(ActivityName~.)+
  xlab("Index")+
  ylab("std Acceleration")+
  theme_bw() +
  theme(strip.text = element_text(size = 4.5))+
  labs(title="Std of Body Acceleration Plot of Subject 5")

#Body Acceleration Magnitude of subject
human.activity%>%filter(Subject==5,Subject.Activity.ID<=Subjects.length)%>%
  ggplot(aes(x=Subject.Activity.ID))+
  geom_line(aes(y=Time.Body.Acc.Mag.mean),color="purple")+
  facet_grid(ActivityName~.)+
  xlab("Index")+
  ylab("std Acceleration")+
  theme_bw() +
  theme(strip.text = element_text(size = 4.5))+
  labs(title="Std of Body Acceleration Plot of Subject 5")

#----------------------------------------Gyro Time Series Line---------------------------------------------

#Body Gyroscope Reading Mean of subject no 5
human.activity%>%filter(Subject==5,Subject.Activity.ID<=Subjects.length)%>%
  ggplot(aes(x=Subject.Activity.ID))+
  geom_line(aes(y=Time.Body.Gyro.mean.X),color="red")+
  geom_line(aes(y=Time.Body.Gyro.mean.Y),color="blue")+
  geom_line(aes(y=Time.Body.Gyro.mean.Z),color="green")+
  facet_grid(ActivityName~.)+
  xlab("Index")+
  ylab("Mean Gyroscope")+
  theme_bw() +
  theme(strip.text = element_text(size = 4.5))+
  labs(title="Mean of Body Gyroscope Plot of Subject 5")


#Body Gyroscope Reading SD of subject no 5
human.activity%>%filter(Subject==5,Subject.Activity.ID<=Subjects.length)%>%
  ggplot(aes(x=Subject.Activity.ID))+
  geom_line(aes(y=Time.Body.Gyro.std.X),color="red")+
  geom_line(aes(y=Time.Body.Gyro.std.Y),color="blue")+
  geom_line(aes(y=Time.Body.Gyro.std.Z),color="green")+
  facet_grid(ActivityName~.)+
  xlab("Index")+
  ylab("std Gyroscope")+
  theme_bw() +
  theme(strip.text = element_text(size = 4.5))+
  labs(title="Std of Body Gyroscope Plot of Subject 5")

#Body Gyroscope Magnitude of subject
human.activity%>%filter(Subject==5,Subject.Activity.ID<=Subjects.length)%>%
  ggplot(aes(x=Subject.Activity.ID))+
  geom_line(aes(y=Time.Body.Gyro.Mag.mean),color="purple")+
  facet_grid(ActivityName~.)+
  xlab("Index")+
  ylab("std Gyroscope")+
  theme_bw() +
  theme(strip.text = element_text(size = 4.5))+
  labs(title="Std of Body Gyroscope Plot of Subject 5")


#----------------------------------------Gyro Time Series Line---------------------------------------------

#Body Gravity Reading Mean of subject no 5
human.activity%>%filter(Subject==5,Subject.Activity.ID<=Subjects.length)%>%
  ggplot(aes(x=Subject.Activity.ID))+
  geom_line(aes(y=Time.Gravity.Acc.mean.X),color="red")+
  geom_line(aes(y=Time.Gravity.Acc.mean.Y),color="blue")+
  geom_line(aes(y=Time.Gravity.Acc.mean.Z),color="green")+
  facet_grid(ActivityName~.)+
  xlab("Index")+
  ylab("Mean Gravity")+
  theme_bw() +
  theme(strip.text = element_text(size = 4.5))+
  labs(title="Mean of Body Gravity Plot of Subject 5")


#Body Gravity Reading SD of subject no 5
human.activity%>%filter(Subject==5,Subject.Activity.ID<=Subjects.length)%>%
  ggplot(aes(x=Subject.Activity.ID))+
  geom_line(aes(y=Time.Gravity.Acc.std.X),color="red")+
  geom_line(aes(y=Time.Gravity.Acc.std.Y),color="blue")+
  geom_line(aes(y=Time.Gravity.Acc.std.Z),color="green")+
  facet_grid(ActivityName~.)+
  xlab("Index")+
  ylab("std Gravity")+
  theme_bw() +
  theme(strip.text = element_text(size = 4.5))+
  labs(title="Std of Body Gravity Plot of Subject 5")

#Body Gravity Magnitude of subject
human.activity%>%filter(Subject==5,Subject.Activity.ID<=Subjects.length)%>%
  ggplot(aes(x=Subject.Activity.ID))+
  geom_line(aes(y=Time.Gravity.Acc.Mag.mean),color="purple")+
  facet_grid(ActivityName~.)+
  xlab("Index")+
  ylab("std Gravity")+
  theme_bw() +
  theme(strip.text = element_text(size = 4.5))+
  labs(title="Std of Body Gravity Plot of Subject 5")


#----------------------------------------Histogram Accelerator Time Series---------------------------------------------

#Histogram Body Acceleration Magnitude of All Subjects
human.activity%>%filter(Activity.ID<=min(minmax.activity$max.activity))%>%
  ggplot()+
  geom_histogram(binwidth=0.05,aes(x=Time.Body.Acc.mean.X),fill="red", alpha=0.6)+
  geom_histogram(binwidth=0.05,aes(x=Time.Body.Acc.mean.Y),fill="blue",alpha=0.6)+
  geom_histogram(binwidth=0.05,aes(x=Time.Body.Acc.mean.Z),fill="green",alpha=0.6)+
  facet_grid(ActivityName~.)+
  theme_bw() +
  theme(strip.text = element_text(size = 4.5))+
  xlab("Index")+
  ylab("Acceleration Reading")+
  labs(title="Mean of Body Acceleration Reading Plot")


#----------------------------------------Histogram Gyroscope Time Series---------------------------------------------

#Histogram Body Gyroscope Magnitude of All Subjects
human.activity%>%filter(Activity.ID<=min(minmax.activity$max.activity))%>%
  ggplot()+
  geom_histogram(binwidth=0.05,aes(x=Time.Body.Gyro.mean.X),fill="red", alpha=0.6)+
  geom_histogram(binwidth=0.05,aes(x=Time.Body.Gyro.mean.Y),fill="blue",alpha=0.6)+
  geom_histogram(binwidth=0.05,aes(x=Time.Body.Gyro.mean.Z),fill="green",alpha=0.6)+
  facet_grid(ActivityName~.)+
  theme_bw() +
  theme(strip.text = element_text(size = 4.5))+
  xlab("Index")+
  ylab("Acceleration Reading")+
  labs(title="Mean of Body Gyroscope Reading Plot")


#----------------------------------------Histogram Gravity Reading Time Series---------------------------------------------

#Histogram Body Gravity Magnitude of All Subjects
human.activity%>%filter(Activity.ID<=min(minmax.activity$max.activity))%>%
  ggplot()+
  geom_histogram(binwidth=0.05,aes(x=Time.Gravity.Acc.mean.X),fill="red", alpha=0.6)+
  geom_histogram(binwidth=0.05,aes(x=Time.Gravity.Acc.mean.Y),fill="blue",alpha=0.6)+
  geom_histogram(binwidth=0.05,aes(x=Time.Gravity.Acc.mean.Z),fill="green",alpha=0.6)+
  facet_grid(ActivityName~.)+
  theme_bw() +
  theme(strip.text = element_text(size = 4.5))+
  xlab("Index")+
  ylab("Acceleration Reading")+
  labs(title="Mean of Body Gravity Reading Plot")


