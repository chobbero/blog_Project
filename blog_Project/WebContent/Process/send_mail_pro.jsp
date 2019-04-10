<%@page import="javax.mail.MessagingException"%>
<%@page import="javax.mail.Transport"%>
<%@page import="javax.mail.internet.InternetAddress"%>
<%@page import="javax.mail.internet.MimeMessage"%>
<%@page import="javax.mail.Message"%>
<%@page import="javax.mail.PasswordAuthentication"%>
<%@page import="java.util.Properties"%>
<%@page import="javax.mail.Session"%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>메일 보내기</title>
<script type="text/javascript">
	function main() {
		opener.document.location.href="../main/main.jsp";
		self.close();
	}
</script>
</head>
<body>
<%
	request.setCharacterEncoding("utf-8");
	//받아온 변수... 
	String result = "SendMail OK";
	try {
		String st = "magna20@naver.com"; // 받는 사람 
		String title = request.getParameter("title"); // 제목
		String sf = "magna20@naver.com"; // 보내는 사람 
		String content = "★보내는 사람 : " + request.getParameter("name") + "<br>" 
					   + "★보낸사람 이메일 : " + request.getParameter("email") + "<br>"
					   + "★내용 : "+ request.getParameter("content"); // 내용
		
		Properties p = new Properties(); // 정보를 담을 객체
		
		// 네이버 SMTP
		p.put("mail.smtp.host","smtp.naver.com");  
		p.put("mail.smtp.port", "465"); 
		p.put("mail.smtp.starttls.enable", "true"); // 이부분은 true,false든 일단 제외시키니깐 정상작동되네... 
		p.put("mail.smtp.auth", "true"); 
		p.put("mail.smtp.debug", "true"); 
		p.put("mail.smtp.socketFactory.port", "465"); 
		p.put("mail.smtp.socketFactory.class", "javax.net.ssl.SSLSocketFactory"); 
		p.put("mail.smtp.socketFactory.fallback", "false");
		
		// SMTP 서버에 접속하기 위한 정보들 
		System.out.println(5678); //Get the Session object. 
		
		try { 
			Session mailSession = Session.getInstance(p,
				new javax.mail.Authenticator() { 
					protected PasswordAuthentication getPasswordAuthentication() { 
						return new PasswordAuthentication("magna20","asdasd21!"); // 네이버 메일 ID / PWD 
					}
				}); 
			
			mailSession.setDebug(true); 
			
			// Create a default MimeMessage object. 
			Message message = new MimeMessage(mailSession); 
			
			// Set From: header field of the header. 
			message.setFrom(new InternetAddress(sf)); 
			
			// Set To: header field of the header. 
			message.addRecipient(Message.RecipientType.TO, new InternetAddress(st)); 
			
			// Set Subject: header field 
			message.setSubject(title); 
			
			// Now set the actual message 
			message.setContent(content, "text/html;charset=utf-8"); // 내용과 인코딩 
			
			// Send message 
			Transport.send(message); 
			
			// System.out.println("Sent message successfully...."); 
			// sResult = "Sent message successfully...."; 
			
			} catch (MessagingException e) { 
				e.printStackTrace(); System.out.println("Error: unable to send message...." + e.toString()); result = "Error"; 
			} 
		} catch (Exception err){
			System.out.println(err.toString()); result = "Error"; 
		} finally {
			// dbhandle.close(dbhandle.con); 
		} 
%> 
<% out.clear(); %>
<%=result %>
<script>
	self.close();
</script>

</body>
</html>