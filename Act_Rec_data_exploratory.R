library(dplyr)
library(stringr)
library(ggplot2)
library(quantreg)

#Loading the data gravity dataset
gravityMean<-read.csv("gravity_Mean.csv")
str(gravityMean)


ggplot(gravityMean, aes(x=index, y=angle.tBodyAccJerkMean..gravityMean.,col=ActivityName))+
 geom_smooth(method="lm")+
  facet_grid(.~ActivityName)

ggplot(gravityMean, aes(x=index, y=angle.tBodyGyroMean.gravityMean.,col=ActivityName))+
  geom_smooth(method="lm")+
  facet_grid(.~ActivityName)

ggplot(gravityMean, aes(x=index, y=angle.tBodyGyroJerkMean.gravityMean.,col=ActivityName))+
  geom_smooth(method="lm")+
  facet_grid(.~ActivityName)

ggplot(gravityMean, aes(x=index, y=angle.X.gravityMean.,col=ActivityName))+
  geom_smooth(method="lm")+
  facet_grid(.~ActivityName)

ggplot(gravityMean, aes(x=index, y=angle.Y.gravityMean.,col=ActivityName))+
  geom_smooth(method="lm")+
  facet_grid(.~ActivityName)

ggplot(gravityMean, aes(x=index, y=angle.Z.gravityMean.,col=ActivityName))+
  geom_smooth(method="lm")+
  facet_grid(.~ActivityName)



