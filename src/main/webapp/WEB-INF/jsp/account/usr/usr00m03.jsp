<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fn"     uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt"    uri="http://java.sun.com/jsp/jstl/fmt"%>
<div class="info-card">
	<div class="info-card-header">회원 탈퇴</div>
	<div class="info-card-body">

	  	<div class="leave-warn">
	    	<div class="leave-warn-icon">⚠️</div>
	    	<div class="leave-warn-text">
	      		<strong>탈퇴 시 모든 데이터가 삭제됩니다.</strong><br/>
	      		가계부 내역, 설정 등 모든 정보가 영구적으로 삭제되며 복구할 수 없습니다.
	    	</div>
	  	</div>
	  	
	  	<div class="info-row" style="margin-top:20px;">
	    	<div class="info-label">비밀번호 확인 <span class="required">*</span></div>
	        <div class="info-value">
	        	<input type="password" class="form-input" id="leavePw" maxlength="20" placeholder="비밀번호를 입력해주세요"/>
	        </div>
	    </div>
	
		<div class="info-card-footer">
	    	<button type="button" class="toolbar-btn toolbar-btn-danger" id="btnLeave">탈퇴하기</button>
	    </div>
  	</div>
  	
  	
</div>
<script>
	$('#btnLeave').on('click', function () {
    	let leavePw = $('#leavePw').val();

    	if (!leavePw) { 
    		alert("비밀번호를 입력해주세요."); 
    		return; 
    	}
    	
    	if (!confirm("정말 탈퇴하시겠습니까?\n모든 데이터가 삭제되며 복구할 수 없습니다.")) return;

    	$.ajax({
      		url: '/usr/deleteUser.do',
      		type: 'POST',
      		data: { PASSWD: leavePw },
      		success: function (res) {
        		if (res == 'success') {
          			alert("탈퇴가 완료되었습니다.");
          			location.href = '/lgn/login.do';
       	 		} else if (res == 'fail') {
          			alert("비밀번호가 올바르지 않습니다.");
        		}
      		}
    	});
  	});
</script>