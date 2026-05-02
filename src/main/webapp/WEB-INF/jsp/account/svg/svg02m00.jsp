<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fn"     uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt"     uri="http://java.sun.com/jsp/jstl/fmt"%>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.1/jquery.min.js"></script>

<div class="page-header">
	<h1>적금 관리</h1>
	<button class="toolbar-btn toolbar-btn-primary" onclick="openAddModal()">+ 적금 추가</button>
</div>

<div class="summary-cards">
	<div class="s-card income">
    	<div class="s-label">진행 중인 적금</div>
    	<div class="s-value">${savingsSummary.ACTIVE_COUNT}개</div>
    	<div class="s-sub">총 월 납입 <fmt:formatNumber value="${savingsSummary.TOTAL_MONTHLY}" pattern="#,###"/>원</div>
    </div>
	<div class="s-card expense">
        <div class="s-label">총 납입액</div>
        <div class="s-value"><fmt:formatNumber value="${savingsSummary.TOTAL_PAID}" pattern="#,###"/>원</div>
        <div class="s-sub">지금까지 납입한 금액</div>
    </div>
    <div class="s-card balance">
       	<div class="s-label">예상 총 수령액</div>
       	<div class="s-value"><fmt:formatNumber value="${savingsSummary.TOTAL_EXPECT}" pattern="#,###"/>원</div>
       	<div class="s-sub">이자 포함</div>
    </div>
</div>

<%-- 적금 목록 --%>
<div class="savings-list">
	<c:choose>
		<c:when test="${empty savingsList}">
			<div class="empty-state">🏦
				<p>등록된 적금이 없습니다.</p>
              	<p>적금 추가 버튼을 눌러 시작해보세요!</p>
            </div>
		</c:when>
		<c:otherwise>
			<c:forEach var="s" items="${savingsList}">
				<div class="savings-card">
					<div class="card-top">
						<div>
		                    <div class="card-name">${s.SAVINGNM}</div>
		                    <div class="card-bank">${s.BANKNAME}</div>
		                </div>
		                <c:choose>
	                    	<c:when test="${s.STATUS == 'A'}">
	                      		<span class="badge badge-active">진행 중</span>
	                    	</c:when>
	                   		<c:otherwise>
	                      		<span class="badge badge-done">완료</span>
	                    	</c:otherwise>
	                  	</c:choose>
					</div>
					
                  	<div class="card-mid">
						<div>
	                    	<div class="card-info-label">월 납입액</div>
	                    	<div class="card-info-value"><fmt:formatNumber value="${s.PAYMENTAMOUNT}" pattern="#,###"/>원</div>
	                  	</div>
						<div>
                    		<div class="card-info-label">금리</div>
                    		<div class="card-info-value">${s.INTERESTRATE}%</div>
                  		</div>
                  		<div>
                    		<div class="card-info-label">만기일</div>
                    		<div class="card-info-value">${s.EXPIRATIONDATE}</div>
                  		</div>
					</div>
					<div class="progress-wrap">
                  		<div class="progress-label">
                  			<span>납입 진행률</span>
                    		<span>${s.PAID_MONTHS} / ${s.TOTAL_MONTHS}개월</span>
                  		</div>
                  		<div class="progress-bar">
                    		<div class="progress-fill" style="width:${s.PROGRESS_PCT}%"></div>
                  		</div>
                  	</div>
                  	<div class="card-bottom">
                  		<div class="card-amounts">
                  			납입 <span><fmt:formatNumber value="${s.TOTAL_PAID_AMOUNT}" pattern="#,###"/>원</span>
                    · 만기 수령 예상 <span><fmt:formatNumber value="${s.EXPECTED_AMOUNT}" pattern="#,###"/>원</span>
                  		</div>
                  		<div class="card-actions">
                    		<button class="btn-sm btn-sm-outline" onclick="detailSavings('${s.SAVINGSID}')">상세</button>
                    		<button class="btn-sm btn-sm-danger" onclick="deleteSavings('${s.SAVINGSID}','${s.SAVINGNM}')">삭제</button>
                 	 	</div>
                  	</div>
				</div>
			</c:forEach>
		</c:otherwise>
	</c:choose>
</div>

<script>

	var openAddModal = () => {
		if ($('#addModal').length === 0) {
			$('body').append(
				'<div class="modal-overlay" id="addModal">' +
				'  <div class="modal">' +
				'    <div class="modal-header">' +
				'      <h3>적금 추가</h3>' +
				'      <button class="modal-close" onclick="closeAddModal()">✕</button>' +
				'    </div>' +
				'    <div class="modal-body">' +
				'      <div class="form-row-2">' +
				'	     <div class="modal-form-row">' + 
				'          <label>적금명 <span style="color:var(--color-expense)">*</span></label>' +
				'          <input type="text" name="savingNm" id="savingNm" placeholder="적금명을 입력하세요." required>' + 
				'		 </div>' +
				'	     <div class="modal-form-row">' + 
				'          <label>은행명 <span style="color:var(--color-expense)">*</span></label>' +
				'          <input type="text" name="bankName" id="bankName" placeholder="은행명을 입력하세요." required>' + 
				'		 </div>' +
				'      </div>' +
				'      <div class="form-row-2">' +
				'	     <div class="modal-form-row">' + 
				'          <label>월 납입액 (원)<span style="color:var(--color-expense)">*</span></label>' +
				'          <input type="number" name="paymentAmount" id="paymentAmount" placeholder="70000" min="1" required>' + 
				'		 </div>' +
				'	     <div class="modal-form-row">' + 
				'          <label>금리 (%)</label>' +
				'          <input type="number" name="interestrate" id="interestrate" placeholder="4.5" step="0.01" min="0">' + 
				'		 </div>' +
				'      </div>' +
				'      <div class="form-row-2">' +
				'	     <div class="modal-form-row">' + 
				'          <label>가입일 <span style="color:var(--color-expense)">*</span></label>' +
				'          <input type="date" name="joinDate" id="joinDate" required>' + 
				'		 </div>' +
				'	     <div class="modal-form-row">' + 
				'          <label>만기일 </label>' +
				'          <input type="date" name="expirationDate" id="expirationDate" required>' + 
				'		 </div>' +
				'      </div>' +
				'	   <div class="modal-form-row">' + 
				'        <label>메모 </label>' +
				'        <input type="text" name="memo" id="memo" placeholder="메모를 입력하세요 (선택)">' + 
				'	   </div>' +
				'    </div>' +
				'    <div class="modal-footer">' +
				'      <button type="button" class="toolbar-btn" style="border:1px solid var(--color-border);background:var(--color-white);color:var(--color-text-sub);" onclick="closeAddModal()">취소</button>' +
				'      <button type="button" class="toolbar-btn toolbar-btn-primary" onclick="insertSavings()">등록</button>' +
				'    </div>' +
				'  </div>' + 
				'</div>'
			);
		}
		
		$('#addModal').addClass('open');
	}
	
	var insertSavings = () => {
		let savingNm = $("#savingNm").val();
		let bankName = $("#bankName").val();
		let paymentAmount = $("#paymentAmount").val();
		let interestrate = $("#interestrate").val();
		let joinDate = $("#joinDate").val();
		let expirationDate = $("#expirationDate").val();
		let memo = $("#memo").val();
		
		let valid = true;
		
		if (!savingNm && !bankName && !paymentAmount && !interestrate && !joinDate && !expirationDate && !memo) return;
		
		if(!savingNm.trim()) { alert("적금명을 입력해주세요."); valid = false; return false; }
		if(!bankName.trim()) { alert("은행명을 입력해주세요."); valid = false; return false; }
		if(!paymentAmount.trim()) { alert("월 납입액을 입력해주세요."); valid = false; return false; }
		if(!interestrate.trim()) { alert("금리를 입력해주세요."); valid = false; return false; }
		if(!joinDate.trim()) { alert("가입일을 입력해주세요."); valid = false; return false; }
		if(!expirationDate.trim()) { alert("만기일을 입력해주세요."); valid = false; return false; }
		
		if (!valid) return;
		
		$.ajax({
			url: "/svg/saveSavings.do",
			type: "POST",
			data: { SAVINGNM: savingNm, BANKNAME: bankName, PAYMENTAMOUNT: paymentAmount, INTERESTRATE: interestrate, JOINDATE: joinDate, EXPIRATIONDATE: expirationDate, MEMO: memo},
			success: (res) => {
				alert("저장되었습니다.");
				closeAddModal();
				loadContent('/svg/svg02m00.do');
			}
		});
	}
	
	// 적금 상세
	var detailSavings = (p_sid) => {
		
		loadContent('/svg/svg03m00.do', { SAVINGSID: p_sid });
	}
	
	// 적금 삭제
	var deleteSavings = (p_sid, p_snm) => {
		
		if (!confirm('[' + p_snm + '] 적금을 삭제하시겠습니까?\n관련 납입 내역도 모두 삭제됩니다.')) return;
		
		$.ajax({
			url: "/svg/deleteSavings.do",
			type: "POST",
			data: {SAVINGSID: p_sid},
			success: (res) => {
				alert("삭제되었습니다.");
				loadContent('/svg/svg02m00.do');
			}
		});
	}
	
	var closeAddModal = function() {
		$('#addModal').removeClass('open');
	    $('#savingNm').val('');
	    $('#bankName').val('');
	    $('#paymentAmount').val('');
	    $('#interestrate').val('');
	    $('#joinDate').val('');
	    $('#expirationDate').val('');
	    $('#memo').val('');
	};
</script>