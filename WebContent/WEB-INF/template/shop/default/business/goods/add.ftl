[#escape x as x?html]
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<title>${message("shop.business.goods.add")}[#if showPowered][/#if]</title>
<link href="${base}/resources/shop/${theme}/css/common.css" rel="stylesheet" type="text/css" />
<link href="${base}/resources/shop/${theme}/css/business.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="${base}/resources/shop/${theme}/js/jquery.js"></script>
<script type="text/javascript" src="${base}/resources/shop/${theme}/js/jquery.tools.js"></script>
<script type="text/javascript" src="${base}/resources/shop/${theme}/js/jquery.validate.js"></script>
<script type="text/javascript" src="${base}/resources/shop/${theme}/js/webuploader.js"></script>
<script type="text/javascript" src="${base}/resources/shop/${theme}/ueditor/ueditor.js"></script>
<script type="text/javascript" src="${base}/resources/shop/${theme}/js/common.js"></script>
<script type="text/javascript" src="${base}/resources/shop/${theme}/js/input.js"></script>
<style type="text/css">
	.parameterTable table th {
		width: 146px;
	}
	
	.specificationTable span {
		padding: 10px;
	}
	
	.productTable td {
		border: 1px solid #dde9f5;
	}
</style>
<script type="text/javascript">
$().ready(function() {

	var $inputForm = $("#inputForm");
	var $isDefault = $("#isDefault");
	var $productCategoryId = $("#productCategoryId");
	var $type = $("#type");
	var $price = $("#price");
	var $cost = $("#cost");
	var $marketPrice = $("#marketPrice");
	var $rewardPoint = $("#rewardPoint");
	var $exchangePoint = $("#exchangePoint");
	var $stock = $("#stock");
	var $promotionIds = $("input[name='promotionIds']");
	var $introduction = $("#introduction");
	var $productImageTable = $("#productImageTable");
	var $addProductImage = $("#addProductImage");
	var $browserButton = $("a.browserButton");
	var $parameterTable = $("#parameterTable");
	var $addParameter = $("#addParameter");
	var $resetParameter = $("#resetParameter");
	var $attributeTable = $("#attributeTable");
	var $specificationTable = $("#specificationTable");
	var $resetSpecification = $("#resetSpecification");
	var $productTable = $("#productTable");
	var productImageIndex = 0;
	var parameterIndex = 0;
	var specificationItemEntryId = 0;
	var hasSpecification = false;
	var $pcProtocol = $("#pcProtocol");

	[@flash_message /]

	var previousProductCategoryId = getCookie("previousProductCategoryId");
	previousProductCategoryId != null ? $productCategoryId.val(previousProductCategoryId) : previousProductCategoryId = $productCategoryId.val();
	
	loadParameter();
	loadAttribute();
	loadSpecification();
	
	$introduction.editor();
	$pcProtocol.editor();

	// 文件上传
	$browserButton.uploader();
	
	// 商品分类
	$productCategoryId.change(function() {
		if ($attributeTable.find("select[value!='']").size() > 0) {
			$.dialog({
				type: "warn",
				content: "${message("shop.business.goods.productCategoryChangeConfirm")}",
				width: 450,
				onOk: function() {
					if ($parameterTable.find("input.parameterEntryValue[value!='']").size() == 0) {
						loadParameter();
					}
					loadAttribute();
					if ($productTable.find("input:text[value!='']").size() == 0) {
						loadSpecification();
					}
					previousProductCategoryId = $productCategoryId.val();
				},
				onCancel: function() {
					$productCategoryId.val(previousProductCategoryId);
				}
			});
		} else {
			if ($parameterTable.find("input.parameterEntryValue[value!='']").size() == 0) {
				loadParameter();
			}
			loadAttribute();
			if ($productTable.find("input:text[value!='']").size() == 0) {
				loadSpecification();
			}
			previousProductCategoryId = $productCategoryId.val();
		}
	});
	
	
	// 类型
	$type.change(function() {
		//预挂牌商品 显示 购买协议tab
		if($(this).val()==="listedtrade"){
			$("#purChaseProtocol").css("display","inline-block");
		}else{
			$("#purChaseProtocol").css("display","none");
		}
		
		changeView();
		buildProductTable();
	});
	if($type.val()==="listedtrade"){
		$("#purChaseProtocol").css("display","inline-block");
	}else{
		$("#purChaseProtocol").css("display","none");
	}
	
	// 修改视图
	function changeView() {
		if (hasSpecification) {
			$isDefault.prop("disabled", true);
			$price.add($cost).add($marketPrice).add($rewardPoint).add($exchangePoint).add($stock).prop("disabled", true).closest("tr").hide();
			switch ($type.val()) {
				case "listedtrade":
				case "general":
					$promotionIds.prop("disabled", false).closest("tr").show();
					break;
				case "exchange":
					$promotionIds.prop("disabled", true).closest("tr").hide();
					break;
				case "gift":
					$promotionIds.prop("disabled", true).closest("tr").hide();
					break;
			}
		} else {
			$isDefault.prop("disabled", false);
			$cost.add($marketPrice).add($stock).prop("disabled", false).closest("tr").show();
			switch ($type.val()) {
				case "listedtrade":
				case "general":
					$price.add($rewardPoint).add($promotionIds).prop("disabled", false).closest("tr").show();
					$exchangePoint.prop("disabled", true).closest("tr").hide();
					break;
				case "exchange":
					$price.add($rewardPoint).add($promotionIds).prop("disabled", true).closest("tr").hide();
					$exchangePoint.prop("disabled", false).closest("tr").show();
					break;
				case "gift":
					$price.add($rewardPoint).add($exchangePoint).add($promotionIds).prop("disabled", true).closest("tr").hide();
					break;
			}
		}
	}


	// 增加商品图片
	$addProductImage.click(function() {
		$productImageTable.append(
			[@compress single_line = true]
				'<tr>
					<td>
						<input type="file" name="productImages[' + productImageIndex + '].file" class="productImageFile" \/>
					<\/td>
					<td>
						<input type="text" name="productImages[' + productImageIndex + '].title" class="text" maxlength="200" \/>
					<\/td>
					<td>
						<input type="text" name="productImages[' + productImageIndex + '].order" class="text productImageOrder" maxlength="9" style="width: 50px;" \/>
					<\/td>
					<td>
						<a href="javascript:;" class="remove">[${message("shop.common.remove")}]<\/a>
					<\/td>
				<\/tr>'
			[/@compress]
		);
		productImageIndex ++;
	});
	
	// 删除商品图片
	$productImageTable.on("click", "a.remove", function() {
		$(this).closest("tr").remove();
	});


	// 增加参数
	$addParameter.click(function() {
		$(
			[@compress single_line = true]
				'<tr>
					<td colspan="2">
						<table>
							<tr>
								<th>
									${message("Parameter.group")}:
								<\/th>
								<td>
									<input type="text" name="parameterValues[' + parameterIndex + '].group" class="text parameterGroup" maxlength="200" \/>
								<\/td>
								<td>
									<a href="javascript:;" class="remove group">[${message("shop.common.remove")}]<\/a>
									<a href="javascript:;" class="add">[${message("shop.common.add")}]<\/a>
								<\/td>
							<\/tr>
							<tr>
								<th>
									<input type="text" name="parameterValues[' + parameterIndex + '].entries[0].name" class="text parameterEntryName" maxlength="200" style="width: 50px;" \/>
								<\/th>
								<td>
									<input type="text" name="parameterValues[' + parameterIndex + '].entries[0].value" class="text parameterEntryValue" maxlength="200" \/>
								<\/td>
								<td>
									<a href="javascript:;" class="remove">[${message("shop.common.remove")}]<\/a>
								<\/td>
							<\/tr>
						<\/table>
					<\/td>
				<\/tr>'
			[/@compress]
		).appendTo($parameterTable).find("table").data("parameterIndex", parameterIndex).data("parameterEntryIndex", 1);
		parameterIndex ++;
	});
	
	// 重置参数
	$resetParameter.click(function() {
		$.dialog({
			type: "warn",
			content: "${message("shop.business.goods.resetParameterConfirm")}",
			width: 450,
			onOk: function() {
				loadParameter();
			}
		});
	});
	
	// 删除参数
	$parameterTable.on("click", "a.remove", function() {
		var $this = $(this);
		if ($this.hasClass("group")) {
			$this.closest("table").closest("tr").remove();
		} else {
			if ($this.closest("table").find("tr").size() <= 2) {
				$.message("warn", "${message("shop.common.deleteAllNotAllowed")}");
				return false;
			}
			$this.closest("tr").remove();
		}
	});
	
	// 增加参数
	$parameterTable.on("click", "a.add", function() {
		var $table = $(this).closest("table");
		var parameterIndex = $table.data("parameterIndex");
		var parameterEntryIndex = $table.data("parameterEntryIndex");
		$table.append(
			[@compress single_line = true]
				'<tr>
					<th>
						<input type="text" name="parameterValues[' + parameterIndex + '].entries[' + parameterEntryIndex + '].name" class="text parameterEntryName" maxlength="200" style="width: 50px;" \/>
					<\/th>
					<td>
						<input type="text" name="parameterValues[' + parameterIndex + '].entries[' + parameterEntryIndex + '].value" class="text parameterEntryValue" maxlength="200" \/>
					<\/td>
					<td>
						<a href="javascript:;" class="remove">[${message("shop.common.remove")}]<\/a>
					<\/td>
				<\/tr>'
			[/@compress]
		);
		$table.data("parameterEntryIndex", parameterEntryIndex + 1);
	});
	
	// 加载参数
	function loadParameter() {
		$.ajax({
			url: "parameters.jhtml",
			type: "GET",
			data: {productCategoryId: $productCategoryId.val()},
			dataType: "json",
			success: function(data) {
				parameterIndex = 0;
				$parameterTable.find("tr:gt(0)").remove();
				$.each(data, function(i, parameter) {
					var $parameterGroupTable = $(
						[@compress single_line = true]
							'<tr>
								<td colspan="2">
									<table>
										<tr>
											<th>
												${message("Parameter.group")}:
											<\/th>
											<td>
												<input type="text" name="parameterValues[' + parameterIndex + '].group" class="text parameterGroup" value="' + escapeHtml(parameter.group) + '" maxlength="200" \/>
											<\/td>
											<td>
												<a href="javascript:;" class="remove group">[${message("shop.common.remove")}]<\/a>
												<a href="javascript:;" class="add">[${message("shop.common.add")}]<\/a>
											<\/td>
										<\/tr>
									<\/table>
								<\/td>
							<\/tr>'
						[/@compress]
					).appendTo($parameterTable).find("table").data("parameterIndex", parameterIndex);
					
					var parameterEntryIndex = 0;
					$.each(parameter.names, function(i, name) {
						$parameterGroupTable.append(
							[@compress single_line = true]
								'<tr>
									<th>
										<input type="text" name="parameterValues[' + parameterIndex + '].entries[' + parameterEntryIndex + '].name" class="text parameterEntryName" value="' + escapeHtml(name) + '" maxlength="200" style="width: 50px;" \/>
									<\/th>
									<td>
										<input type="text" name="parameterValues[' + parameterIndex + '].entries[' + parameterEntryIndex + '].value" class="text parameterEntryValue" maxlength="200" \/>
									<\/td>
									<td>
										<a href="javascript:;" class="remove">[${message("shop.common.remove")}]<\/a>
									<\/td>
								<\/tr>'
							[/@compress]
						);
						parameterEntryIndex ++;
					});
					$parameterGroupTable.data("parameterEntryIndex", parameterEntryIndex);
					parameterIndex ++;
				});
			}
		});
	}

	// 加载属性
	function loadAttribute() {
		$.ajax({
			url: "attributes.jhtml",
			type: "GET",
			data: {productCategoryId: $productCategoryId.val()},
			dataType: "json",
			success: function(data) {
				$attributeTable.empty();
				$.each(data, function(i, attribute) {
					var $select = $(
						[@compress single_line = true]
							'<tr>
								<th>' + escapeHtml(attribute.name) + ':<\/th>
								<td>
									<select name="attribute_' + attribute.id + '">
										<option value="">${message("shop.common.choose")}<\/option>
									<\/select>
								<\/td>
							<\/tr>'
						[/@compress]
					).appendTo($attributeTable).find("select");
					$.each(attribute.options, function(j, option) {
						$select.append('<option value="' + escapeHtml(option) + '">' + escapeHtml(option) + '<\/option>');
					});
				});
			}
		});
	}
	
	// 重置规格
	$resetSpecification.click(function() {
		$.dialog({
			type: "warn",
			content: "${message("shop.business.goods.resetSpecificationConfirm")}",
			width: 450,
			onOk: function() {
				hasSpecification = false;
				changeView();
				loadSpecification();
			}
		});
	});
	
	// 选择规格
	$specificationTable.on("change", "input:checkbox", function() {
		if ($specificationTable.find("input:checkbox:checked").size() > 0) {
			hasSpecification = true;
		} else {
			hasSpecification = false;
		}
		changeView();
		buildProductTable();
	});
	
	// 规格
	$specificationTable.on("change", "input:text", function() {
		var $this = $(this);
		var value = $.trim($this.val());
		if (value == "") {
			$this.val($this.data("value"));
			return false;
		}
		if ($this.hasClass("specificationItemEntryValue")) {
			var values = $this.closest("tr").find("input.specificationItemEntryValue").not($this).map(function() {
				return $.trim($(this).val());
			}).get();
			if ($.inArray(value, values) >= 0) {
				$.message("warn", "${message("shop.business.goods.specificationItemEntryValueRepeated")}");
				$this.val($this.data("value"));
				return false;
			}
		}
		$this.data("value", value);
		buildProductTable();
	});


	// 是否默认
	$productTable.on("change", "input.isDefault", function() {
		var $this = $(this);
		if ($this.prop("checked")) {
			$productTable.find("input.isDefault").not($this).prop("checked", false);
		} else {
			$this.prop("checked", true);
		}
	});
	
	// 是否启用
	$productTable.on("change", "input.isEnabled", function() {
		var $this = $(this);
		if ($this.prop("checked")) {
			$this.closest("tr").find("input:not(.isEnabled)").prop("disabled", false);
		} else {
			$this.closest("tr").find("input:not(.isEnabled)").prop("disabled", true).end().find("input.isDefault").prop("checked", false);
		}
		if ($productTable.find("input.isDefault:not(:disabled):checked").size() == 0) {
			$productTable.find("input.isDefault:not(:disabled):first").prop("checked", true);
		}
	});
	
	// 生成商品表
	function buildProductTable() {
		var type = $type.val();
		var productValues = {};
		var specificationItems = [];
		if (!hasSpecification) {
			$productTable.empty()
			return false;
		}
		$specificationTable.find("tr:gt(0)").each(function() {
			var $this = $(this);
			var $checked = $this.find("input:checkbox:checked");
			if ($checked.size() > 0) {
				var specificationItem = {};
				specificationItem.name = $this.find("input.specificationItemName").val();
				specificationItem.entries = $checked.map(function() {
					return {
						id: $(this).siblings("input.specificationItemEntryId").val(),
						value: $(this).siblings("input.specificationItemEntryValue").val()
					};
				}).get();
				specificationItems.push(specificationItem);
			}
		});
		var products = cartesianProductOf($.map(specificationItems, function(specificationItem) {
			return [specificationItem.entries];
		}));
		$productTable.find("tr:gt(0)").each(function() {
			var $this = $(this);
			productValues[$this.data("ids")] = {
				price: $this.find("input.price").val(),
				cost: $this.find("input.cost").val(),
				marketPrice: $this.find("input.marketPrice").val(),
				rewardPoint: $this.find("input.rewardPoint").val(),
				exchangePoint: $this.find("input.exchangePoint").val(),
				stock: $this.find("input.stock").val(),
				isDefault: $this.find("input.isDefault").prop("checked"),
				isEnabled: $this.find("input.isEnabled").prop("checked")
			};
		});
		$titleTr = $('<tr><\/tr>').appendTo($productTable.empty());
		$.each(specificationItems, function(i, specificationItem) {
			$titleTr.append('<th>' + escapeHtml(specificationItem.name) + '<\/th>');
		});
		$titleTr.append(
			[@compress single_line = true]
				(type == "general" ? '<th>${message("Product.price")}<\/th>' : '') + '
				<th>
					${message("Product.cost")}
				<\/th>
				<th>
					${message("Product.marketPrice")}
				<\/th>
				' + (type == "general" ? '<th>${message("Product.rewardPoint")}<\/th>' : '') + 
				(type == "exchange" ? '<th>${message("Product.exchangePoint")}<\/th>' : '') + '
				<th>
					${message("Product.stock")}
				<\/th>
				<th>
					${message("Product.isDefault")}
				<\/th>
				<th>
					${message("shop.business.goods.isEnabled")}
				<\/th>'
			[/@compress]
		);
		$.each(products, function(i, entries) {
			var ids = [];
			$productTr = $('<tr><\/tr>').appendTo($productTable);
			$.each(entries, function(j, entry) {
				$productTr.append(
					[@compress single_line = true]
						'<td>
							' + escapeHtml(entry.value) + '
							<input type="hidden" name="productList[' + i + '].specificationValues[' + j + '].id" value="' + entry.id + '" \/>
							<input type="hidden" name="productList[' + i + '].specificationValues[' + j + '].value" value="' + escapeHtml(entry.value) + '" \/>
						<\/td>'
					[/@compress]
				);
				ids.push(entry.id);
			});
			var productValue = productValues[ids.join(",")];
			var price = productValue != null && productValue.price != null ? productValue.price : "";
			var cost = productValue != null && productValue.cost != null ? productValue.cost : "";
			var marketPrice = productValue != null && productValue.marketPrice != null ? productValue.marketPrice : "";
			var rewardPoint = productValue != null && productValue.rewardPoint != null ? productValue.rewardPoint : "";
			var exchangePoint = productValue != null && productValue.exchangePoint != null ? productValue.exchangePoint : "";
			var stock = productValue != null && productValue.stock != null ? productValue.stock : "";
			var isDefault = productValue != null && productValue.isDefault != null ? productValue.isDefault : false;
			var isEnabled = productValue != null && productValue.isEnabled != null ? productValue.isEnabled : false;
			$productTr.append(
				[@compress single_line = true]
					(type == "general" ? '<td><input type="text" name="productList[' + i + '].price" class="text price" value="' + price + '" maxlength="16" style="width: 50px;" \/><\/td>' : '') + '
					<td>
						<input type="text" name="productList[' + i + '].cost" class="text cost" value="' + cost + '" maxlength="16" style="width: 50px;" \/>
					<\/td>
					<td>
						<input type="text" name="productList[' + i + '].marketPrice" class="text marketPrice" value="' + marketPrice + '" maxlength="16" style="width: 50px;" \/>
					<\/td>
					' + (type == "general" ? '<td><input type="text" name="productList[' + i + '].rewardPoint" class="text rewardPoint" value="' + rewardPoint + '" maxlength="9" style="width: 50px;" \/><\/td>' : '') + 
					(type == "exchange" ? '<td><input type="text" name="productList[' + i + '].exchangePoint" class="text exchangePoint" value="' + exchangePoint + '" maxlength="9" style="width: 50px;" \/><\/td>' : '') + '
					<td>
						<input type="text" name="productList[' + i + '].stock" class="text stock" value="' + stock + '" maxlength="9" style="width: 50px;" \/>
					<\/td>
					<td>
						<input type="checkbox" name="productList[' + i + '].isDefault" class="isDefault" value="true"' + (isDefault ? ' checked="checked"' : '') + ' \/>
						<input type="hidden" name="_productList[' + i + '].isDefault" value="false" \/>
					<\/td>
					<td>
						<input type="checkbox" name="isEnabled" class="isEnabled" value="true"' + (isEnabled ? ' checked="checked"' : '') + ' \/>
					<\/td>'
				[/@compress]
			).data("ids", ids.join(","));
			if (!isEnabled) {
				$productTr.find(":input:not(.isEnabled)").prop("disabled", true);
			}
		});
		if ($productTable.find("input.isDefault:not(:disabled):checked").size() == 0) {
			$productTable.find("input.isDefault:not(:disabled):first").prop("checked", true);
		}
	}
	
	// 笛卡尔积
	function cartesianProductOf(array) {
		function addTo(current, args) {
			var i, copy;
			var rest = args.slice(1);
			var isLast = !rest.length;
			var result = [];
			for (i = 0; i < args[0].length; i++) {
				copy = current.slice();
				copy.push(args[0][i]);
				if (isLast) {
					result.push(copy);
				} else {
					result = result.concat(addTo(copy, rest));
				}
			}
			return result;
		}
		return addTo([], array);
	}
	
	// 加载规格
	function loadSpecification() {
		$.ajax({
			url: "specifications.jhtml",
			type: "GET",
			data: {productCategoryId: $productCategoryId.val()},
			dataType: "json",
			success: function(data) {
				$specificationTable.find("tr:gt(0)").remove();
				$productTable.empty();
				$.each(data, function(i, specification) {
					var $td = $(
						[@compress single_line = true]
							'<tr>
								<th>
									<input type="text" name="specificationItems[' + i + '].name" class="text specificationItemName" value="' + escapeHtml(specification.name) + '" style="width: 50px;" \/>
								<\/th>
								<td><\/td>
							<\/tr>'
						[/@compress]
					).appendTo($specificationTable).find("input").data("value", specification.name).end().find("td");
					$.each(specification.options, function(j, option) {
						$(
							[@compress single_line = true]
								'<span>
									<input type="checkbox" name="specificationItems[' + i + '].entries[' + j + '].isSelected" value="true" \/>
									<input type="hidden" name="_specificationItems[' + i + '].entries[' + j + '].isSelected" value="false" \/>
									<input type="hidden" name="specificationItems[' + i + '].entries[' + j + '].id" class="text specificationItemEntryId" value="' + specificationItemEntryId + '" \/>
									<input type="text" name="specificationItems[' + i + '].entries[' + j + '].value" class="text specificationItemEntryValue" value="' + escapeHtml(option) + '" style="width: 50px;" \/>
								<\/span>'
							[/@compress]
						).appendTo($td).find("input.specificationItemEntryValue").data("value", option);
						specificationItemEntryId ++;
					});
				});
			}
		});
	}

	$.validator.addClassRules({
		productImageFile: {
			required: true,
			extension: "${setting.uploadImageExtension}"
		},
		productImageOrder: {
			digits: true
		},
		parameterGroup: {
			required: true
		},
		price: {
			required: true,
			min: 0,
			decimal: {
				integer: 12,
				fraction: ${setting.priceScale}
			}
		},
		cost: {
			min: 0,
			decimal: {
				integer: 12,
				fraction: ${setting.priceScale}
			}
		},
		marketPrice: {
			min: 0,
			decimal: {
				integer: 12,
				fraction: ${setting.priceScale}
			}
		},
		rewardPoint: {
			digits: true
		},
		exchangePoint: {
			required: true,
			digits: true
		},
		stock: {
			required: true,
			digits: true
		}
	});


	// 表单验证
	$inputForm.validate({
		rules: {
			productCategoryId: "required",
			sn: {
				pattern: /^[0-9a-zA-Z_-]+$/,
				remote: {
					url: "check_sn.jhtml",
					cache: false
				}
			},
			name: "required",
			"product.price": {
				required: true,
				min: 0,
				decimal: {
					integer: 12,
					fraction: ${setting.priceScale}
				}
			},
			"product.cost": {
				min: 0,
				decimal: {
					integer: 12,
					fraction: ${setting.priceScale}
				}
			},
			"product.marketPrice": {
				min: 0,
				decimal: {
					integer: 12,
					fraction: ${setting.priceScale}
				}
			},
			image: {
				pattern: /^(http:\/\/|https:\/\/|\/).*$/i
			},
			weight: "digits",
			"product.rewardPoint": "digits",
			"product.exchangePoint": {
				digits: true,
				required: true
			},
			"product.stock": {
				required: true,
				digits: true
			}
		},
		storeProductCategoryId:{
			required: true
		},
		messages: {
			sn: {
				pattern: "${message("shop.validate.illegal")}",
				remote: "${message("shop.validate.exist")}"
			}
		},
		submitHandler: function(form) {
			if (hasSpecification && $productTable.find("input.isEnabled:checked").size() == 0) {
				$.message("warn", "${message("shop.business.goods.specificationProductRequired")}");
				return false;
			}
			addCookie("previousProductCategoryId", $productCategoryId.val(), {expires: 24 * 60 * 60});
			$(form).find("input:submit").prop("disabled", true);
			form.submit();
		}
	});
	
	$save=$('#save');
    $check=$('#check');
    $marketable=$('#marketable');
    //保存
    $save.click(function(){
        $inputForm.attr('action','save.jhtml?action=save');
        $inputForm.submit();
    });
    
    //审核
    $check.click(function(){
        $inputForm.attr('action','save.jhtml?action=sendCheck');
        $inputForm.submit();
    });
    
    //上架
    $marketable.click(function(){
        $inputForm.attr('action','save.jhtml?action=marketable');
        $inputForm.submit();
    });

});
</script>
</head>
<body>
	[#assign current = "goodsList" /]
	[#include "/shop/${theme}/include/header.ftl" /]
	<div class="container business">
		<div class="row">
			[#include "/shop/${theme}/business/include/menu.ftl" /]
			<div class="span10">
				<div class="item-publish">
					<form id="inputForm" action="save.jhtml" method="post" enctype="multipart/form-data">
						<input type="hidden" id="isDefault" name="product.isDefault" value="true" />
						<div class="ncsc-form-goods">
							<ul id="tab" class="tab">
								<li>
									<input type="button" value="${message("shop.business.goods.base")}" />
								</li>
								<li>
									<input type="button" value="${message("shop.business.goods.introduction")}" />
								</li>
								<li>
									<input type="button" value="${message("shop.business.goods.productImage")}" />
								</li>
								<li>
									<input type="button" value="${message("shop.business.goods.parameter")}" />
								</li>
								<li>
									<input type="button" value="${message("shop.business.goods.attribute")}" />
								</li>
								<li>
									<input type="button" value="${message("shop.business.goods.specification")}" />
								</li>
								<li>
									<input id="purChaseProtocol" type="button" value="购买协议" style="display:none;" />
								</li>
							</ul>
							<table class="input tabContent">	
								<tr>
									<th>
										<span class="requiredField">*</span>${message("Goods.productCategory")}：
									</th>
									<td>
										<select id="productCategoryId" name="productCategoryId" class="sgcategory">
											<option value="">${message("shop.common.choose")}</option>
											[#list productCategoryTree as productCategory]
												<option value="${productCategory.id}">
													[#if productCategory.grade != 0]
														[#list 1..productCategory.grade as i]
															&nbsp;&nbsp;
														[/#list]
													[/#if]
													${productCategory.name}
												</option>
											[/#list]
										</select>
									</td>
								</tr>
								<tr>
								    <th>
										<span class="requiredField">*</span>${message("Goods.type")}:
								    </th>
								    <td>
									    <select id="type" name="type">
											[#list types as type]
												<option value="${type}">${message("Goods.Type." + type)}</option>
											[/#list]
									    </select>
								    </td>
								</tr>
								<tr>
									<th>${message("Goods.sn")}</th>
									<td>
										<input type="text" name="sn"  class="text w400" maxlength="100" title="${message("shop.business.goods.snTitle")}"/>
									</td>
								</tr>
								<tr>
									<th>
										<span class="requiredField">*</span>${message("Goods.name")}：
									</th>
									<td>
										<input type="text" name="name" class="text w400" value="" maxlength="200"/>
									</td>
								</tr>
								<tr>
									<th>${message("Goods.caption")}：</th>
									<td>
									  <input type="text"name="caption" class="text w400" maxlength="200"/>
									</td>
								</tr>
								<tr>
									<th><span class="requiredField">*</span>${message("Product.price")}：</th>
									<td>
									  <input type="text" id="price" name="product.price" value="0.00" class="text w60">
									</td>
								</tr>
								<tr>
									<th>${message("Product.cost")}：</th>
									<td>
									  <input id="cost" name="product.cost" value="0.00" type="text" class="text w60" title="${message("shop.business.goods.costTitle")}">
									</td>
								</tr>
								<tr>
									<th>${message("Product.marketPrice")}：</th>
									<td>
									  <input id="marketPrice" name="product.marketPrice" value="0.00" type="text" class="text w60" title="${message("shop.business.goods.marketPriceTitle")}">
									</td>
								</tr>
								<tr>
									<th>
										${message("Goods.image")}:
									</th>
									<td>
										<span class="fieldSet">
											<input type="text" id="image" name="image" class="text" maxlength="200" title="${message("shop.business.goods.imageTitle")}" />
											<a href="javascript:;" class="button browserButton">${message("shop.upload.filePicker")}</a>
											<span class="preview"></span>
										</span>
									</td>
								</tr>
								<tr>
									<th>${message("Goods.unit")}：</th>
									<td>
									  <input id="unit" name="unit" value="" type="text" class="text w60">
									</td>
								</tr>
								<tr>
									<th>${message("Goods.weight")}：</th>
									<td>
									  <input id="weight" name="weight" value="" type="text" class="text w60" maxlength="9" title="${message("shop.business.goods.weightTitle")}">
									</td>
								</tr>
								<tr>
									<th>
										${message("Product.rewardPoint")}:
									</th>
									<td>
										<input type="text" id="rewardPoint" name="product.rewardPoint" class="text" maxlength="9" title="${message("shop.business.goods.rewardPointTitle")}"/>
									</td>
								</tr>
								<tr class="hidden">
									<th>
										<span class="requiredField">*</span>${message("Product.exchangePoint")}:
									</th>
									<td>
										<input type="text" id="exchangePoint" name="product.exchangePoint" class="text" maxlength="9" disabled="disabled" />
									</td>
								</tr>
								<tr>
									<th>
										<span class="requiredField">*</span>${message("Product.stock")}：
									</th>
									<td>
									  	<input id="stock" name="product.stock" value="1" type="text"  maxlength="9" class="text w60">
									</td>
								</tr>
								<tr>
									<th>
										${message("Goods.brand")}:
									</th>
									<td>
										<select name="brandId">
											<option value="">${message("shop.common.choose")}</option>
											[#list brands as brand]
												<option value="${brand.id}">
													${brand.name}
												</option>
											[/#list]
										</select>
									</td>
								</tr>
								[#if promotions?has_content]
									<tr>
										<th>
											${message("Goods.promotions")}:
										</th>
										<td>
											[#list promotions as promotion]
												<label title="${promotion.name}">
													<input type="checkbox" name="promotionIds" value="${promotion.id}" />${promotion.name}
												</label>
											[/#list]
										</td>
									</tr>
								[/#if]
								[#if storeTags?has_content]
									<tr>
										<th>
											${message("Goods.storeTags")}:
										</th>
										<td>
											[#list storeTags as storeTag]
												<label title="${storeTag.name}">
													<input type="checkbox" name="storeTagIds" value="${storeTag.id}" />${storeTag.name}
												</label>
											[/#list]
										</td>
									</tr>
								[/#if]
								[#if tags?has_content]
									<tr>
										<th>
											${message("Goods.tags")}:
										</th>
										<td>
											[#list tags as tag]
												<label>
													<input type="checkbox" name="tagIds" value="${tag.id}" />${tag.name}
												</label>
											[/#list]
										</td>
									</tr>
								[/#if]
								<tr>
									<th>
										${message("Goods.storeProductCategory")}：
									</th>
									<td>
										<select id="storeProductCategoryId" name="storeProductCategoryId" class="sgcategory">
											<option value="">${message("shop.common.choose")}</option>
											[#list storeProductCategoryTree as storeProductCategory]
												<option value="${storeProductCategory.id}">
													[#if storeProductCategory.grade != 0]
														[#list 1..storeProductCategory.grade as i]
															&nbsp;&nbsp;
														[/#list]
													[/#if]
													${storeProductCategory.name}
												</option>
											[/#list]
										</select>
									</td>
								</tr>
								<tr>
									<th>
										${message("shop.common.setting")}:
									</th>
									<td>
										<label>
											<input type="checkbox" name="isList" value="true" checked="checked" />${message("Goods.isList")}
											<input type="hidden" name="_isList" value="false" />
										</label>
										<label>
											<input type="checkbox" name="isTop" value="true" />${message("Goods.isTop")}
											<input type="hidden" name="_isTop" value="false" />
										</label>
										<label>
											<input type="checkbox" name="isDelivery" value="true" checked="checked" />${message("Goods.isDelivery")}
											<input type="hidden" name="_isDelivery" value="false" />
										</label>
                                        <label>
                                            <input type="checkbox" name="isEnableCommonAgreement" value="true" checked="checked" />${message("Goods.isEnableCommonAgreement")}
                                            <input type="hidden" name="_isEnableCommonAgreement" value="false" />
                                        </label>
									</td>
								</tr>
								<tr>
									<th>
										${message("Goods.memo")}:
									</th>
									<td>
										<input type="text" name="memo" class="text" maxlength="200" />
									</td>
								</tr>
								<tr>
									<th>
										${message("Goods.keyword")}:
									</th>
									<td>
										<input type="text" name="keyword" class="text" maxlength="200" title="${message("shop.business.goods.keywordTitle")}"/>
									</td>
								</tr>
								<tr>
									<th>
										${message("Goods.seoTitle")}:
									</th>
									<td>
										<input type="text" name="seoTitle" class="text" maxlength="200" />
									</td>
								</tr>
								<tr>
									<th>
										${message("Goods.seoKeywords")}:
									</th>
									<td>
										<input type="text" name="seoKeywords" class="text" maxlength="200" />
									</td>
								</tr>
								<tr>
									<th>
										${message("Goods.seoDescription")}:
									</th>
									<td>
										<input type="text" name="seoDescription" class="text" maxlength="200" />
									</td>
								</tr>
						    </table>
						    <table class="input tabContent">
								<tr>
									<td>
										<textarea id="introduction" name="introduction" class="editor" style="width: 100%;"></textarea>
									</td>
								</tr>
						    </table>
						    <table id="productImageTable" class="item tabContent">
								<tr>
									<td colspan="4">
										<a href="javascript:;" id="addProductImage" class="button">${message("shop.business.goods.addProductImage")}</a>
									</td>
								</tr>
								<tr>
									<th>
										${message("ProductImage.file")}
									</th>
									<th>
										${message("ProductImage.title")}
									</th>
									<th>
										${message("shop.common.order")}
									</th>
									<th>
										${message("shop.common.action")}
									</th>
								</tr>
							</table>
							<table id="parameterTable" class="parameterTable input tabContent">
								<tr>
									<th>
										&nbsp;
									</th>
									<td>
										<a href="javascript:;" id="addParameter" class="button">${message("shop.business.goods.addParameter")}</a>
										<a href="javascript:;" id="resetParameter" class="button">${message("shop.business.goods.resetParameter")}</a>
									</td>
								</tr>
							</table>
							<table id="attributeTable" class="input tabContent"></table>
							<div class="tabContent">
								<table id="specificationTable" class="specificationTable input">
									<tr>
										<th>
											&nbsp;
										</th>
										<td>
											<a href="javascript:;" id="resetSpecification" class="button">${message("shop.business.goods.resetSpecification")}</a>
										</td>
									</tr>
								</table>
								<table id="productTable" class="productTable item"></table>
							</div>
							<table class="input tabContent" >
								<tr>
									<td>
										协议名称：<input type="text"  name="agreementTitile" class="text" maxlength="200" />
									</td>
								</tr>
								<tr>
									
									<td>
										协议内容：<textarea id="pcProtocol" name="agreement" class="editor" style="width: 100%;"></textarea>
									</td>
								</tr>
						    </table>
					    </div>
					    <table class="input">
							<tr>
								<th>
									&nbsp;
								</th>
								<td>
                                    <input type="button" class="button" value="保存" id="save"/>
                                    [#if !store.isSelf()]
                                        <input type="button" class="button" value="提交审核" id="check"/>
                                    [#else]
                                        <input type="button" class="button" value="上架" id="marketable"/>
                                    [/#if]
									<input type="button" class="button" value="${message("shop.common.back")}" onclick="history.back(); return false;" />
								</td>
							</tr>
						</table>
					</form>
				</div>
			</div>
		</div>
	</div>
	[#include "/shop/${theme}/include/footer.ftl" /]
</body>
</html>
[/#escape]