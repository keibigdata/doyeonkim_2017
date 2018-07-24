package Test1;

import java.io.IOException;
import java.util.ArrayList;

import org.jsoup.Jsoup;
import org.jsoup.nodes.Document;
import org.jsoup.nodes.Element;
import org.jsoup.select.Elements;

public class naver_news2 {
 
	boolean cIS_STOP = false;
	String c_DupleString = "";
	ArrayList<String> mAL_DY = new ArrayList<String>();
	
	naver_news3 omg = new naver_news3();
	
	Document DoFristCrawling(String Naver_URL) {

		try {
			Document Document = Jsoup.connect(Naver_URL).get();

			//System.out.println("Page Parsing...");
			return Document;

		} catch (IOException e) {
			System.out.println("페이지 연결 오류");
			e.printStackTrace();
			return null;
		}

	}

	String DoSecondCrawing(Document mFC_result) {

		cIS_STOP = false;
		
		
		
		Elements dy_Parsing = mFC_result.select("div.list_body.newsflash_body").select("dt").select("a");

		String mDY_title = null;
		int mCheckNum = 1;

		for (Element mDY_element : dy_Parsing) {

			if (mDY_element.text().length() > 1 && !mDY_element.text().contains("동영상기사")) {
				//System.out.println(mDY_element.text() +" cnt : "+mCheckNum);

				mDY_title = mDY_element.text();
				mAL_DY.add(mDY_title);
				mCheckNum++;
			}
		}
		
		DoDoYeonDate(mFC_result);
	
		DoPageCheck(mCheckNum,mDY_title);

		return mDY_title;

	}	
	
	String DoDoYeonDate(Document mFC_result) {
		
		Elements dy_Parsing = mFC_result.select("div.list_body.newsflash_body").select("dd");
		
		//System.out.println(dy_Parsing);
		
		int i =0;
		for (Element mDY_date_element : dy_Parsing.select("span.date")) {
			//System.out.println(mDY_date_element);
			
			if (mDY_date_element.text().length() > 1) {
				//System.out.println(mDY_date_element.select("span.date").text());
				
				//System.out.println(i);
			}
		}	
		
		for (Element mDY_writing_element : dy_Parsing) {
			
			//System.out.println(mDY_date_element);
		//	if (mDY_date_element.text().length() > 1) {
			System.out.print(mAL_DY.get(i)+"\t\t");
			System.out.print(mDY_writing_element.select("span.date").text()+"\t");	
			System.out.println(mDY_writing_element.select("span.writing").text()+"\t"+i);
				i++;			
				
				//System.out.println(i);
			//}
						
		}	
		mAL_DY.clear();
		return null;		
	}

	void DoPageCheck(int tNum,String tDuple) {
		
		
		if (tNum == 21 && c_DupleString.length() != tDuple.length()) {
			c_DupleString = tDuple;
			//System.out.println("Next");
			cIS_STOP = true;
		} else if(c_DupleString == tDuple){
			//System.out.println("Stop");
			cIS_STOP = false;
			c_DupleString ="";
		}

	}

	boolean getCheck() {
		return cIS_STOP;

	}
	
	

}
