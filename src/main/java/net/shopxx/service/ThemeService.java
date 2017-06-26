/*
 * Copyright 2005-2016 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.service;

import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import net.shopxx.Theme;

/**
 * Service - 主题
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
public interface ThemeService {

	/**
	 * 获取所有主题
	 * 
	 * @return 所有主题
	 */
	List<Theme> getAll();

	/**
	 * 获取主题
	 * 
	 * @param id
	 *            ID
	 * @return 主题
	 */
	Theme get(String id);

	/**
	 * 上传主题
	 * 
	 * @param multipartFile
	 *            上传文件
	 * @return 是否上传成功
	 */
	boolean upload(MultipartFile multipartFile);

}