package account.lgn.service.impl;

import java.util.HashMap;
import java.util.Map;

import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
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

		Map<String, Object> resMap = lgnDAO.selectLogin(paramMap);

		Map<String, Object> result = new HashMap<>();
		if(resMap != null && resMap.get("USERID") != null) {
			result.put("result", "success");
			result.put("userid", resMap.get("USERID"));
			result.put("usernm", resMap.get("USERNM"));
		} else {
			result.put("result", "fail");
		}
		return result;
	}
}
