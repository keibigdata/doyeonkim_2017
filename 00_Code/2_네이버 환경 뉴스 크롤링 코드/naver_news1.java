package Test1;

import java.text.SimpleDateFormat;
import java.util.Date;

public class naver_news1 {

	String str = "";
	
	String Time() {
		
		long time = System.currentTimeMillis(); 

		SimpleDateFormat dayTime = new SimpleDateFormat("yyyy-MM-dd");

		str = dayTime.format(new Date(time));
		//System.out.println(str);
		
		return str;
		
	}
	
	public String getDYTime() {
		Time();
		return str;
	}
	
}
