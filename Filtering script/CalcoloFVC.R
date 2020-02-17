################### CALCOLO DELL FVC LA' DOVE FVC NON C'E'################### 
rm(list=ls())
data=read.csv("MERGED_NEW.csv",header=TRUE)
N=dim(data)[1]
for(i in 1 : N ) {
  if ( is.na(data$Subject_Normal[i])== TRUE && !is.na(data$Age[i])==TRUE && !is.na(data$Sex[i])==TRUE && !is.na(data$Final_Height[i])==TRUE){
    if (data$Sex[i]==0) { 
      if(data$Age[i]<65) { data$Subject_Normal[i]=0.0454*data$Final_Height -0.0211*data$Age - 2.8253 }
      if(data$Age[i]>=65) { 
        bsa=data$Final_Height[i] * data$Final_Weight[i]/7200
        data$Subject_Normal[i]=0.0003171*data$Final_Height^2 - 0.0351*data$Age - 6.368*bsa + 0.05925*data$Final_Weight + 3.960}
    }
    if(data$Sex[i]==1) {
      if(data$Age[i]<65) {data$Subject_Normal[i]=0.0678*data$Final_Height - 0.0147*data$Age - 6.0548}
      if(data$Age[i]>=65) {data$Subject_Normal[i]=0.0001572*data$Final_Height^2-0.00000268*data$Age^3+ 0.223}
    }
  }
}