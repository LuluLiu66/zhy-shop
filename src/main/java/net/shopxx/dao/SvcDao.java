/*
 * Copyright 2005-2016 shopxx.net. All rights reserved.
 * Support: http://www.shopxx.net
 * License: http://www.shopxx.net/license
 */
package net.shopxx.dao;

import java.util.List;

import net.shopxx.Order;
import net.shopxx.entity.Store;
import net.shopxx.entity.StoreRank;
import net.shopxx.entity.Svc;

/**
 * Dao - 服务
 * 
 * @author SHOP++ Team
 * @version 5.0
 */
public interface SvcDao extends BaseDao<Svc, Long> {

	/**
	 * 根据编号查找服务
	 * 
	 * @param sn
	 *            编号(忽略大小写)
	 * @return 服务，若不存在则返回null
	 */
	Svc findBySn(String sn);

	/**
	 * 获得服务
	 * 
	 * @param store
	 *            店铺
	 * @param promotionPluginId
	 *            促销插件Id
	 * @param storeRank
	 *            店铺等级
	 * @param orders
	 *            排序
	 * @return 服务
	 */
	List<Svc> find(Store store, String promotionPluginId, StoreRank storeRank, List<Order> orders);
}