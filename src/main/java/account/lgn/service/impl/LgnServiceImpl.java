package account.lgn.service.impl;

import java.util.HashMap;
import java.util.Map;
import java.util.Random;

import org.egovframe.rte.fdl.cmmn.EgovAbstractServiceImpl;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Service;

import account.lgn.service.LgnService;
import javax.annotation.Resource;
import javax.mail.internet.MimeMessage;

@Service("lgnService")
public class LgnServiceImpl extends EgovAbstractServiceImpl implements LgnService {

	@Resource(name = "lgnDAO")
    private LgnDAO lgnDAO;

	@Resource(name = "mailSender")
	private JavaMailSender mailSender;
	
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
	
	@Override
	public void sendTempPassword(Map<String, Object> inputMap) throws Exception {
		
		int cnt = lgnDAO.selectUserByIdAndEmail(inputMap);
		
		if (cnt == 0) {
			throw new Exception("일치하는 회원 정보가 없습니다.");
		}
		
		String chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789";
	    StringBuilder sb = new StringBuilder();
	    Random random = new java.util.Random();
	    for (int i = 0; i < 8; i++) {
	        sb.append(chars.charAt(random.nextInt(chars.length())));
	    }
	    
	    // 임시 비밀번호 생성 (영문+숫자 8자리)
	    String tempPw = sb.toString();
	    BCryptPasswordEncoder passwordEncoder = new BCryptPasswordEncoder();
	    inputMap.put("PASSWD", passwordEncoder.encode(tempPw));
	    lgnDAO.updatePassword(inputMap);
	    
	    // 메일 발송
	    MimeMessage message = mailSender.createMimeMessage();
	    MimeMessageHelper helper = new MimeMessageHelper(message, true, "UTF-8");

	    helper.setTo((String) inputMap.get("EMAIL"));
	    helper.setSubject("[가계부] 임시 비밀번호 발급");
	    helper.setText(
	        "<h3>임시 비밀번호가 발급되었습니다.</h3>" +
	        "<p>임시 비밀번호: <strong>" + tempPw + "</strong></p>" +
	        "<p>로그인 후 반드시 비밀번호를 변경해주세요.</p>",
	        true
	    );

	    mailSender.send(message);
	}
}
