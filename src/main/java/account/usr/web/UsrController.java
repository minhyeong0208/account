package account.usr.web;

import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import account.com.service.SessionManager;
import account.usr.service.UsrService;

@Controller
@RequestMapping("/usr")
public class UsrController {
	
	@Resource(name = "usrService")
	private UsrService usrService;
	
	/**
	 * 내 정보
	 * @param inputMap
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/usr00m00.do")
	public String selectUsr00M00(@RequestParam Map<String, Object> inputMap, Model model) throws Exception {
		
		return "account/usr/usr00m00";
	}
	
	/**
	 * 내 정보/기본정보
	 * @param inputMap
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/usr00m01.do")
	public String selectUsr00M01(@RequestParam Map<String, Object> inputMap, Model model) throws Exception {
		
		Map<String, Object> data = usrService.selectUser(inputMap);
		
		model.addAttribute("USERNM", data.get("USERNM"));
		model.addAttribute("BIRTHDATE", data.get("BIRTHDATE"));
		model.addAttribute("PHONENUM", data.get("PHONENUM"));
		model.addAttribute("EMAIL", data.get("EMAIL"));
		model.addAttribute("REGDATE", data.get("REGDATE"));
		
		return "account/usr/usr00m01";
	}
	
	@RequestMapping(value = "/updateUser.do", method = RequestMethod.POST)
	@ResponseBody
	public String updateUser(@RequestParam Map<String, Object> inputMap) throws Exception {
		
		try {
			usrService.updateUser(inputMap);
			return "success";
		} catch (Exception e) {
			e.printStackTrace();
		}
		return "fail";
	}
	
	/**
	 * 내 정보/비밀번호 변경
	 * @param inputMap
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/usr00m02.do")
	public String selectUsr00M02(@RequestParam Map<String, Object> inputMap, Model model) throws Exception {
		
		return "account/usr/usr00m02";
	}
	
	@RequestMapping(value = "/updatePasswd.do", method = RequestMethod.POST)
	@ResponseBody
	public String updatePasswd(@RequestParam Map<String, Object> inputMap) throws Exception {
		
		try {
	        int result = usrService.updatePasswd(inputMap);
	        return result == 1 ? "success" : "fail";
	    } catch (Exception e) {
	        e.printStackTrace();
	        return "error";
	    }
	}
	
	/**
	 * 내 정보/회원탈퇴
	 * @param inputMap
	 * @param model
	 * @return
	 * @throws Exception
	 */
	@RequestMapping(value = "/usr00m03.do")
	public String selectUsr00M03(@RequestParam Map<String, Object> inputMap, Model model) throws Exception {
		
		return "account/usr/usr00m03";
	}
	
	@RequestMapping(value = "/deleteUser.do", method = RequestMethod.POST)
	@ResponseBody
	public String deleteUser(@RequestParam Map<String, Object> inputMap) throws Exception {
		
		try {
	        int result = usrService.deleteUser(inputMap);
	        if (result == 1) {
	        	SessionManager.invalidate();
	            return "success";
	        }
	        return "fail";
	    } catch (Exception e) {
	        e.printStackTrace();
	        return "error";
	    }
	}
	
}
