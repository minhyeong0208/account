package account.lgn.service.impl;

import java.util.Map;

import org.egovframe.rte.psl.dataaccess.EgovAbstractMapper;
import org.springframework.stereotype.Repository;

@Repository("lgnDAO")
public class LgnDAO extends EgovAbstractMapper {

	Map<String, Object> selectLogin(Map<String, Object> inputMap) throws Exception {
    	return selectOne("LoginMapper.selectLogin", inputMap);
    }
	
	
	int dupCheckId(Map<String, Object> inputMap) throws Exception {
		return selectOne("LoginMapper.dupCheckId", inputMap);
	}
	
	int insertUser(Map<String, Object> inputMap) throws Exception {
		return insert("LoginMapper.insertUser", inputMap);
	}
	
	int selectUserByIdAndEmail(Map<String, Object> inputMap) throws Exception {
		return selectOne("LoginMapper.selectUserByIdAndEmail", inputMap);
	}
	
	int updatePassword(Map<String, Object> inputMap) throws Exception {
		return update("LoginMapper.updatePassword", inputMap);
	}
}
