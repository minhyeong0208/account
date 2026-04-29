<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fn"     uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt"    uri="http://java.sun.com/jsp/jstl/fmt"%>
<div id="tabInfo" class="tab-content">
	<div class="info-card">
    	<div class="info-card-header">기본 정보</div>
        <div class="info-card-body">
        	<div class="info-row">
              	<div class="info-label">아이디</div>
              	<div class="info-value readonly">${sessionScope.USERID}</div>
            </div>
            
            <div class="info-row">
              	<div class="info-label">사용자명 <span class="required">*</span></div>
             	<div class="info-value">
                	<input type="text" class="form-input" id="USERNM" value="${USERNM}" maxlength="20"/>
              	</div>
            </div>
            
            <div class="info-row">
           		<div class="info-label">생년월일 <span class="required">*</span></div>
             	<div class="info-value">
                	<input type="date" class="form-input" id="BIRTHDATE" value="${BIRTHDATE}"/>
              	</div>
            </div>
            
            <div class="info-row">
              	<div class="info-label">휴대폰번호 <span class="required">*</span></div>
              	<div class="info-value">
                	<input type="text" class="form-input" id="PHONENUM" value="${PHONENUM}" maxlength="11" placeholder="숫자만 입력"/>
              	</div>
            </div>
            
            <div class="info-row">
              	<div class="info-label">이메일 <span class="required">*</span></div>
              	<div class="info-value">
                	<input type="text" class="form-input" id="EMAIL" value="${EMAIL}" maxlength="100" placeholder="이메일 입력"/>
              	</div>
            </div>
            
            <div class="info-row">
              	<div class="info-label">가입일</div>
              	<div class="info-value readonly">${REGDATE}</div>
            </div>
            
            <div class="info-card-footer">
            	<button type="button" class="toolbar-btn toolbar-btn-primary" id="btnSaveInfo">저장</button>
          	</div>
        </div>	
	</div>
</div>
<script>
	$('#btnSaveInfo').on('click', function () {
    	let usernm    = $.trim($('#USERNM').val());
    	let birthdate = $.trim($('#BIRTHDATE').val());
    	let phone     = $.trim($('#PHONENUM').val());
    	let email     = $.trim($('#EMAIL').val());

	    if (!usernm) { 
	    	alert("사용자명을 입력해주세요."); 
	    	return; 
	    }
	    
	    if (!birthdate) { 
	    	alert("올바른 생년월일을 입력해주세요."); 
	    	return; 
	    }
    
	    if (!phone || !/^01[016789][0-9]{7,8}$/.test(phone)) { 
	    	alert("올바른 휴대폰번호를 입력해주세요."); 
	    	return; 
	    }
	    
	    if (!email || !/^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$/.test(email)) { 
	    	alert("올바른 이메일을 입력해주세요."); 
	    	return; 
	    }

	    $.ajax({
	      	url: '/usr/updateUser.do',
	      	type: 'POST',
	      	data: { USERNM: usernm, BIRTHDATE: birthdate, PHONENUM: phone, EMAIL: email },
	      	success: function (res) {
	        	if (res == 'success') {
	        	  alert("저장되었습니다.");
	       		} else {
	       	   	  alert("저장에 실패했습니다.");
	       	 	}
	      	}
	    });
  	});
</script>
