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
	<c:if test="${not empty errorMsg}">
	    <div class="error-msg show">${errorMsg}</div>
	</c:if>
    <form id="submitLogin" name="submitLogin" method="post" action="/lgn/passLogin.do">
      <div class="form-group">
        <label class="form-label">아이디</label>
        <input type="text" class="form-input" name="USERID" placeholder="아이디를 입력하세요" autocomplete="username"/>
      </div>

      <div class="form-group">
        <label class="form-label">비밀번호</label>
        <input type="password" class="form-input" name="PASSWD" placeholder="비밀번호를 입력하세요" autocomplete="current-password"/>
      </div>

      <div class="form-options">
        <label class="remember-label">
          <input type="checkbox" name="rememberMe"/>
          로그인 유지
        </label>
        <a href="#" class="forgot-link" onclick="openTempPwModal()">임시 비밀번호 발급</a>
      </div>

      <button type="submit" class="btn-login">로그인</button>
    </form>

    <div class="signup-row">
      계정이 없으신가요?
      <a href="/lgn/register.do">회원가입</a>
    </div>
  </div>
</div>

<script>
	var openTempPwModal = () => {
		if ($('#tempPwModal').length === 0) {
			$('body').append(
				'<div class="modal-overlay" id="tempPwModal">' +
				'  <div class="modal">' +
				'    <div class="modal-header">' +
				'      <h3>임시 비밀번호 발급</h3>' +
				'      <button class="modal-close" onclick="closeTempPwModal()">✕</button>' +
				'    </div>' +
				'    <div class="modal-body">' +
				'      <div class="modal-form-row">' +
				'        <label>아이디</label>' +
				'        <input type="text" id="USERID">' +
				'      </div>' +
				'      <div class="modal-form-row">' +
				'        <label>이메일</label>' +
				'        <input type="text" id="EMAIL">' +
				'      </div>' +
				'    </div>' +
				'    <div class="modal-footer">' +
				'      <button type="button" class="toolbar-btn toolbar-btn-danger" onclick="closeTempPwModal()">취소</button>' +
				'      <button type="button" class="toolbar-btn toolbar-btn-primary" onclick="requestTempPw()">발급</button>' +
				'    </div>' +
				'  </div>' +
				'</div>'
			);
		}
		$('#tempPwModal').addClass('open');
	}
	
	var closeTempPwModal = () => {
		$('#tempPwModal').removeClass('open');
		$('#USERID').val('');
		$('#EMAIL').val('');
	}
	
	var requestTempPw = () => {
		let userId = $("#USERID").val().trim();
	    let email  = $("#EMAIL").val().trim();
	    
	    if (!userId || !email) {
	        alert("아이디와 이메일을 입력해주세요.");
	        return;
	    }
	    
	    $.ajax({
	        url: "/lgn/sendTempPassword.do",
	        type: "POST",
	        data: { USERID: userId, EMAIL: email },
	        success: function(res) {
                alert("임시 비밀번호가 이메일로 발송되었습니다.");
                closeTempPwModal();
	        }
	    });
	}
</script>
</body>
</html>