package account.lgn.web;

import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

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
	@RequestMapping("/login.do")
	public String loginPage(@RequestParam Map<String, Object> inputMap, Model model) throws Exception {

		return "account/lgn/lgn00m00";
	}
	
	@RequestMapping("/passLogin.do")
	public String passLogin(@RequestParam Map<String, Object> inputMap, Model model) throws Exception {

		Map<String, Object> result = lgnService.login(inputMap);

		if("success".equals(result.get("result"))) {
			SessionManager.setAttribute("USERID", result.get("userid"));
			return "redirect:/com/main.do";
		} else {
			model.addAttribute("errorMsg", "아이디 또는 비밀번호가 틀렸습니다.");
			return "account/lgn/lgn00m00";
		}
	}
}
