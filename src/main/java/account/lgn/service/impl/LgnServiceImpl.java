package account.lgn.service.impl;

import java.util.HashMap;
import java.util.Map;

import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import account.lgn.service.LgnService;
import javax.annotation.Resource;

@Service("lgnService")
public class LgnServiceImpl extends EgovAbstractServiceImpl implements LgnService {

	@Resource(name = "lgnDAO")
    private LgnDAO lgnDAO;

	
	/**
	 * 로그인
	 */
	@Override
	public Map<String, Object> login(Map<String, Object> paramMap) throws Exception {

		BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();
		
		Map<String, Object> resMap = lgnDAO.selectLogin(paramMap);

		Map<String, Object> result = new HashMap<>();
		if(resMap != null && resMap.get("USERID") != null) {
			String inputPw = (String) paramMap.get("PASSWD");
	        String savedPw = (String) resMap.get("PASSWD");
	        
	        if(passwordEncoder.matches(inputPw, savedPw)) {
				result.put("result", "success");
				result.put("USERID", resMap.get("USERID"));
				result.put("USERNM", resMap.get("USERNM"));
	        } else {
	            result.put("result", "fail");  // 비밀번호 불일치
	        }
		} else {
			result.put("result", "fail"); // 아이디 없음
		}
		return result;
	}
	
	/**
	 * 아이디 중복체크
	 */
	@Override
	public int dupCheckId(Map<String, Object> inputMap) throws Exception {
		
		return lgnDAO.dupCheckId(inputMap);
	}
	
	/**
	 * 회원가입
	 */
	@Override
	public int insertUser(Map<String, Object> inputMap) throws Exception {

		BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();
		
		String encodedPw = passwordEncoder.encode((String) inputMap.get("PASSWD"));
		
		inputMap.put("PASSWD", encodedPw);
		
		 
		return lgnDAO.insertUser(inputMap);
	}
}
