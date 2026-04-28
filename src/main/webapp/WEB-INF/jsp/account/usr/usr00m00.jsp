<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fn"     uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt"    uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>내정보</title>
</head>
<body>
<div class="page-header">
  	<h1>내 정보</h1>
</div>

<div class="tab-header">
  	<button class="tab-btn active" data-tab="tabInfo">기본 정보</button>
  	<button class="tab-btn"       data-tab="tabPw">비밀번호 변경</button>
  	<button class="tab-btn"       data-tab="tabLeave">회원 탈퇴</button>
</div>
</body>
</html>