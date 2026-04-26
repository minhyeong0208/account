package account.lgn.service.impl;

import java.util.Map;

import org.egovframe.rte.psl.dataaccess.EgovAbstractMapper;
import org.springframework.stereotype.Repository;

@Repository("lgnDAO")
public class LgnDAO extends EgovAbstractMapper {

	Map<String, Object> selectLogin(Map<String, Object> paramMap) throws Exception {
    	return selectOne("LoginMapper.selectLogin", paramMap);
    }
}
