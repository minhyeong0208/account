package account.lgn.web;

import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import account.com.service.SessionManager;
import account.lgn.service.LgnService;

@Controller
@RequestMapping("/lgn")
public class LgnController {

	@Resource(name = "lgnService")
	private LgnService lgnService;

	/**
	 * 로그인 화면
	 * @param inputMap
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/login.do")
	public String loginPage(@RequestParam Map<String, Object> inputMap, Model model) throws Exception {

		return "account/lgn/lgn00m00";
	}
	
	@RequestMapping(value = "/passLogin.do", method = RequestMethod.POST)
	public String passLogin(@RequestParam Map<String, Object> inputMap, RedirectAttributes redirectAttributes) throws Exception {
		
		Map<String, Object> result = lgnService.login(inputMap);

		if("success".equals(result.get("result"))) {
			System.out.println("result="+result);
			SessionManager.setAttribute("USERID", result.get("USERID"));
			SessionManager.setAttribute("USERNM", result.get("USERNM"));
			
			return "redirect:/com/main.do";
		} else {
			redirectAttributes.addFlashAttribute("errorMsg", "아이디 또는 비밀번호가 틀렸습니다.");
			return "redirect:/lgn/login.do";
		}
	}
	
	/**
	 * 로그아웃
	 * @return
	 * @throws Exception
	 */
	@RequestMapping("/logout.do")
	public String logout() throws Exception {
	    SessionManager.removeAttribute("USERID");
	    SessionManager.removeAttribute("USERNAME");

	    return "redirect:/lgn/login.do";
	}
	
	/**
	 * 회원가입 페이지로 이동
	 * @param inputMap
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/register.do")
	public String registerPage(@RequestParam Map<String, Object> inputMap, Model model) throws Exception {
		
		return "account/lgn/lgn01m00";
	}
	
	/**
	 * 아이디 중복체크
	 * @param inputMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/dupCheckId.do")
	@ResponseBody
	public String dupCheckId(@RequestParam Map<String, Object> inputMap) throws Exception {
		
		int cnt = lgnService.dupCheckId(inputMap);
		
		if(cnt > 0) return "fail";
		else return "success";
	}
	
	/**
	 * 가입등록
	 * @param inputMap
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/passRegister.do")
	@ResponseBody
	public String passRegister(@RequestParam Map<String, Object> inputMap) throws Exception {
		
		try {
	        lgnService.insertUser(inputMap);
	        return "success";
	    } catch (Exception e) {
	        return "fail";
	    }
	}
	
	@RequestMapping(value = "/sendTempPassword.do")
	@ResponseBody
	public String sendTempPassword(@RequestParam Map<String, Object> inputMap) throws Exception {
		try {
		lgnService.sendTempPassword(inputMap);
		} catch (Exception e) {
			// TODO: handle exception
			e.printStackTrace();
		}
		return "success";
	}
}
