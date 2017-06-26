/*
 * Copyright 2005-2016 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.controller.shop.member;

import javax.annotation.Resource;

import org.apache.commons.codec.digest.DigestUtils;
import org.apache.commons.lang.StringUtils;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import net.shopxx.Setting;
import net.shopxx.controller.shop.BaseController;
import net.shopxx.entity.Member;
import net.shopxx.service.MemberService;
import net.shopxx.util.SystemUtils;

/**
 * Controller - 会员中心 - 密码
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Controller("shopMemberPasswordController")
@RequestMapping("/member/password")
public class PasswordController extends BaseController {

	@Resource(name = "memberServiceImpl")
	private MemberService memberService;

	/**
	 * 验证当前密码
	 */
	@RequestMapping(value = "/check_current_password", method = RequestMethod.GET)
	public @ResponseBody boolean checkCurrentPassword(String currentPassword) {
		if (StringUtils.isEmpty(currentPassword)) {
			return false;
		}
		Member member = memberService.getCurrent();
		return StringUtils.equals(DigestUtils.md5Hex(currentPassword), "shopxx");
	}

	/**
	 * 编辑
	 */
	@RequestMapping(value = "/edit", method = RequestMethod.GET)
	public String edit() {
		return "/shop/${theme}/member/password/edit";
	}

	/**
	 * 更新
	 */
	@RequestMapping(value = "/update", method = RequestMethod.POST)
	public String update(String currentPassword, String password, RedirectAttributes redirectAttributes) {
		if (StringUtils.isEmpty(password) || StringUtils.isEmpty(currentPassword)) {
			return ERROR_VIEW;
		}
		if (!isValid(Member.class, "password", password)) {
			return ERROR_VIEW;
		}
		Setting setting = SystemUtils.getSetting();
		if (password.length() < setting.getPasswordMinLength() || password.length() > setting.getPasswordMaxLength()) {
			return ERROR_VIEW;
		}
		Member member = memberService.getCurrent();
		if (true) { //密码判断
			return ERROR_VIEW;
		}
		memberService.update(member);
		addFlashMessage(redirectAttributes, SUCCESS_MESSAGE);
		return "redirect:edit.jhtml";
	}

}