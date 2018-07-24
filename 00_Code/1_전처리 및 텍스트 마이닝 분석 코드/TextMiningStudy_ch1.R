
#ch1.R에서 텍스트 처리를 위한 기초 분석

##################################################################
#분석 결과 가져오기
##################################################################
rm(list=ls())

#readr 패키지 설치
install.packages("readr")
library(readr)
#형태소 분석기 실행하기
system("tctStart")
#분석 결과 가져오기
parsedData =read_csv("C:/TextConvert4TM_v1.0/output/out_Test_kei.csv")
parsedData
#컬럼명 변경하기
colnames(parsedData) = c("id","pContent")
View(parsedData)
#단어간 스페이스 하나 더 추가하기
parsedDataRe = parsedData
parsedDataRe$pContent = gsub(" ","  ",parsedDataRe$pContent)

##################################################################
#Text Pre-processing
##################################################################
#tm 패키지 설치
install.packages("tm")
library(tm)
#Corpus 생성
corp<-Corpus(DataframeSource(parsedDataRe))
#특수문자 제거
corp <- tm_map(corp, removePunctuation)
#숫자 삭제
corp <- tm_map(corp, removeNumbers)
#소문자로 변경
#corp <- tm_map(corp, tolower)
#특정 단어 삭제
corp <- tm_map(corp, removeWords, c("전략", "연구", "평가", "마련", "조사", "관리", "보다", "분석", "구축"))
#동의어 처리
for (j in seq(corp))
{
  corp[[j]] <- gsub("kei", "한국환경정책평가연구원", corp[[j]])
  corp[[j]] <- gsub("국책", "국가정책", corp[[j]])
 # corp[[j]] <- gsub("", "", corp[[j]])
 # corp[[j]] <- gsub("", "", corp[[j]])
}
#텍스트문서 형식으로 변환
corp <- tm_map(corp, PlainTextDocument)

##################################################################
#Document Term Matrix
##################################################################
dtm<-DocumentTermMatrix(corp, control=list(removeNumbers=FALSE, wordLengths=c(2,Inf))) #최소 두글자

#Term Document Matirx 생성
#tdm<-TermDocumentMatrix(corp, control=list(removeNumbers=TRUE, wordLengths=c(2,Inf)))

#Sparse Terms 삭제 (발생빈도가 매우 낮은 단어 삭제)
dtm <- removeSparseTerms(dtm, as.numeric(0.97)) #1에 가까울수록 메트릭스 커짐(보통 0.95~0.99 사용함)

#Remove low tf-idf col and row
install.packages("slam") #row_sums, col_sums 사용을 위해 패키지 설치
library(slam)

term_tfidf <- tapply(dtm$v/row_sums(dtm)[dtm$i], dtm$j, mean) * log2(nDocs(dtm)/col_sums(dtm > 0))
new_dtm <-dtm[,term_tfidf >= 0.1]
new_dtm <-new_dtm[row_sums(new_dtm)>0,]

##################################################################
#불필요한 단어 삭제
##################################################################
## windows 버전 ##
dtmM = as.matrix(new_dtm)
colnames(dtmM) = trimws(colnames(dtmM))
dtmM = dtmM[,nchar(colnames(dtmM)) > 1]

#단어 발생 빈도 구하기
freq = colSums(as.matrix(dtmM))
freq
#단어 개수 구하기
length(freq)

#내림차순으로 단어 10개, sorting 하기
freq[head(order(-freq), 10)]

#오름차순으로 단어 10개 sorting 하기
freq[head(order(freq),10)]

#특정 빈도 사이값을 갖는 단어 구하기 (20보다 크고 341보다 작은 단어)
findFreqTerms(dtm, lowfreq = 20, highfreq = 341)

##################################################################
#단어 빈도 시각화
##################################################################
wordDf = data.frame(word=names(freq), freq=freq)

install.packages(c("ggplot2","extrafont"))
library(ggplot2)
library(extrafont)

font_import()
loadfonts(device="postscript")
ggplot(wordDf, aes(x=word, y=freq)) + geom_bar(stat = "identity")

#단어 10개만 바차트로 보여주기
ggplot(head(wordDf,10), aes(x=word, y=freq)) + geom_bar(stat = "identity") + theme(axis.text.x = element_text(family="AppleGothic"))

#워드 클라우드 그리기
install.packages(c("wordcloud","RColorBrewer"))
library(wordcloud)
library(RColorBrewer)

pal<-brewer.pal(9,"Set2")
wordcloud(wordDf$word, wordDf$freq, min.freq =5, colors = pal, 
          rot.per = 0, random.order = F, scale = c(3,1), family="AppleGothic")

#treeMap 그리기
install.packages("treemap")
library(treemap)
treemap(wordDf,
        title = "Word TreeMap",
        index = c("word"), 
        vSize = "freq", 
        type = "index", 
        fontfamily.labels = "AppleGothic", 
        palette="Set2")
