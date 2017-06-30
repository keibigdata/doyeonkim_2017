##################################################################
# KEI 연구보고서 Topic clustering (LDA)
##################################################################
rm(list=ls())
# 필요한 packages 설치
install.packages("topicmodels")
install.packages("LDAvis")
install.packages("servr")
install.packages("readr")
install.packages("tm")
install.packages("slam")
install.packages("dplyr")

library(topicmodels)
library(LDAvis)
library(servr)
library(readr)
library(tm)
library(slam)
library(dplyr)

#형태소 분석기 실행
system("tctStart")
#분석 결과 가져오기
parsedData =read_csv("C:/TextConvert4TM_v1.0/output/out_Test_kei.csv")
parsedData
#컬럼명 변경하기
colnames(parsedData) = c("id","pContent")

## 단어간 스페이스 하나 더 추가하기 ##
parsedDataRe = parsedData
parsedDataRe$pContent = gsub(" ","  ",parsedDataRe$pContent)

##################################################################
#Text Pre-processing
##################################################################
#Corpus 생성
corp<-VCorpus(VectorSource(parsedDataRe$pContent))
#특수문자 제거
corp <- tm_map(corp, removePunctuation)
#소문자로 변경
#corp <- tm_map(corp, tolower)
#특정 단어 삭제
corp <- tm_map(corp, removeWords, c("전략", "연구", "평가", "마련", "조사", "관리", "보다", "분석", "구축"))
#동의어 처리
#for (j in seq(corp))
#{
#  corp[[j]] <- gsub("kei", "한국환경정책평가연구원", corp[[j]])
#}
##################################################################

#Document Term Matrix 생성 (단어 Length는 2로 세팅)
dtm<-DocumentTermMatrix(corp, control=list(removeNumbers=FALSE, wordLengths=c(2,Inf)))
## 한글자 단어 제외하기 ##
colnames(dtm) = trimws(colnames(dtm))
dtm = dtm[,nchar(colnames(dtm)) > 1]
#Sparse Terms 삭제
dtm <- removeSparseTerms(dtm, as.numeric(0.997))
dtm
##Remove low tf-idf col and row
term_tfidf <- tapply(dtm$v/row_sums(dtm)[dtm$i], dtm$j, mean) * log2(nDocs(dtm)/col_sums(dtm > 0))
new_dtm <- dtm[,term_tfidf >= 0]
new_dtm <- new_dtm[row_sums(new_dtm)>0,]

############################################
## Running LDA
############################################
SEED = 2017
k = 5

#LDA 실행
lda_tm <- LDA(new_dtm, control=list(seed=SEED), k)

#토픽별 핵심단어 저장하기
term_topic <- terms(lda_tm, 150)

#토픽별 핵심 단어 파일로 출력하기
filePathName = paste("D:/Users/KEI/Desktop/term_topic.csv",sep="")
write.table(term_topic, filePathName, sep=",", row.names=FALSE)

#문서별 토픽 번호 저장하기
doc_topic <- topics(lda_tm, 1)
doc_topic_df <- as.data.frame(doc_topic)
doc_topic_df$rown <- as.numeric(row.names(doc_topic_df))

#문서별 토픽 확률값 계산하기
doc_Prob <- posterior(lda_tm)$topics
doc_Prob_df <- as.data.frame(doc_Prob)
filePathName = paste("D:/Users/KEI/Desktop/doc_prob_df.csv",sep="")
write.table(doc_Prob_df, filePathName, sep=",", row.names=FALSE)

#최대 확률값 찾기
doc_Prob_df$maxProb = apply(doc_Prob_df, 1, max)
filePathName = paste("D:/Users/KEI/Desktop/doc_prob_df_max.csv",sep="")
write.table(doc_Prob_df, filePathName, sep=",", row.names=FALSE)

#문서별 토픽번호 및 확률값 추출하기
doc_Prob_df$rown = doc_topic_df$rown
parsedData$rown = as.numeric(row.names(parsedData))
id_topic <- merge(doc_topic_df, doc_Prob_df, by="rown")
id_topic <- merge(id_topic, parsedData, by="rown", all.y = TRUE)
id_topic <- subset(id_topic,select=c("rown","id","doc_topic","pContent","maxProb"))

#문서별 토픽 번호 및 확률값 출력하기
filePathName = paste("D:/Users/KEI/Desktop/id_topic.csv",sep="")
write.table(id_topic, filePathName, sep=",", row.names=FALSE)

#단어별 토픽 확률값 출력하기
posterior(lda_tm)$terms
filePathName = paste("D:/Users/KEI/Desktop/lda_tm.csv",sep="")
write.table(posterior(lda_tm)$terms, filePathName, sep=",", row.names=FALSE)

#########################################
## Make visualization
#########################################

# phi는 각 단어별 토픽에 포함될 확률값 입니다.
phi <- posterior(lda_tm)$terms %>% as.matrix
# theta는 각 문서별 토픽에 포함될 확률값 입니다.
theta <- posterior(lda_tm)$topics %>% as.matrix
# vocab는 전체 단어 리스트 입니다.
vocab <- colnames(phi)

# 각 문서별 문서 길이를 구합니다.
doc_length <- vector()
doc_topic_df<-as.data.frame(doc_topic)

for( i in as.numeric(row.names(doc_topic_df))){
  temp <- corp[[i]]$content
  doc_length <- c(doc_length, nchar(temp[1]))
}

# 각 단어별 빈도수를 구합니다.
new_dtm_m <- as.matrix(new_dtm)
freq_matrix <- data.frame(ST = colnames(new_dtm_m),
                          Freq = colSums(new_dtm_m))

# 위에서 구한 값들을 파라메터 값으로 넘겨서 시각화를 하기 위한 데이터를 만들어 줍니다.
source("D:/Users/KEI/Desktop/createNamJson_v2.R")
json_lda <- createNamJson(phi = phi, theta = theta,
                          vocab = vocab,
                          doc.length = doc_length,
                          term.frequency = freq_matrix$Freq,
                          #mds.method = jsPCA
                          mds.method = canberraPCA)


# 톰캣으로 보내기
serVis(json_lda, out.dir = paste("C:/apache-tomcat-8.5.13/webapps/","result_",k,sep=""), open.browser = T)

serVis(json_lda, open.browser = TRUE)

serVis(out.dir = "C:/apache-tomcat-8.5.12/webapps/result_5/lda")
