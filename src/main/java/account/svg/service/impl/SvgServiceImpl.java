package account.svg.service.impl;

import java.time.YearMonth;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.springframework.stereotype.Service;

import account.com.service.SessionManager;
import account.svg.service.SvgService;

@Service("svgService")
public class SvgServiceImpl extends EgovAbstractServiceImpl implements SvgService {

	@Resource(name = "svgDAO")
	private SvgDAO svgDAO;
	
	/**
	 * 사용처목록 조회
	 */
	@Override
	public List<Map<String, Object>> selectCategoryList(Map<String, Object> inputMap) throws Exception {
		
		inputMap.put("USERID", SessionManager.getAttribute("USERID"));
		
		return svgDAO.selectCategoryList(inputMap);
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public void saveCategory(Map<String, Object> inputMap) throws Exception {
		
		List<Map<String, Object>> insertList = (List<Map<String, Object>>) inputMap.get("insertList");
		List<Map<String, Object>> updateList = (List<Map<String, Object>>) inputMap.get("updateList");

		String userId = (String) SessionManager.getAttribute("USERID");
		
		if (insertList != null) {
	        for (Map<String, Object> map : insertList) {
	            map.put("USERID", userId);
	            map.put("REGID", userId);
	            svgDAO.insertCategory(map);
	        }
	    }

		if (updateList != null) {
	        for (Map<String, Object> map : updateList) {
	            map.put("USERID", userId);
	            map.put("MODID", userId);
	            svgDAO.updateCategory(map);
	        }
	    }
	}
	
	@Override
	public void deleteCategory(List<String> inputList) throws Exception {
		
		for(String id: inputList) {
			Map<String, Object> paramMap = new HashMap<String, Object>();
			
			paramMap.put("USERID", SessionManager.getAttribute("USERID"));
			paramMap.put("CATEGORYID", id);
			svgDAO.deleteCategory(paramMap);
		}
		
	}
	
	@Override
	public List<Map<String, Object>> selectAccountListPaging(Map<String, Object> inputMap) throws Exception {
		
		inputMap.put("USERID", SessionManager.getAttribute("USERID"));

	    int pageIndex = Integer.parseInt(inputMap.get("pageIndex").toString());
	    int pageSize = Integer.parseInt(inputMap.get("pageSize").toString());

	    int offset = (pageIndex - 1) * pageSize;

	    inputMap.put("offset", offset);
	    inputMap.put("limit", pageSize);

	    return svgDAO.selectAccountListPaging(inputMap);
	}
	
	@SuppressWarnings("unchecked")
	@Override
	public void saveAccount(Map<String, Object> inputMap) throws Exception {
		
		List<Map<String, Object>> insertList = (List<Map<String, Object>>) inputMap.get("insertList");
		List<Map<String, Object>> updateList = (List<Map<String, Object>>) inputMap.get("updateList");
		
		String userId = (String) SessionManager.getAttribute("USERID");
		
		if (insertList != null) {
	        for (Map<String, Object> map : insertList) {
	            map.put("USERID", userId);
	            map.put("REGID", userId);
	            svgDAO.insertAccount(map);
	        }
	    }

		if (updateList != null) {
	        for (Map<String, Object> map : updateList) {
	            map.put("USERID", userId);
	            map.put("MODID", userId);
	            svgDAO.updateAccount(map);
	        }
	    }
		
	}
	
	@Override
	public void deleteAccount(List<String> inputList) throws Exception {
		
		for(String id: inputList) {
			Map<String, Object> paramMap = new HashMap<String, Object>();
			
			paramMap.put("USERID", SessionManager.getAttribute("USERID"));
			paramMap.put("ACCOUNTID", id);
			svgDAO.deleteAccount(paramMap);
		}
		
	}
	
	@Override
	public int selectAccountCnt(Map<String, Object> inputMap) throws Exception {
		
		inputMap.put("USERID", SessionManager.getAttribute("USERID"));

	    return svgDAO.selectAccountCnt(inputMap);
	}
	
	@Override
	public List<Map<String, Object>> selectAccountList(Map<String, Object> inputMap) throws Exception {
		
		inputMap.put("USERID", SessionManager.getAttribute("USERID"));
		
		return svgDAO.selectAccountList(inputMap);
	}
	
	@Override
	public int insertSavings(Map<String, Object> inputMap) throws Exception {
		
		inputMap.put("USERID", SessionManager.getAttribute("USERID"));
		
		// 1. 적금 기본 정보 INSERT
		int res = svgDAO.insertSavings(inputMap);
		
		if(res > 0) {
			String joinDate = (String) inputMap.get("JOINDATE");  // 적금가입일
			String expireDate = (String) inputMap.get("EXPIRATIONDATE");  // 적금만기일
			
			YearMonth start = YearMonth.parse(joinDate.substring(0, 7));
			YearMonth end   = YearMonth.parse(expireDate.substring(0, 7));
			
			YearMonth cur = start;
			while (!cur.isAfter(end)) {
	            Map<String, Object> history = new HashMap<>();
	            history.put("SAVINGSID",  inputMap.get("SAVINGSID"));
	            history.put("USERID",     inputMap.get("USERID"));
	            history.put("PAYMONTH",   cur.toString());
	            history.put("PAYAMOUNT",  inputMap.get("PAYMENTAMOUNT"));

	            svgDAO.insertSavingsHistoryBatch(history);

	            cur = cur.plusMonths(1);
	        }
			
			
		}
		
		return res;
	}
	
	@Override
	public List<Map<String, Object>> selectSavingsList(Map<String, Object> inputMap) throws Exception {
		
		inputMap.put("USERID", SessionManager.getAttribute("USERID"));
		
		List<Map<String, Object>> savingsList = svgDAO.selectSavingsList(inputMap);
		
		for (Map<String, Object> s : savingsList) {
		    int totalMonths   = Integer.parseInt(s.get("TOTAL_MONTHS").toString());
		    int paidMonths    = Integer.parseInt(s.get("PAID_MONTHS").toString());
		    long paymentAmt   = Long.parseLong(s.get("PAYMENTAMOUNT").toString());
		    double rate       = Double.parseDouble(s.get("INTERESTRATE").toString());

		    // 진행률
		    int pct = totalMonths > 0 ? (int)((paidMonths * 100.0) / totalMonths) : 0;
		    s.put("PROGRESS_PCT", pct);

		    // 예상 수령액 (단리)
		    long principal = paymentAmt * totalMonths;
		    long interest  = (long)(principal * (rate / 100));
		    s.put("EXPECTED_AMOUNT", principal + interest);
		}
		
		return savingsList;
	}
}
