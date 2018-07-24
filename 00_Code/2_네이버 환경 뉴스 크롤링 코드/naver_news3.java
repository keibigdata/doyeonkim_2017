package Test1;

import java.util.Random;

import org.jsoup.nodes.Document;

public class naver_news3 {
	// 农费傅 且 林家
	static int PAGE = 1;
	static int YEAR = 2008;
	static int MONTH = 1;
	static int DAY = 1;
	static String DY_URL = "http://news.naver.com/main/list.nhn?sid2=252&sid1=102&mid=shm&mode=LS2D&date=";
	static int MONTH31[] = { 31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31 };
	static int test = 20170531;
	static String str_test = "test String";

	public static void main(String[] args) throws InterruptedException {

		Doni();
	}

	static void Doni() throws InterruptedException {

		naver_news1 cDy = new naver_news1();
		// System.out.println(cDy.cuteDYTime());

		System.out.println("Crawling Start!");

		naver_news2 c_bDY = new naver_news2();

		Document mDYBeauty = null;

		boolean isCheck = true;
		boolean isLeapCheck = false;

		while (isCheck) {

			String strDay = "0";
			String strMonth = "0";

			if (DAY < 10) {

				strDay = "0" + DAY;

				// System.out.println(strDay);
			} else {
				strDay = "" + DAY;
			}

			if (MONTH < 10) {

				strMonth = "0" + MONTH;

				// System.out.println(strMonth);
			} else {
				strMonth = "" + MONTH;
			}

			String sURL = DY_URL + YEAR + strMonth + strDay;

			for (PAGE = 1; PAGE < 99999; PAGE++) {

				// System.out.println("Page = " + PAGE);

				mDYBeauty = c_bDY.DoFristCrawling(sURL + "&page=" + PAGE);
				// System.out.println(DY_URL + YEAR + strMonth + strDay +
				// "&page=" + PAGE);
				c_bDY.DoSecondCrawing(mDYBeauty);
				// c_bDY.DoDoYeonDate(mDYBeauty);

				if (!c_bDY.getCheck()) {
					// System.out.println(c_bDY.getCheck());
					break;
				}
			}
			DAY = DAY + 1;
			Thread.sleep(new Random().nextInt(5) * 100);
			if (MONTH31[MONTH - 1] < DAY) {

				if (isLeapCheck == false) {

					if ((YEAR - 2000) % 4 == 0) {
						DAY = 29;
						isLeapCheck = true;

					} else {
						DAY = 1;
						MONTH = MONTH + 1;
						Thread.sleep(new Random().nextInt(50) * 100);
					}
				} else {
					DAY = 1;
					MONTH = MONTH + 1;
					Thread.sleep(new Random().nextInt(50) * 100);
				}

			}
			if (MONTH > 12) {
				MONTH = 1;
				YEAR = 1 + YEAR;
			}

			String m_compareDay = YEAR + "-" + strMonth + "-" + strDay;

			// System.out.println(cDy.str.replaceAll("[^0-9]","" ));

			// System.out.println(m_compareDay.replaceAll("[^0-9]","" ));

			Integer mDY_DateTime;
			Integer mDY_targetDate;

			// mDY_DateTime = Integer.parseInt(cDy.str.replaceAll("[^0-9]",""
			// ));
			mDY_targetDate = Integer.parseInt(m_compareDay.replaceAll("[^0-9]", ""));

			if (test < mDY_targetDate) {
				isCheck = false;
			}

			// System.out.println("Crawling Complete!");
		}

	}

}
