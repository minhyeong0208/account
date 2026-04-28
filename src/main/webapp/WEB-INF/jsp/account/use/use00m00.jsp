<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib prefix="c"      uri="http://java.sun.com/jsp/jstl/core" %>
<%@ taglib prefix="form"   uri="http://www.springframework.org/tags/form" %>
<%@ taglib prefix="ui"     uri="http://egovframework.gov/ctl/ui"%>
<%@ taglib prefix="spring" uri="http://www.springframework.org/tags"%>
<%@ taglib prefix="fn"     uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="fmt"     uri="http://java.sun.com/jsp/jstl/fmt"%>
<script src="https://ajax.googleapis.com/ajax/libs/jquery/3.6.1/jquery.min.js"></script>

<div class="page-header">
	<h1>월별 내역</h1>
	<div class="month-nav">
		<button type="button" onclick="prevMonth()">◀</button>
		<span id="monthLabel"></span>
		<button type="button" onclick="nextMonth()">▶</button>
	</div>
</div>
<div class="summary-cards">
  	<div class="s-card income">
    	<div class="s-label">총 수입</div>
    	<div class="s-value" id="income"></div>
    	<div class="s-sub">원</div>
  	</div>
  	<div class="s-card expense">
    	<div class="s-label">총 지출</div>
    	<div class="s-value" id="expense"></div>
    	<div class="s-sub">원</div>
  	</div>
  	<div class="s-card balance">
    	<div class="s-label">잔액</div>
    	<div class="s-value" id="balance"></div>
    	<div class="s-sub">원</div>
  	</div>
</div>
<form id="mthFrm" method="post">

	<div class="toolbar">
		<div class="toolbar-left">
			<select class="toolbar-select" name="searchKey" onchange="changeSearchUI()">
				<option value="bankNm">은행명</option>
				<option value="tranType">거래유형</option>
				<option value="description">내용</option>
				<option value="categoryId">항목</option>
			</select>
			<span id="searchArea"></span>
			<button type="button" class="toolbar-btn toolbar-btn-primary" onclick="search()">검색</button> 
		</div>
		<div>
			<button type="button" class="toolbar-btn toolbar-btn-outline" onclick="openUploadModal()">엑셀 업로드</button>
			<button type="button" class="toolbar-btn toolbar-btn-outline" onclick="addRow()">내역 추가</button>
			<button type="button" class="toolbar-btn toolbar-btn-success" onclick="save()">저장</button>
			<button type="button" class="toolbar-btn toolbar-btn-danger" onclick="deleteRow()">삭제</button>
		</div>
	</div>

	<div class="table-card">
		<div class="table-scroll">
			<table id="mthTbl">
				<thead>
					<tr>
						<th style="width:36px; text-align:center;"></th>
						<th style="width:44px; text-align:center;">순번</th>
						<th style="width:260px; text-align:center;">은행명</th>
						<th style="width:120px; text-align:center;">거래일자</th>
						<th style="width:120px; text-align:center;">거래시각</th>
						<th style="width:72px; text-align:center;">거래유형</th>
						<th style="text-align:center;">내용</th>
						<th style="width:90px; text-align:center;">항목</th>
						<th style="width:110px; text-align:center;">금액</th>
						<th style="width:110px; text-align:center;">잔액</th>
					</tr>
				</thead>
				<tbody id="mthTbody"></tbody>
			</table>
		</div>
	</div>
	
	<div id="pagination"></div>
	
</form>

<script>
	var pageIndex = 1;
	var pageSize = 10;
	
	var optionHtml = "";
	
	var accountList = []; // 계좌조회
	
	
	var currentMonth = new Date().toISOString().slice(0,7);
	
	var addRow = () => {

		var html = "";

		html += "<tr>";
		html += "	<td style='text-align:center'>";
		html += "		<input type='checkbox' class='chk'>";
		html += "		<input type='hidden' class='TRANID' name='TRANID[]'>";
		html += "	</td>";
		html += "	<td></td>";
		html += "	<td>";
		html += "		<select class='ACCOUNTNUM' name='ACCOUNTNUM[]'>";
		html += 			optionHtml;
		html += "		</select>";
		html += "	</td>";
		html += "	<td><input type='date' class='TRANDATE' name='TRANDATE[]'></td>";
		html += "	<td><input type='time' class='TRANTIME' name='TRANTIME[]' step='1'></td>";
		html += "	<td></td>";
		html += "	<td><input type='text' class='DESCRIPTION' name='DESCRIPTION[]'></td>";
		html += "	<td></td>";
		html += "	<td><input type='text' class='TRANAMOUNT' name='TRANAMOUNT[]'></td>";
		html += "</tr>";

		$("#mthTbody").append(html);
	}
	
	// 계좌 조회
	var loadAccountOptions = () => {
		$.ajax({
			url: "/svg/selectAccountList.do",
			type: "POST",
			success: function(res) {
				
				accountList = res;
				optionHtml = ""

				res.forEach(item => {
					let bankName = "";

					if(item.BANKNM === "KM") bankName = "국민";
					if(item.BANKNM === "SH") bankName = "신한";
					if(item.BANKNM === "WR") bankName = "우리";
					
					bankName += "(" + item.ACCOUNTNUM + ")"

					optionHtml += "<option value=\"" + item.ACCOUNTNUM + "\">" + bankName + "</option>";
				});
				
				loadList({
				    month: currentMonth,
				    searchKey: $("select[name='searchKey']").val(),
				    searchValue: $("[name='searchValue']").val()
				});
			}
		});
	}
	
	var save = () => {
		let insertList = [];
		let updateList = [];
		let valid = true;
		
		$("#mthTbody tr").each(function() {
			let $row = $(this);
			
			let tranId = $row.find(".TRANID").val();
			let accountNum = $row.find(".ACCOUNTNUM").val();
			let tranDate = $row.find(".TRANDATE").val();
			let tranTime = $row.find(".TRANTIME").val();  // 거래시각 추가
			let description = $row.find(".DESCRIPTION").val();
			let tranAmount = $row.find(".TRANAMOUNT").val();
			
			if (!accountNum && !tranDate && !tranTime && !description && !tranAmount) return;
			
			if(!accountNum.trim() || !tranDate.trim() || !tranTime.trim() || !description.trim() || !tranAmount.trim()) {
				alert("빈 행이 존재합니다. 모든 항목을 입력해주세요.");
				valid = false;
				return false;
			}
			
			let data = {
				TRANID: tranId,
				ACCOUNTNUM: accountNum,
				TRANDATE: tranDate,
				TRANTIME: tranTime,
				DESCRIPTION: description,
				TRANAMOUNT: tranAmount
			}
			
			if (tranId && tranId.trim() !== "") {
	            updateList.push(data);
	        } else {
	            insertList.push(data);
	        }
			
		});
		
		if (!valid) return;
		if (insertList.length === 0 && updateList.length === 0) return;
		
		$.ajax({
			url: "/use/saveHistory.do",
			type: "POST",
			contentType: "application/json; charset=utf-8",
			data: JSON.stringify({
	            insertList: insertList,
	            updateList: updateList
	        }),
			success: (res) => {
				alert("저장되었습니다.");
				
				let param = {
					searchKey: $("select[name='searchKey']").val(),
					searchValue: $("[name='searchValue']").val(),
					month: currentMonth
				};

				loadList(param);
				loadSummary();
			}
		})
	}
	
	var deleteRow = () => {
		let deleteList = [];
		let chkCnt = 0;
		
		$("#mthTbody tr").each(function () {
			let $row = $(this);

			let $chk = $row.find(".chk");

			if ($chk.is(":checked")) {
				chkCnt++;
				
				let tranId = $row.find(".TRANID").val();

				if (tranId) {
					deleteList.push(tranId);
				}
			}
		});
		
		if (chkCnt === 0) {
			alert("삭제할 항목을 선택하세요.");
			return;
		}
		
		$.ajax({
			url: "/use/deleteHistory.do",
			type: "POST",
			contentType: "application/json; charset=utf-8",
			data: JSON.stringify(deleteList),
			success: function (res) {
				alert("삭제되었습니다.");
				let param = {
					searchKey: $("select[name='searchKey']").val(),
					searchValue: $("[name='searchValue']").val(),
					month: currentMonth
				};

				loadList(param);
				loadSummary();
			},
			error: function () {
				alert("내역 삭제 중 오류가 발생했습니다.");
			}
		})
	}
	
	var search = () => {
		
		pageIndex = 1;
		
		let param = {
			searchKey: $("select[name='searchKey']").val(),
			searchValue: $("[name='searchValue']").val(),
			month: currentMonth
		};

		loadList(param);
		loadSummary();
		
	}
	
	var loadList = (param = {}) => {
		
		param.pageIndex = pageIndex;
		param.pageSize = pageSize;
		
		if (!param.month) {
		    param.month = currentMonth;
		}
		
		$.ajax({
		    url: "/use/selectHistoryListPaging.do",
		    type: "POST",
		    data: param,
		    success: function (res) {
		    	let list = res.list;
		        let totalCount = res.totalCount;
		        
		        drawTable(list);
		        drawPagination(totalCount);
		    }
		});
	}
	
	var loadSummary = () => {
		
	    $.ajax({
	        url: "/use/getMonthlySummary.do",
	        type: "POST",
	        data: { month: currentMonth },
	        success: function(res) {

	        	$("#income").text(formatNumber(res.income));
	            $("#expense").text(formatNumber(res.expense));
	            $("#balance").text(formatNumber(res.lastBalance));
	        }
	    });
	};
	
	var drawTable = (list) => {
		let html = "";
		list.forEach((item, index) => {
			
			let rowNum = (pageIndex - 1) * pageSize + (index + 1);
			
			html += "<tr>";
			html += "  <td style='text-align:center'>";
            html += "    <input type=\"checkbox\" class=\"chk\">"
            html += "    <input type=\"hidden\" class=\"TRANID\" name=\"TRANID[]\" value=\"" + item.TRANID + "\">"
            html += "  </td>"
            html += "  <td style='text-align:center'>" + rowNum + "</td>";
            html += "  <td>";
            html += "    <select class='ACCOUNTNUM' name='ACCOUNTNUM[]'>";

            accountList.forEach(opt => {
                let selected = (opt.ACCOUNTNUM === item.ACCOUNTNUM) ? "selected" : "";

                let bankName = "";

                if(opt.BANKNM === "KM") bankName = "국민";
                if(opt.BANKNM === "SH") bankName = "신한";
                if(opt.BANKNM === "WR") bankName = "우리";

                bankName += "(" + opt.ACCOUNTNUM + ")";

                html += "<option value='" + opt.ACCOUNTNUM + "' " + selected + ">"
                     + bankName +
                     "</option>";
            });

            html += "    </select>";
            html += "  </td>";
            html += "  <td><input type='date' class='TRANDATE' value='" + (item.TRANDATE || "") + "'></td>";
            html += "  <td><input type='time' class='TRANTIME' name='TRANTIME[]' value='" + (item.TRANTIME || "") + "' step='1'></td>";
            html += "  <td style='text-align:center;'><span class='" +
           			 ((item.TRANTYPE === "O") ? "badge badge-expense" : "badge badge-income") +
            			"'>" +
            		 ((item.TRANTYPE === "O") ? "출금" : "입금") +
            			"</span></td>";html += "  <td><input type='text' class='DESCRIPTION' value='" + (item.DESCRIPTION || "") + "'></td>";
            html += "  <td style='text-align:center;'>" + (item.CATEGORYNM || "") + "</td>";
            html += "  <td><input type='text' class='TRANAMOUNT' value='" + (item.TRANAMOUNT || "") + "'></td>";
            html += "  <td>" + item.TRANAFTAMOUNT + "</td>";
            html += "</tr>";
            
            
		});
		$("#mthTbody").html(html);
	}
	
	var drawPagination = (totalCount) => {

		let totalPage = Math.ceil(totalCount / pageSize);
		let html = "";

		for (let i = 1; i <= totalPage; i++) {
			if (i === pageIndex) {
				html += "<strong>" + i + "</strong> ";
			} else {
				html += "<a href='javascript:goPage(" + i + ")'>" + i + "</a> ";
			}
		}

		$("#pagination").html(html);
	};
	
	var goPage = (page) => {
		pageIndex = page;

		let param = {
			searchKey: $("select[name='searchKey']").val(),
			searchValue: $("[name='searchValue']").val(),
			month: currentMonth
		};

		loadList(param);
		loadSummary();
	};
	
	var changeSearchUI = () => {
		let key = $("select[name='searchKey']").val();
		let html = "";

		if (key === "bankNm") {
			html += `
				<select name="searchValue">
					<option value="">전체</option>
					<option value="KM">국민</option>
					<option value="SH">신한</option>
					<option value="WR">우리</option>
				</select>
			`;
		} else if(key === "tranType") {
			html += `
				<select name="searchValue">
					<option value="">전체</option>
					<option value="I">입금</option>
					<option value="O">출금</option>
				</select>
			`;
		} else if(key === "categoryId") {
			html += "<select name=\"searchValue\">";
			html += "<option value=\"\">전체</option>";
			html += "</select>";

			$("#searchArea").html(html);

			$.ajax({
				url: "/use/selectTranCategoryList.do",
				type: "POST",
				success: function(res) {
					let opt = "<option value=\"\">전체</option>";
					
					res.forEach(item => {
						opt += "<option value=\"" + item.CATEGORYID + "\">"
						opt += item.CATEGORYNM;
						opt += "</option>";
					});

					$("select[name='searchValue']").html(opt);
				}
			});
		} else {
			html += `<input type="text" name="searchValue">`;
		}

		$("#searchArea").html(html);
	};
	
	var renderMonth = () => {
	    $("#monthLabel").text(currentMonth);

	    loadList({
	        month: currentMonth,
	        searchKey: $("select[name='searchKey']").val(),
	        searchValue: $("[name='searchValue']").val()
	    });
	    
	    loadSummary();
	};

	// 이전 달로 이동하기
	var prevMonth = () => {
	    let d = new Date(currentMonth + "-01");
	    d.setMonth(d.getMonth() - 1);
	    currentMonth = d.toISOString().slice(0,7);

	    pageIndex = 1;
	    renderMonth();
	};

	// 다음 달로 이동하기
	var nextMonth = () => {
	    let d = new Date(currentMonth + "-01");
	    d.setMonth(d.getMonth() + 1);
	    currentMonth = d.toISOString().slice(0,7);

	    pageIndex = 1;
	    renderMonth();
	};
	
	// 숫자 포맷 함수 추가
	var formatNumber = (num) => {
	    return Number(num).toLocaleString('ko-KR');
	};
	
	$(document).ready(function() {
		changeSearchUI();
		$("#monthLabel").text(currentMonth);
		loadAccountOptions();
		loadSummary();
	});
	
	var parsedListTemp = [];
	
	// ── 모달 1: 업로드 모달 ──
	var openUploadModal = function() {
		if ($('#uploadModal').length === 0) {
			$('body').append(
				'<div class="modal-overlay" id="uploadModal">' +
				'  <div class="modal">' +
				'    <div class="modal-header">' +
				'      <h3>거래내역 업로드</h3>' +
				'      <button class="modal-close" onclick="closeUploadModal()">✕</button>' +
				'    </div>' +
				'    <div class="modal-body">' +
				'      <div class="modal-form-row">' +
				'        <label>은행 선택</label>' +
				'        <select id="uploadBank" onchange="loadUploadAccount()">' +
				'          <option value="">선택하세요</option>' +
				'          <option value="KM">국민</option>' +
				'          <option value="SH">신한</option>' +
				'          <option value="WR">우리</option>' +
				'        </select>' +
				'      </div>' +
	            '      <div class="modal-form-row">' +
	            '        <label>계좌 선택</label>' +
	            '        <select id="uploadAccount">' +
	            '          <option value="">은행을 먼저 선택하세요</option>' +
	            '        </select>' +
	            '      </div>' +
				'      <div class="modal-form-row">' +
				'        <label>파일 선택</label>' +
				'        <input type="file" id="uploadFile" accept=".xlsx,.xls">' +
				'      </div>' +
				'    </div>' +
				'    <div class="modal-footer">' +
				'      <button type="button" class="toolbar-btn toolbar-btn-danger" onclick="closeUploadModal()">취소</button>' +
				'      <button type="button" class="toolbar-btn toolbar-btn-primary" onclick="uploadExcel()">업로드</button>' +
				'    </div>' +
				'  </div>' +
				'</div>'
			);
		}
		$('#uploadModal').addClass('open');
	};

	// 은행 선택 시 계좌 목록 로드
	var loadUploadAccount = function() {
	    var bank = $('#uploadBank').val();
	    var opts = '<option value="">계좌를 선택하세요</option>';
	    if (bank) {
	        accountList.forEach(function(item) {
	            if (item.BANKNM === bank) {
	                opts += '<option value="' + item.ACCOUNTNUM + '">' + item.ACCOUNTNUM + '</option>';
	            }
	        });
	    }
	    $('#uploadAccount').html(opts);
	};
	
	var closeUploadModal = function() {
		$('#uploadModal').removeClass('open');
		$('#uploadBank').val('');
	    $('#uploadAccount').html('<option value="">은행을 먼저 선택하세요</option>');
		$('#uploadFile').val('');
	};

	// 2.미등록 사용처 모달
	var openUnregModal = function(unregList, parsedList) {
	    parsedListTemp = parsedList;
	
	    if ($('#unregModal').length === 0) {
	        $('body').append(
	            '<div class="modal-overlay" id="unregModal">' +
	            '  <div class="modal modal-lg">' +
	            '    <div class="modal-header">' +
	            '      <h3>미등록 사용처 확인</h3>' +
	            '      <button class="modal-close" onclick="closeUnregModal()">✕</button>' +
	            '    </div>' +
	            '    <div class="modal-body">' +
	            '      <div class="table-card">' +
	            '        <div class="table-scroll">' +
	            '          <table id="unregTbl">' +
	            '            <thead>' +
	            '              <tr>' +
	            '                <th style="text-align:center; padding:8px 10px; width:100px;">사용처명</th>' +
	            '                <th style="text-align:center; padding:8px 10px; width:100px;">카테고리</th>' +
	            '                <th style="text-align:center; padding:8px 10px; width:80px;">구분</th>' +
	            '              </tr>' +
	            '            </thead>' +
	            '            <tbody id="unregTbody"></tbody>' +
	            '          </table>' +
	            '        </div>' +
	            '      </div>' +
	            '    </div>' +
	            '    <div class="modal-footer">' +
	            '      <button type="button" class="toolbar-btn toolbar-btn-danger" onclick="closeUnregModal()">취소</button>' +
	            '      <button type="button" class="toolbar-btn toolbar-btn-primary" onclick="saveUnregAndUpload()">등록 후 저장</button>' +
	            '    </div>' +
	            '  </div>' +
	            '</div>'
	        );
	    }
	
	    var html = '';
	    unregList.forEach(function(usageNm) {
	        // parsedList에서 해당 사용처의 TRANTYPE 찾기
	        var tranType = 'O';
	        for (var i = 0; i < parsedList.length; i++) {
	            if (parsedList[i].DESCRIPTION === usageNm) {
	                tranType = parsedList[i].TRANTYPE;
	                break;
	            }
	        }
	        var badgeClass = tranType === 'O' ? 'badge badge-expense' : 'badge badge-income';
	        var badgeText  = tranType === 'O' ? '출금' : '입금';
	
	        html += '<tr>';
	        html += '  <td style="padding:6px 10px; text-align:center; vertical-align:middle; width:100px;">' + usageNm + '</td>';
	        html += '  <td style="padding:6px 10px; text-align:center; vertical-align:middle; width:100px;"><input type="text" class="unreg-category" placeholder="카테고리명 입력" style="font-family:inherit;font-size:13px;height:30px;padding:0 8px;border:1px solid var(--color-border);border-radius:6px;width:140px;"></td>';
	        html += '  <td style="padding:6px 10px; text-align:center; vertical-align:middle; width:80px;"><span class="' + badgeClass + '">' + badgeText + '</span></td>';
	        html += '</tr>';
	    });
	    $('#unregTbody').html(html);
	    $('#unregModal').addClass('open');
	};

	var closeUnregModal = function() {
		$('#unregModal').removeClass('open');
	};

	// ── 엑셀 업로드 ──
	var uploadExcel = function() {
	    var bank = $('#uploadBank').val();
	    var accountNum = $('#uploadAccount').val();
	    var file = $('#uploadFile')[0].files[0];
	
	    if (!bank) { alert('은행을 선택하세요.'); return; }
	    if (!accountNum) { alert('계좌를 선택하세요.'); return; }
	    if (!file) { alert('파일을 선택하세요.'); return; }
	
	    var formData = new FormData();
	    formData.append('bank', bank);
	    formData.append('accountNum', accountNum);
	    formData.append('file', file);
	    formData.append('month', currentMonth);
	
	    $.ajax({
	        url: '/use/uploadExcel.do',
	        type: 'POST',
	        data: formData,
	        processData: false,
	        contentType: false,
	        success: function(res) {
	            closeUploadModal();
	            if (res.unregList && res.unregList.length > 0) {
	                // 미등록 사용처 있으면 모달 오픈
	                openUnregModal(res.unregList, res.parsedList);
	            } else {
	                // 미등록 사용처 없으면 바로 저장
	                $.ajax({
	                    url: '/use/saveUnregAndUpload.do',
	                    type: 'POST',
	                    contentType: 'application/json; charset=utf-8',
	                    data: JSON.stringify({ unregList: [], parsedList: res.parsedList }),
	                    success: function() {
	                        alert('업로드가 완료되었습니다.');
	                        loadList({ month: currentMonth });
	                        loadSummary();
	                    },
	                    error: function() {
	                        alert('저장 중 오류가 발생했습니다.');
	                    }
	                });
	            }
	        },
	        error: function() {
	            alert('업로드 중 오류가 발생했습니다.');
	        }
	    });
	};
	
	// 미등록 사용처 등록 후 저장
	var saveUnregAndUpload = function() {
	    var unregList = [];
	    var valid = true;
	
	    $('#unregTbody tr').each(function() {
	        var $row = $(this);
	        var usageNm = $row.find('td:first').text().trim();
	        var categoryNm = $row.find('.unreg-category').val().trim();
	
	        if (!categoryNm) {
	            alert('카테고리명을 입력해주세요.');
	            valid = false;
	            return false;
	        }
	        unregList.push({ usageNm: usageNm, categoryNm: categoryNm });
	    });
	
	    if (!valid) return;
	
	    $.ajax({
	        url: '/use/saveUnregAndUpload.do',
	        type: 'POST',
	        contentType: 'application/json; charset=utf-8',
	        data: JSON.stringify({ unregList: unregList, parsedList: parsedListTemp }),
	        success: function(res) {
	            closeUnregModal();
	            alert('저장이 완료되었습니다.');
	            loadList({ month: currentMonth });
	            loadSummary();
	        },
	        error: function() {
	            alert('저장 중 오류가 발생했습니다.');
	        }
	    });
	};
</script>
</body>
</html>
