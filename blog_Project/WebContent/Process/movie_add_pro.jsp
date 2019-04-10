<%@page import="java.sql.Date"%>
<%@page import="movie.movieBean"%>
<%@page import="movie.movieDAO"%>
<%@page import="com.oreilly.servlet.multipart.DefaultFileRenamePolicy"%>
<%@page import="java.io.File"%>
<%@page import="java.util.Enumeration"%>
<%@page import="com.oreilly.servlet.MultipartRequest"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>자료실 글쓰기</title>
</head>
<body>
<%
	request.setCharacterEncoding("utf-8");

	String movie_image_path = request.getSession().getServletContext().getRealPath("/movie_files"); // 파일 업로드시 서버에 저장할 경로
	out.println("절대경로 : " + movie_image_path + "<br/>");

	int maxFileSize = 1024 * 1024 * 10; // 용량 제한 10MB로 설정
	
	String movie_image_name = ""; 
	String movie_image_orgname = ""; 
	String fileType = "";
	long fileSize = 0;
	
	// 파일저장경로, 최대 용량, 인코딩, 중복파일명 기본 정책
	MultipartRequest multi = new MultipartRequest(request,movie_image_path,maxFileSize,"utf-8",new DefaultFileRenamePolicy());
	
    try {
    	
    	Enumeration files = multi.getFileNames();
    	
    	while(files.hasMoreElements()){
           	// form 태그에서 <input type="file" name="여기에 지정한 이름" />을 가져온다.
          	String file1 = (String)files.nextElement(); // 파일 input에 지정한 이름을 가져옴
           	// 그에 해당하는 실제 파일 이름을 가져옴
          	movie_image_orgname = multi.getOriginalFileName(file1); // 중복처리되기전 파일명
          	// 파일명이 중복될 경우 중복 정책에 의해 뒤에 1,2,3 처럼 붙어 unique하게 파일명을 생성하는데
            // 이때 생성된 이름을 filesystemName이라 하여 그 이름 정보를 가져온다.(중복에 대한 처리)
            movie_image_name = multi.getFilesystemName(file1);
          	// 파일 타입 정보를 가져옴
           	fileType = multi.getContentType(file1); // 파일의 형식
            // input file name에 해당하는 실제 파일을 가져옴
           	File uploadFile = multi.getFile(file1);
           	// 그 파일 객체의 크기를 알아냄
           	fileSize = uploadFile.length(); 
    	}
    } catch(Exception e) {
        e.printStackTrace();
    }
    	 
    movieDAO mdao = movieDAO.getInstance();
    
    movieBean mb = new movieBean();
    	
    mb.setMovie_genre(multi.getParameter("genre"));
    mb.setMovie_title(multi.getParameter("movie_title"));
    mb.setMovie_eng_title(multi.getParameter("movie_eng_title"));
  	mb.setMovie_like_count(0);
    mb.setMovie_director(multi.getParameter("movie_director"));
    mb.setMovie_cast(multi.getParameter("movie_cast"));
  	mb.setMovie_basic(multi.getParameter("movie_basic"));
    mb.setMovie_age(Integer.parseInt(multi.getParameter("movie_age")));
    mb.setMovie_explanation(multi.getParameter("movie_explanation"));
    mb.setRelease_date(Date.valueOf(multi.getParameter("year") + "-" + multi.getParameter("month") + "-" + multi.getParameter("day")));
    mb.setClose_date(Date.valueOf(multi.getParameter("close_year") + "-" + multi.getParameter("close_month") + "-" + multi.getParameter("close_day")));
    // 이미지파일
  	mb.setMovie_image_name(movie_image_name);
  	mb.setMovie_image_orgname(movie_image_orgname);
  	mb.setMovie_image_path(movie_image_path);
  	
  	mb.setTheater_no(Integer.parseInt(multi.getParameter("theater_no")));
    	
    int result = mdao.movie_add(mb);

    if(result > 0 ) {
    	%><script>
    		alert("글쓰기 완료");
    		location.href='../View/movieList.jsp';
    	</script><%
    } else if (result == 0) {
    	%><script>
    		alert("SQL오류");
    		history.back();
   	    </script><%
    } else {
    	%><script>
    		alert("글쓰기 실패");
    		history.back();
   		</script><%
   	}
     
%>

</body>
</html>