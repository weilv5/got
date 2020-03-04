package com.jsict.biz.security;

import com.jsict.framework.core.security.model.IUser;
import org.apache.commons.lang3.StringUtils;
import org.apache.shiro.SecurityUtils;
import org.apache.shiro.subject.Subject;
import org.apache.shiro.web.filter.authz.RolesAuthorizationFilter;

import javax.servlet.ServletRequest;
import javax.servlet.ServletResponse;
import javax.servlet.http.HttpServletRequest;
import java.io.IOException;

/**
 * 自定义权限过滤器，访问某个资源时只要其中有一个允许的角色即可
 * 
 * @author Chenjian
 *
 */
public class RolesOrAuthorizationFilter extends RolesAuthorizationFilter {

	@Override
	public boolean isAccessAllowed(ServletRequest request,
			ServletResponse response, Object mappedValue) throws IOException {
		Subject subject = getSubject(request, response);
		String[] rolesArray = (String[]) mappedValue;
        Subject currentUser = SecurityUtils.getSubject();
		IUser user = (IUser)currentUser.getPrincipal();
		if(user==null)
			return true;
		if(user.isAdmin()!=null && user.isAdmin())
			return true;
		if (rolesArray == null || rolesArray.length == 0) {
			// no roles specified, so nothing to check - allow access.
			return true;
		}
		boolean perm = false;
		for(String role : rolesArray){
			if(subject.hasRole(role)){
				perm = true;
				break;
			}
		}
		return perm;
	}

	/**
	 * 重写 <code>org.apache.shiro.web.filter.PathMatchingFilter#pathsMatch(String, ServletRequest)</code>，<br>
     * 实现对URL参数的权限管理
     * @see org.apache.shiro.web.filter.PathMatchingFilter#pathsMatch(String, ServletRequest)
	 *
	 * @param path   路径
	 * @param request  ServletRequest
	 * @return  权限中是否包含该路径
	 */
	@Override
	protected boolean pathsMatch(String path, ServletRequest request) {
		String requestURI = getPathWithinApplication(request);
		HttpServletRequest req = (HttpServletRequest)request;
		String requestQuery = req.getQueryString();
		if(StringUtils.isNotBlank(requestQuery))
			requestURI += "?" + requestQuery;
		return pathsMatch(path, requestURI);
	}

}
