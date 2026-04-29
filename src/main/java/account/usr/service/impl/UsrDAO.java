package account.usr.service.impl;

import java.util.Map;

import org.egovframe.rte.psl.dataaccess.EgovAbstractMapper;
import org.springframework.stereotype.Repository;

@Repository("usrDAO")
public class UsrDAO extends EgovAbstractMapper  {

	Map<String, Object> selectUser(Map<String, Object> inputMap) throws Exception {
		return selectOne("UsrMapper.selectUser", inputMap); 
	}
	
	int updateUser(Map<String, Object> inputMap) throws Exception {
		return update("UsrMapper.updateUser", inputMap);
	}
}
