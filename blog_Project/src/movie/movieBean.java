package movie;

import java.sql.Date;

public class movieBean {
	private int movie_id; //영화 고유넘버
	private String movie_title; //영화제목
	private String movie_eng_title; //영화 영제목 (생략가능)
	private String movie_genre; //영화장르
	private int movie_like_count; //영화 좋아요~ count
	private String movie_director; //영화 감독
	private String movie_cast; //영화 주연,조연 배우
	private String movie_basic; //기본설명 (나이, 시간, 제작날자)
	private int movie_age; // 나이제한
	private String movie_explanation; //영화설명
	private Date movie_add_date; //작성일
	private Date release_date; //개봉일
	private Date close_date; //영화종료일시
	private String movie_image_name; //영화 이미지
	private String movie_image_path; //영화 이미지 경로
	private String movie_image_orgname; //영화 이미지 원본이름(중복시)
	private int theater_no; // 상영관 번호
	
	public int getMovie_id() {
		return movie_id;
	}
	public void setMovie_id(int movie_id) {
		this.movie_id = movie_id;
	}
	public String getMovie_title() {
		return movie_title;
	}
	public void setMovie_title(String movie_title) {
		this.movie_title = movie_title;
	}
	public String getMovie_eng_title() {
		return movie_eng_title;
	}
	public void setMovie_eng_title(String movie_eng_title) {
		this.movie_eng_title = movie_eng_title;
	}
	public String getMovie_genre() {
		return movie_genre;
	}
	public void setMovie_genre(String movie_genre) {
		this.movie_genre = movie_genre;
	}
	public int getMovie_like_count() {
		return movie_like_count;
	}
	public void setMovie_like_count(int movie_like_count) {
		this.movie_like_count = movie_like_count;
	}
	public String getMovie_director() {
		return movie_director;
	}
	public void setMovie_director(String movie_director) {
		this.movie_director = movie_director;
	}
	public String getMovie_cast() {
		return movie_cast;
	}
	public void setMovie_cast(String movie_cast) {
		this.movie_cast = movie_cast;
	}
	public String getMovie_basic() {
		return movie_basic;
	}
	public void setMovie_basic(String movie_basic) {
		this.movie_basic = movie_basic;
	}
	public int getMovie_age() {
		return movie_age;
	}
	public void setMovie_age(int movie_age) {
		this.movie_age = movie_age;
	}
	public String getMovie_explanation() {
		return movie_explanation;
	}
	public void setMovie_explanation(String movie_explanation) {
		this.movie_explanation = movie_explanation;
	}
	public Date getMovie_add_date() {
		return movie_add_date;
	}
	public void setMovie_add_date(Date movie_add_date) {
		this.movie_add_date = movie_add_date;
	}
	public void setRelease_date(Date release_date) {
		this.release_date = release_date;
	}
	public Date getRelease_date() {
		return release_date;
	}
	public Date getClose_date() {
		return close_date;
	}
	public void setClose_date(Date close_date) {
		this.close_date = close_date;
	}
	public String getMovie_image_name() {
		return movie_image_name;
	}
	public void setMovie_image_name(String movie_image_name) {
		this.movie_image_name = movie_image_name;
	}
	public String getMovie_image_path() {
		return movie_image_path;
	}
	public int getTheater_no() {
		return theater_no;
	}
	public void setTheater_no(int theater_no) {
		this.theater_no = theater_no;
	}
	public void setMovie_image_path(String movie_image_path) {
		this.movie_image_path = movie_image_path;
	}
	public String getMovie_image_orgname() {
		return movie_image_orgname;
	}
	public void setMovie_image_orgname(String movie_image_orgname) {
		this.movie_image_orgname = movie_image_orgname;
	}
	
	
}
