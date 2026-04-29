<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fn"     uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt"    uri="http://java.sun.com/jsp/jstl/fmt"%>
<div class="info-card">
	<div class="info-card-header">비밀번호 변경</div>
    <div class="info-card-body">
		<div class="info-row">
        	<div class="info-label">현재 비밀번호 <span class="required">*</span></div>
           	<div class="info-value">
               	<input type="password" class="form-input" id="curPasswd" maxlength="20" placeholder="현재 비밀번호 입력"/>
           	</div>
        </div>    	
        
        <div class="info-row">
        	<div class="info-label">새 비밀번호 <span class="required">*</span></div>
            <div class="info-value">
            	<input type="password" class="form-input" id="newPasswd" maxlength="20" placeholder="새 비밀번호 입력 (8자 이상)"/>
            </div>
        </div>
        
        <div class="info-row">
        	<div class="info-label">새 비밀번호 확인 <span class="required">*</span></div>
           	<div class="info-value">
            	<input type="password" class="form-input" id="newPasswdConfirm" maxlength="20" placeholder="새 비밀번호 다시 입력"/>
                <div class="field-msg" id="newPasswdConfirmMsg"></div>
            </div>
        </div>
    </div>
    <div class="info-card-footer">
    	<button type="button" class="toolbar-btn toolbar-btn-primary" id="btnSave">변경</button>
    </div>
</div>
<script>

	// 새 비밀번호 확인
	$('#newPasswdConfirm').on('input', function () {
    	let pw  = $('#newPasswd').val();
    	let pw2 = $(this).val();
    	
    	if (!pw2) { 
    		$('#newPwConfirmMsg').text('').removeClass('msg-ok msg-error'); 
    		return; 
    	}
    	
    	if (pw === pw2) {
      		$('#newPwConfirmMsg').text('비밀번호가 일치합니다.').removeClass('msg-error').addClass('msg-ok');
    	} else {
      		$('#newPwConfirmMsg').text('비밀번호가 일치하지 않습니다.').removeClass('msg-ok').addClass('msg-error');
    	}
  	});
	
	 $('#btnSavePw').on('click', function () {
		    var currentPw    = $('#currentPw').val();
		    var newPw        = $('#newPw').val();
		    var newPwConfirm = $('#newPwConfirm').val();

		    if (!currentPw) { alert("현재 비밀번호를 입력해주세요."); return; }
		    if (!newPw || newPw.length < 8) { alert("새 비밀번호를 8자 이상 입력해주세요."); return; }
		    if (newPw !== newPwConfirm) { alert("새 비밀번호가 일치하지 않습니다."); return; }
		    if (currentPw === newPw) { alert("현재 비밀번호와 동일합니다."); return; }

		    $.ajax({
		      url: '/user/updatePw.do',
		      type: 'POST',
		      data: { CURRENT_PW: currentPw, NEW_PW: newPw },
		      success: function (res) {
		        if (res == 'success') {
		          alert("비밀번호가 변경되었습니다.");
		          $('#currentPw, #newPw, #newPwConfirm').val('');
		          $('#newPwConfirmMsg').text('').removeClass('msg-ok msg-error');
		        } else if (res == 'wrong') {
		          alert("현재 비밀번호가 올바르지 않습니다.");
		        } else {
		          alert("변경에 실패했습니다.");
		        }
		      }
		    });
		  });
	
	
</script>