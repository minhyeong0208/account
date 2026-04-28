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
<title>회원가입</title>
</head>
<body>
<div class="login-wrapper">
  	<div class="logo-area">
	    <span class="logo-icon">💰</span>
	    <div class="logo-title">가계부</div>
	    <div class="logo-sub">스마트한 지출 관리</div>
  	</div>

  	<div class="login-card">
	    <div class="card-title">회원가입</div>
	
	    <!-- 에러 메시지 -->
	    <div class="error-msg" id="errorMsg"></div>
	    <!-- 성공 메시지 -->
	    <div class="success-msg" id="successMsg"></div>
	
	    <!-- 아이디 -->
	    <div class="form-group">
	      	<label class="form-label">아이디 <span class="required">*</span></label>
	      	<div class="input-with-btn">
		        <input type="text" class="form-input" id="userid" name="userid"
		               placeholder="아이디를 입력하세요" maxlength="20" autocomplete="username"/>
		        <button type="button" class="btn-check" id="btnIdCheck">중복확인</button>
      		</div>
      		<div class="field-msg" id="idMsg"></div>
    	</div>

	    <!-- 비밀번호 -->
	    <div class="form-group">
	      	<label class="form-label">비밀번호 <span class="required">*</span></label>
	      	<input type="password" class="form-input" id="passwd" name="passwd"
	               placeholder="비밀번호를 입력하세요 (8자 이상)" maxlength="20" autocomplete="new-password"/>
	      	<div class="field-msg" id="passwdMsg"></div>
	    </div>
	
	    <!-- 비밀번호 확인 -->
	    <div class="form-group">
	      	<label class="form-label">비밀번호 확인 <span class="required">*</span></label>
	      	<input type="password" class="form-input" id="passwdConfirm" name="passwdConfirm"
	               placeholder="비밀번호를 다시 입력하세요" maxlength="20" autocomplete="new-password"/>
	      	<div class="field-msg" id="passwdConfirmMsg"></div>
	    </div>
	    
	    <!-- 사용자명 -->
		<div class="form-group">
		    <label class="form-label">사용자명 <span class="required">*</span></label>
		    <input type="text" class="form-input" id="username" name="username"
		           placeholder="이름을 입력하세요" maxlength="20"/>
		    <div class="field-msg" id="usernameMsg"></div>
		</div>
	
	    <!-- 생년월일 -->
	    <div class="form-group">
	      	<label class="form-label">생년월일 <span class="required">*</span></label>
	      	<input type="text" class="form-input" id="birthdate" name="birthdate"
	               placeholder="YYYYMMDD (예: 19900101)" maxlength="8"/>
	      	<div class="field-msg" id="birthdateMsg"></div>
	    </div>

	    <!-- 휴대폰번호 -->
	    <div class="form-group">
	      	<label class="form-label">휴대폰번호 <span class="required">*</span></label>
	      	<input type="text" class="form-input" id="phone" name="phone"
	               placeholder="숫자만 입력하세요 (예: 01012345678)" maxlength="11"/>
	      	<div class="field-msg" id="phoneMsg"></div>
	    </div>
	
		<!-- 이메일 -->
		<div class="form-group">
		    <label class="form-label">이메일 <span class="required">*</span></label>
		    <input type="text" class="form-input" id="email" name="email"
		           placeholder="이메일을 입력하세요" maxlength="50"/>
		    <div class="field-msg" id="emailMsg"></div>
		</div>
	
	    <button type="button" class="btn-login" id="btnRegister">가입하기</button>
	
	    <div class="signup-row">
	      	이미 계정이 있으신가요?
	      	<a href="/lgn/login.do">로그인</a>
	    </div>
	</div>
</div>
<script>
	var idChecked = false;  // 아이디 중복 체크

	// 아이디 중복확인
	$('#btnIdCheck').on('click', function () {
		let userid = $.trim($('#userid').val());

		if(!userid) {
			alert("아이디를 입력해주세요.");
			return;
		}
		
		if (!/^[a-zA-Z0-9]{4,20}$/.test(userid)) {
			alert("아이디는 영문/숫자 4~20자로 입력해주세요.");
			return;
		}
		
		$.ajax({
			url: "/lgn/dupCheckId.do",
			type: "POST",
			data: { USERID: userid },
			success: function (res) {
				if(res == "success") {
					idChecked = true;
					alert("사용 가능한 아이디입니다.");
				}else {
					idChecked = false;
					alert("이미 사용 중인 아이디입니다.");
				}
			}
		});
	});
	
	// 가입하기
	$('#btnRegister').on('click', function () {
		let userid        = $.trim($('#userid').val());
		let passwd        = $('#passwd').val();
		let passwdConfirm = $('#passwdConfirm').val();
		let username = $.trim($('#username').val());
		let birthdate     = $.trim($('#birthdate').val());
		let phone         = $.trim($('#phone').val());
		let email = $.trim($('#email').val());
	    
	    if(!userid) {
	    	alert("아이디를 입력해주세요.");
	    	return;
	    }
	    
	    if(!passwd || passwd.length < 8) {
	    	alert("비밀번호를 8자 이상 입력해주세요.");
	    	return;
	    }
	    
	    if(passwd !== passwdConfirm) {
	    	alert("비밀번호가 일치하지 않습니다.");
	    	return;
	    }
	    
	    if(!username) {
	        alert("사용자명을 입력해주세요.");
	        return;
	    }
	    
	    if(!birthdate || birthdate.length !== 8 || !isValidDate(birthdate)) {
	    	alert("올바른 생년월일을 입력해주세요.");
	    	return;
	    }
	    
	    if(!phone || !/^01[016789][0-9]{7,8}$/.test(phone)) {
	    	alert("올바른 휴대폰번호를 입력해주세요.");
	    	return;
	    }
	    
	    if(!email || !/^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/.test(email)) {
	        alert("올바른 이메일을 입력해주세요.");
	        return;
	    }
	    
	    $.ajax({
	    	url: "/lgn/passRegister.do",
	    	type: "POST",
	    	data: {USERID: userid, PASSWD: passwd, USERNM: username, BIRTHDATE: birthdate, PHONENUM: phone, EMAIL: email},
	    	success: function (res) {
	    		if(res == "success") {
	    			alert("회원가입이 완료되었습니다. 로그인 페이지로 이동합니다.");
	    			setTimeout(function () {
	    	        	location.href = '/lgn/login.do';
	    	        }, 1500);
	    		} else {
	    			alert("회원가입에 실패했습니다.");
	    			return;
	    		}
	    	}
	    });
	    
	    
	});
	
	var isValidDate = (str) => {
		var y = parseInt(str.substring(0, 4), 10);
	    var m = parseInt(str.substring(4, 6), 10);
	    var d = parseInt(str.substring(6, 8), 10);
	    
	    if (y < 1900 || y > new Date().getFullYear()) return false;
	    if (m < 1 || m > 12) return false;
	    
	    var maxDay = new Date(y, m, 0).getDate();
	    
	    return d >= 1 && d <= maxDay;
	}
</script>
</body>
</html>