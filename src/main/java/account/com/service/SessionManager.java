package account.com.service;

import javax.servlet.http.HttpSession;

import org.springframework.web.context.request.RequestContextHolder;
import org.springframework.web.context.request.ServletRequestAttributes;

public class SessionManager {

    private static HttpSession getSession() {
        ServletRequestAttributes attrs = (ServletRequestAttributes) RequestContextHolder.getRequestAttributes();
        return attrs.getRequest().getSession(true);
    }

    public static void setAttribute(String key, Object value) {
        getSession().setAttribute(key, value);
    }

    public static Object getAttribute(String key) {
        return getSession().getAttribute(key);
    }

    public static void removeAttribute(String key) {
        getSession().removeAttribute(key);
    }

    public static void invalidate() {
        HttpSession session = getSession();
        if (session != null) {
            session.invalidate();
        }
    }
}
