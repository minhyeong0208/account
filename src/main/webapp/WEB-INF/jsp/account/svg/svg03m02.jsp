<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fn"     uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt"     uri="http://java.sun.com/jsp/jstl/fmt"%>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.1/jquery.min.js"></script>
<div class="extra-toolbar">
	<div class="extra-summary">
		총 추가납입
        <span><fmt:formatNumber value="${extraTotalAmount}" pattern="#,###"/>원</span>
        (<fmt:formatNumber value="${extraCount}" pattern="#,###"/>건)
	</div>
	<button class="toolbar-btn toolbar-btn-primary" onclick="openExtraModal()">+ 추가 납입</button>
</div>

<c:choose>
	<c:when test="${empty detail}">
      	<div class="empty-state">추가 납입 내역이 없습니다.</div>
    </c:when>
    <c:otherwise>
    	<div class="extra-table-wrap">
	    	<table class="extra-table">
	        	<thead>
	            	<tr>
		                <th>납입일</th>
		                <th>메모</th>
		                <th>금액</th>
		                <th>삭제</th> 
	                </tr>
	            </thead>
	            <tbody>
	            	<c:forEach var="e" items="${detail}">
	                	<tr>
	                        <td>${e.PAYDATE}</td>
	                        <td>${e.MEMO}</td>
	                        <td><fmt:formatNumber value="${e.PAYAMOUNT}" pattern="#,###"/>원</td>
	                        <td>
	                          <button class="btn-sm btn-sm-danger" onclick="deleteExtra('${e.HISTORYID}')">삭제</button>
	                        </td>
	                    </tr>
	                </c:forEach>
	            </tbody>
	    	</table>
	    </div>
    </c:otherwise>
</c:choose>

<script>
	var valid = true;

	var openExtraModal = function() {
		if($('#extraModal').length === 0) {
			$('body').append(
				'<div class="modal-overlay" id="extraModal">' +
				'  <div class="modal">' +
				'    <div class="modal-header">' + 
				'      <h3>추가 납입 등록</h3>' +
				'      <button class="modal-close" onclick="closeExtraModal()">✕</button>' +
				'    </div>' + 
				'    <div class="modal-body">' +
				'      <div class="modal-form-row">' +
				'        <label>납입일 <span style="color:var(--color-expense)">*</span></label>' + 
				'        <input type="date" name="paydate" id="extraDate" required>' + 
				'      </div>' + 
				'      <div class="modal-form-row">' +
				'        <label>금액 (원) <span style="color:var(--color-expense)">*</span></label>' + 
				'        <input type="number" name="payamount" id="payamount" placeholder="50000" min="1" required>' + 
				'      </div>' + 
				'      <div class="modal-form-row">' +
				'        <label>메모</label>' + 
				'        <input type="text" name="memo" id="memo" placeholder="메모 (선택)">' + 
				'      </div>' + 
				'    </div>' +
				'    <div class="modal-footer">' +
				'      <button type="button" class="toolbar-btn" style="border:1px solid var(--color-border);background:var(--color-white);color:var(--color-text-sub);" onclick="closeExtraModal()">취소</button>' +
				'      <button type="button" class="toolbar-btn toolbar-btn-primary" onclick="register()">등록</button>' + 
				'    </div>' +
				'  </div>' +
				'</div>'
			);
		}
		
		$('#extraModal').addClass('open');
	}
	
	var register = function() {
		let paydate = $('#extraDate').val();
		let payamount = $('#payamount').val();
		let memo = $('#memo').val();
		
		if(!paydate.trim()) { alert("납입일을 입력해주세요."); valid = false; return false; }
		if(!payamount) { alert("금액을 입력해주세요."); valid = false; return false; }

		if (!valid) return;
		
		$.ajax({
			url: "/svg/saveAddSavings.do",
			type: "POST",
			data: { SAVINGSID: savingsId, PAYDATE: paydate, PAYAMOUNT: payamount, MEMO: memo },
			success: (res) => {
				alert("저장되었습니다.");
				closeExtraModal();
				$.ajax({
                    url: '/svg/svg03m02.do',
                    type: 'POST',
                    data: { SAVINGSID: savingsId, TYPE: 'A' },
                    success: function(res) {
                        $('#tabContent').html(res);
                    }
                });
			},
			error: () => {
				alert("저장 중 오류가 발생했습니다.");
			}
		});
	}
	
	var deleteExtra = function(p_hid) {
		
		if(!confirm("해당 추가납입 건을 삭제하시겠습니까?")) return;
		
		$.ajax({
			url: "/svg/deleteAddSavings.do",
			type: "POST",
			data: { SAVINGSID: savingsId, HISTORYID: p_hid },
			success: (res) => {
				$.ajax({
                    url: '/svg/svg03m02.do',
                    type: 'POST',
                    data: { SAVINGSID: savingsId, TYPE: 'A' },
                    success: function(res) {
                        $('#tabContent').html(res);
                    }
                });
			}
		});
	}
	
	var closeExtraModal = function() {
		$('#extraModal').removeClass('open');
		$('#extraDate').val('');
		$('#payamount').val('');
		$('#memo').val('');
	};
</script>