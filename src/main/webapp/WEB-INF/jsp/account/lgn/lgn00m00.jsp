<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fn"     uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt"     uri="http://java.sun.com/jsp/jstl/fmt"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.1/jquery.min.js"></script>
<link rel="stylesheet" href="<c:url value='/css/account/login.css'/>">
<title>로그인</title>
</head>
<body>

<div class="login-wrapper">
  <div class="logo-area">
    <span class="logo-icon">💰</span>
    <div class="logo-title">가계부</div>
    <div class="logo-sub">스마트한 지출 관리</div>
  </div>

  <div class="login-card">
    <div class="card-title">로그인</div>

    <form id="submitLogin" name="submitLogin" method="post" action="/lgn/passLogin.do">
      <div class="form-group">
        <label class="form-label">아이디</label>
        <input type="text" class="form-input" name="userid" placeholder="아이디를 입력하세요" autocomplete="username"/>
      </div>

      <div class="form-group">
        <label class="form-label">비밀번호</label>
        <input type="password" class="form-input" name="passwd" placeholder="비밀번호를 입력하세요" autocomplete="current-password"/>
      </div>

      <div class="form-options">
        <label class="remember-label">
          <input type="checkbox" name="rememberMe"/>
          로그인 유지
        </label>
        <a href="#" class="forgot-link">비밀번호 찾기</a>
      </div>

      <button type="submit" class="btn-login">로그인</button>
    </form>

    <div class="signup-row">
      계정이 없으신가요?
      <a href="/user/register.do">회원가입</a>
    </div>
  </div>
</div>

<script>

</script>
</body>
</html>