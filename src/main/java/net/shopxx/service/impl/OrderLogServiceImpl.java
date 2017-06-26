/*
 * Copyright 2005-2016 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.service.impl;

import org.springframework.stereotype.Service;

import net.shopxx.entity.OrderLog;
import net.shopxx.service.OrderLogService;

/**
 * Service - 订单记录
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
@Service("orderLogServiceImpl")
public class OrderLogServiceImpl extends BaseServiceImpl<OrderLog, Long> implements OrderLogService {

}