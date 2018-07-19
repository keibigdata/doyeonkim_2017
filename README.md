# 환경관련 연구 및 뉴스기사 동향 비교 분석

> - 본 연구는 한국환경정책·평가연구원(KEI)에서 제공하는 연구보고서와 네이버뉴스에서 제공하는 환경뉴스 데이터에 텍스트 마이닝(Text Mining) 기법을 적용하여 환경관련 연구 동향을 분석하는 연구입니다.

본 repository에서 제공하는 code 및 data에 대한 설명은 다음과 같습니다.

## Code
**1. 전처리 및 텍스트 마이닝 분석 코드**
* Keyword_Extraction.R: 본문에서 단어 출현빈도가 많은 순으로 단어와 빈도수 추출
* Association_Analysis.R: 단어근접중심성과 단어 연관성분석, 단어 네트워크 시각화분석 
* topic_clustering.R: LDA 기반 Topic clustering
* TextMiningStudy_ch1.R: 1. 형태소분석기 수행 2. Text Pre-processing 3. Document Term Matrix 만들기 
                         4. 불필요한 단어 삭제 5. 단어 빈도 시각화
* word2vec.R:word2vec 연관키워드 추출

**2. 네이버 환경 뉴스 크롤링 코드(아래 3개 코드 동시에 실행)**
* naver_news1.java : 네이버 환경뉴스 크롤링
* naver_news2.java : 네이버 환경뉴스 크롤링
* naver_news3.java : 네이버 환경뉴스 크롤링

**3. 특정 날짜 및 키워드 관련 뉴스 크롤링 코드**
* naver_keyword.java : BASE_URL_DATE1 과 BASE_URL_DATE2 (기간 입력), BASE_URL_WORD (키워드 입력)

## Data
**1. crawling data**
* Kei_db.xlsx : KEI 연구보고서 데이터 (1993~2016년, 1522건, 제목/목차or초록/날짜/저자/연구분류)
* Naver_news.xlsx : 네이버 환경뉴스 데이터(2004~2016년, 19만건, 제목/날짜/언론사)

**2. 전처리 완료된 data**
* kei_content_data.csv : 한국환경정책·평가연구원(KEI) 연구보고서 1993~2016년, 목차&초록)
* naver_title_data.csv : 네이버 환경뉴스 (2004~2016년, 제목)
