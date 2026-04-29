package account.usr.service.impl;

import java.util.Map;

import javax.annotation.Resource;

import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.springframework.stereotype.Service;

import account.com.service.SessionManager;
import account.usr.service.UsrService;

@Service("usrService")
public class UsrServiceImpl extends EgovAbstractServiceImpl implements UsrService {

	@Resource(name = "usrDAO")
    private UsrDAO usrDAO;
	
	@Override
	public Map<String, Object> selectUser(Map<String, Object> inputMap) throws Exception {

		return usrDAO.selectUser(inputMap);
	}
	
	@Override
	public int updateUser(Map<String, Object> inputMap) throws Exception {
		
		String userId = (String) SessionManager.getAttribute("USERID");
	
		inputMap.put("USERID", userId);
		
		return usrDAO.updateUser(inputMap);
	}
}
