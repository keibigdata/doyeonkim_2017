install.packages(c("KoNLP","arules","igraph","combinat"))
library(KoNLP)
library(arules)
library(igraph)
library(combinat)
setwd("D:/Users/KEI/Desktop/ProcessList_file")

rule<-file("1993_2002.txt")
rules<-readLines(rule)
close(rule)
head(rules,10)

tran<-Map(extractNoun, rules)
tran<-unique(tran)
tran <- sapply(tran, unique)
tran <- sapply(tran, function(x) {Filter(function(y) {nchar(y) <= 4 && nchar(y) > 1 && is.hangul(y)},x)})
tran<-Filter(function(x){length(x)>=2},tran)
tran

names(tran) <- paste("Tr", 1:length(tran), sep="")
wordtran <- as(tran, "transactions")
wordtab <- crossTable(wordtran)
wordtab

ares <- apriori(wordtran, parameter=list(supp=0.01, conf=0.01)) #지지도와 신뢰도를 낮게 설정할수록 결과 자세히 나옴
inspect(ares)
rules <- labels(ares, ruleSep=" ")
rules <- sapply(rules, strsplit, " ",  USE.NAMES=F)
rulemat <- do.call("rbind", rules)
ruleg <- graph.edgelist(rulemat[c(1:700),],directed=F) #1~15번째는 다른 단어들간의 연관관계가 아니기 때문에 제외
plot.igraph(ruleg, vertex.label=V(ruleg)$name, vertex.label.cex=0.5, vertex.size=20,layout=layout.fruchterman.reingold.grid)

#### 단어근접중심성파악 ####
  
closen <- closeness(ruleg)
#closen <- closen[c(2:8)] # {} 항목제거
closen <- closen[c(1:10)] # 상위 1~10 단어 근접중심성 보기

plot(closen, col="red",xaxt="n", lty="solid", type="b", xlab="단어", ylab="closeness")
points(closen, pch=16, col="navy")
axis(1, seq(1, length(closen)), V(ruleg)$name[c(1:10)], cex=5)


#### node(vertex), link(edge) 크기 조절 (복잡) ####

V(ruleg)$size<-degree(ruleg)/0.4
condition<-V(ruleg)[degree(ruleg)<0.4]
ruleg1<-delete.vertices(ruleg, condition)
E(ruleg1)$color<-ifelse(E(ruleg1)$grade>=1, "red", "gray")
set.seed(1001)
plot(ruleg1)

#### node(vertex), link(edge) 크기 조절 (단순) ####
ruleg<-simplify(ruleg)
head(sort(degree(ruleg), decreasing=T))
head(sort(closeness(ruleg), decreasing=T))
head(sort(betweenness(ruleg), decreasing=T))
set.seed(1001)
plot(ruleg)

#### 매개중심성 #### 
btw<-betweenness(ruleg)
btw.score<-round(btw)+1
btw.colors<-rev(heat.colors(max(btw.score)))
V(ruleg)$color<-btw.colors[btw.score]
#V(ruleg)$degree<-degree(ruleg)
#V(ruleg)$label.cex<-2*(V(ruleg)$degree / max(V(ruleg)$degree))
plot(ruleg)
