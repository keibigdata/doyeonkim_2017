install.packages("KoNLP")
library(KoNLP)

setwd("D:/Users/KEI/Desktop/Research Report DB Code File List")
gc()

txt<-readLines("topic1.txt")
data2<-sapply(txt,extractNoun,USE.NAMES=F)

head(unlist(txt),30)
data3<-unlist(data2)
data3<-Filter(function(x){nchar(x)>=2},data3)
data3<-gsub("\\d+","",data3)
data3<-str_replace_all(data3,"[^[:alpha:]]","")
data3<-gsub(" ","",data3)
data3<-gsub("-","",data3)

write(unlist(data3),"extraction.txt")
rev<-read.table("extraction.txt")
nrow(rev)
wordcount<-table(rev)
aa<-head(sort(wordcount,decreasing=T),5000)
write.csv(aa,"topic1_extraction.csv")