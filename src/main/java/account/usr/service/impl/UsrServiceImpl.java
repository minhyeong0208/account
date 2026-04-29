package account.usr.service.impl;

import java.util.Map;

import javax.annotation.Resource;

import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
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
	
	@Override
	public int updatePasswd(Map<String, Object> inputMap) throws Exception {

		BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();

		inputMap.put("USERID", SessionManager.getAttribute("USERID"));
		
		String storedPw = usrDAO.selectPasswd(inputMap);
		
		if (!passwordEncoder.matches((String) inputMap.get("CURPASSWD"), storedPw)) {
	        return 0;
	    }
		
		String encodedNew = passwordEncoder.encode((String) inputMap.get("NEWPASSWD"));
	    inputMap.put("NEWPASSWD", encodedNew);
	    
	    usrDAO.updatePasswd(inputMap);
		
		return 1;
	}
	
	@Override
	public int deleteUser(Map<String, Object> inputMap) throws Exception {

		BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();

		inputMap.put("USERID", SessionManager.getAttribute("USERID"));
		
		String storedPw = usrDAO.selectPasswd(inputMap);
		
		if (!passwordEncoder.matches((String) inputMap.get("PASSWD"), storedPw)) {
	        return 0;
	    }
		
		usrDAO.deleteUser(inputMap);
		
		return 1;
	}
}
