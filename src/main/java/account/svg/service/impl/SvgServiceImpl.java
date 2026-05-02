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
			YearMonth end   = YearMonth.parse(expireDate.substring(0, 7)).minusMonths(1);
			
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
	    
	    svgDAO.updateExpiredSavings(inputMap);
	    
	    List<Map<String, Object>> savingsList = svgDAO.selectSavingsList(inputMap);

	    for (Map<String, Object> s : savingsList) {
	        int totalMonths = Integer.parseInt(s.get("TOTAL_MONTHS").toString());
	        int paidMonths  = Integer.parseInt(s.get("PAID_MONTHS").toString());
	        long paymentAmt = Long.parseLong(s.get("PAYMENTAMOUNT").toString());
	        double rate     = Double.parseDouble(s.get("INTERESTRATE").toString());

	        // 진행률
	        int pct = totalMonths > 0 ? (int)((paidMonths * 100.0) / totalMonths) : 0;
	        s.put("PROGRESS_PCT", pct);

	        // 예상 수령액 (적금 단리)
	        double monthlyRate = rate / 100 / 12;
	        long totalInterest = 0;
	        for (int i = totalMonths - 1; i >= 1; i--) {
	            totalInterest += (long)(paymentAmt * monthlyRate * i);
	        }
	        long principal = paymentAmt * totalMonths;
	        s.put("EXPECTED_AMOUNT",   principal + totalInterest);
	    }

	    return savingsList;
	}
	
	@Override
	public Map<String, Object> selectSavingsSummary(Map<String, Object> inputMap) throws Exception {

	    inputMap.put("USERID", SessionManager.getAttribute("USERID"));
	    List<Map<String, Object>> savingsList = svgDAO.selectSavingsList(inputMap);

	    int activeCount   = 0;
	    long totalMonthly = 0;
	    long totalPaid    = 0;
	    long totalExpect  = 0;

	    for (Map<String, Object> s : savingsList) {
	        long paymentAmt = Long.parseLong(s.get("PAYMENTAMOUNT").toString());
	        int totalMonths = Integer.parseInt(s.get("TOTAL_MONTHS").toString());
	        double rate     = Double.parseDouble(s.get("INTERESTRATE").toString());

	        // 예상 수령액 (적금 단리)
	        double monthlyRate = rate / 100 / 12;
	        long totalInterest = 0;
	        for (int i = totalMonths - 1; i >= 1; i--) {
	            totalInterest += (long)(paymentAmt * monthlyRate * i);
	        }
	        long principal = paymentAmt * totalMonths;
	        long expected  = principal + totalInterest;

	        if ("A".equals(s.get("STATUS"))) {
	            activeCount++;
	            totalMonthly += paymentAmt;
	        }
	        totalPaid   += Long.parseLong(s.get("TOTAL_PAID_AMOUNT").toString());
	        totalExpect += expected;
	    }

	    Map<String, Object> summary = new HashMap<>();
	    summary.put("ACTIVE_COUNT",  activeCount);
	    summary.put("TOTAL_MONTHLY", totalMonthly);
	    summary.put("TOTAL_PAID",    totalPaid);
	    summary.put("TOTAL_EXPECT",  totalExpect);

	    return summary;
	}
	
	@Override
	public int deleteSavings(Map<String, Object> inputMap) throws Exception {
		
		inputMap.put("USERID", SessionManager.getAttribute("USERID"));
		
		svgDAO.deleteSavings(inputMap);
		
		return svgDAO.deleteSavingsDetail(inputMap);
	}
	
	@Override
	public Map<String, Object> selectSavingsOne(Map<String, Object> inputMap) throws Exception {

	    inputMap.put("USERID", SessionManager.getAttribute("USERID"));
	    Map<String, Object> savings = svgDAO.selectSavingsOne(inputMap);

	    int totalMonths = Integer.parseInt(savings.get("TOTAL_MONTHS").toString());
	    int paidMonths  = Integer.parseInt(savings.get("PAID_MONTHS").toString());
	    long paymentAmt = Long.parseLong(savings.get("PAYMENTAMOUNT").toString());
	    double rate     = Double.parseDouble(savings.get("INTERESTRATE").toString());

	    // 진행률
	    int pct = totalMonths > 0 ? (int)((paidMonths * 100.0) / totalMonths) : 0;

	    // 예상 수령액 (적금 단리)
	    double monthlyRate = rate / 100 / 12;
	    long totalInterest = 0;
	    for (int i = totalMonths - 1; i >= 1; i--) {
	        totalInterest += (long)(paymentAmt * monthlyRate * i);
	    }
	    long principal = paymentAmt * totalMonths;

	    savings.put("PROGRESS_PCT",      pct);
	    savings.put("EXPECTED_AMOUNT",   principal + totalInterest);
	    savings.put("EXPECTED_INTEREST", totalInterest);

	    return savings;
	}
	
	@Override
	public List<Map<String, Object>> selectSavingsDetail(Map<String, Object> inputMap) throws Exception {

		inputMap.put("USERID", SessionManager.getAttribute("USERID"));
		
		return svgDAO.selectSavingsDetail(inputMap);
	}
	
	@Override
	public int updateIsPaid(Map<String, Object> inputMap) throws Exception {
		
		inputMap.put("USERID", SessionManager.getAttribute("USERID"));
		
		return svgDAO.updateIsPaid(inputMap);
	}
	
	@Override
	public int insertAddSavingsHistory(Map<String, Object> inputMap) throws Exception {

		inputMap.put("USERID", SessionManager.getAttribute("USERID"));
		
		return svgDAO.insertAddSavingsHistory(inputMap);
	}
	
	@Override
	public int deleteAddSavings(Map<String, Object> inputMap) throws Exception {

		inputMap.put("USERID", SessionManager.getAttribute("USERID"));
		
		return svgDAO.deleteAddSavingsDetail(inputMap);
	}
	
	@Override
	public Map<String, Object> selectExtraDetail(Map<String, Object> inputMap) throws Exception {

		inputMap.put("USERID", SessionManager.getAttribute("USERID"));
	    
	    List<Map<String, Object>> detail = svgDAO.selectSavingsDetail(inputMap);

	    long totalAmount = 0;
	    for (Map<String, Object> d : detail) {
	        totalAmount += Long.parseLong(d.get("PAYAMOUNT").toString());
	    }

	    Map<String, Object> result = new HashMap<>();
	    result.put("detail",           detail);
	    result.put("extraTotalAmount", totalAmount);
	    result.put("extraCount",       detail.size());

	    return result;
	}
}
