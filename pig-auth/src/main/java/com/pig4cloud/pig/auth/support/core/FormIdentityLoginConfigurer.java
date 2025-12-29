package com.pig4cloud.pig.auth.support.core;

import com.pig4cloud.pig.auth.support.handler.FormAuthenticationFailureHandler;
import com.pig4cloud.pig.auth.support.handler.FormAuthenticationSuccessHandler;
import com.pig4cloud.pig.auth.support.handler.SsoLogoutSuccessHandler;
import org.springframework.security.config.annotation.web.builders.HttpSecurity;
import org.springframework.security.config.annotation.web.configurers.AbstractHttpConfigurer;
import org.springframework.util.StringUtils;

/**
 * 基于授权码模式的统一认证登录配置类，适用于Spring Security和SAS
 *
 * @author lengleng
 * @date 2025/05/30
 */
public final class FormIdentityLoginConfigurer
		extends AbstractHttpConfigurer<FormIdentityLoginConfigurer, HttpSecurity> {

	/**
	 * 网关地址，用于拼接登录页面完整路径
	 */
	private String gatewayUrl;

	/**
	 * 使用网关地址创建配置器
	 *
	 * @param gatewayUrl 网关地址，如 https://gateway.example.com
	 * @return FormIdentityLoginConfigurer 实例
	 */
	public static FormIdentityLoginConfigurer withGatewayUrl(String gatewayUrl) {
		return new FormIdentityLoginConfigurer().gatewayUrl(gatewayUrl);
	}

	/**
	 * 设置网关地址
	 *
	 * @param gatewayUrl 网关地址
	 * @return this
	 */
	public FormIdentityLoginConfigurer gatewayUrl(String gatewayUrl) {
		this.gatewayUrl = gatewayUrl;
		return this;
	}

	@Override
	public void init(HttpSecurity http) throws Exception {
		// 拼接登录页面路径：网关地址 + /token/login
		String loginPage = StringUtils.hasText(gatewayUrl) ? gatewayUrl + "/auth/token/login" : "/token/login";

		http.formLogin(formLogin -> {
					formLogin.loginPage(loginPage);
					formLogin.loginProcessingUrl("/oauth2/form");
					formLogin.failureHandler(new FormAuthenticationFailureHandler(gatewayUrl));
					formLogin.successHandler(new FormAuthenticationSuccessHandler(gatewayUrl));
				})
				.logout(logout -> logout.logoutUrl("/oauth2/logout")
						.logoutSuccessHandler(new SsoLogoutSuccessHandler())
						.deleteCookies("JSESSIONID")
						.invalidateHttpSession(true))

				.csrf(AbstractHttpConfigurer::disable);
	}

}
