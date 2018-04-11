package Test1;

import java.io.IOException; //입출력 에러가 났을때  예외처리를 하겠다는 뜻
import java.net.URLEncoder;
import org.jsoup.Connection;
import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.select.Elements;
import org.jsoup.nodes.Element; //Jsoup을 사용하기위해 선언해준다.

public class Naver_news {

	static String BASE_URL_DATE1 = "2015.01.01&de=2016.11.30"; // 날짜1
	static String BASE_URL_DATE2 = "20150101to20161130"; // 날짜2
	static String BASE_URL_WORD = "미세먼지"; // 키워드

	static int BASE_URL_PAGE = 1; // 페이지를 변경하기 위한 변수
	public static void main(String[] args) throws IOException, InterruptedException {
		String Encoding_Word = URLEncoder.encode(BASE_URL_WORD, "UTF-8");
		String BASE_URL_F = "https://search.naver.com/search.naver?where=news&se=0&query=" + Encoding_Word
+ "&ie=utf8&sm=tab_opt&sort=0&photo=0&field=0&reporter_article=&pd=3&ds=" + BASE_URL_DATE1
+ "&docid=&nso=so%3Ar%2Cp%3Afrom" + BASE_URL_DATE2 + ",a:all&mynews=0&cluster_rank=16&start=";

		String COMPLETE_URL = BASE_URL_F + BASE_URL_PAGE; // 완성된 url

		int page = 1;
		int cnt = 1;
		while (page <= 4001) {
			System.out.println("URL " + COMPLETE_URL);

			Document naver_news = Jsoup.connect(COMPLETE_URL).header("Accept", "text/html, application/xhtml+xml, */*")
.header("User-Agent", "Mozilla/5.0 (Windows NT 6.1; WOW64; Trident/7.0; rv:11.0) like Gecko")
.header("Accept-Encoding", "gzip, deflate")
.header("Accept-Language", "ko-KR")
.header("Connection", "Keep-Alive").get();

			Elements news_url = naver_news.select("a._sp_each_url");

			for (Element element : news_url) {
				String url = element.attr("href");
				if (url.contains("sports.news.naver.com")) {
					Document doc = Jsoup.connect(url).get();
				} else if (url.contains("news.naver.com")) {

					Document doc = Jsoup.connect(url).get();

					Elements body = doc.select("div#articleBodyContents");
					Elements title = doc.select("h3#articleTitle");
					Elements company = doc.select("span.t11");
					
					String str = body.text();
					System.out.println("본문 : " + str);
					System.out.println("제목 : " + title.text());
					System.out.println("출처 : " + company.text());
				}
			}

			System.out.println("페이지 : " + page + "======================");
			page = page + 10; // 네이버뉴스는 페이지가 10씩 올라가므로 10을 더해줌
			cnt++;

			if (cnt % 10 == 0) {
				System.out.println("조금쉴게요");
				Thread.sleep(10000);
			}
			BASE_URL_PAGE = page;
			COMPLETE_URL = BASE_URL_F + BASE_URL_PAGE;
		}
	}
}