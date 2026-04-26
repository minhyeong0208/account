package account.svg.service.impl;

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
}
