[#escape x as x?html]
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>${message("shop.business.stock.stockOut")}[#if showPowered][/#if]</title>
<meta name="author" content="SHOP++ Team" />
<meta name="copyright" content="SHOP++" />
<link href="${base}/resources/shop/${theme}/css/common.css" rel="stylesheet" type="text/css" />
<link href="${base}/resources/shop/${theme}/css/business.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="${base}/resources/shop/${theme}/js/jquery.js"></script>
<script type="text/javascript" src="${base}/resources/shop/${theme}/js/jquery.tools.js"></script>
<script type="text/javascript" src="${base}/resources/shop/${theme}/js/jquery.validate.js"></script>
<script type="text/javascript" src="${base}/resources/shop/${theme}/js/jquery.autocomplete.js"></script>
<script type="text/javascript" src="${base}/resources/shop/${theme}/js/common.js"></script>
<script type="text/javascript" src="${base}/resources/shop/${theme}/js/input.js"></script>
<script type="text/javascript">
$().ready(function() {

	var $inputForm = $("#inputForm");
	var $productSn = $("#productSn");
	var $productSelect = $("#productSelect");
	var $sn = $("#sn");
	var $name = $("#name");
	var $stock = $("#stock");
	var $allocatedStock = $("#allocatedStock");
	var $quantity = $("#quantity");
	var stock = ${(product.stock)!"null"};
	
	[@flash_message /]
	
	// 商品选择
	$productSelect.autocomplete("product_select.jhtml", {
		dataType: "json",
		max: 20,
		width: 218,
		scrollHeight: 300,
		parse: function(data) {
			return $.map(data, function(item) {
				return {
					data: item,
					value: item.name
				}
			});
		},
		formatItem: function(item) {
			return '<span title="' + escapeHtml(item.name) + '">' + escapeHtml(abbreviate(item.name, 50, "...")) + '<\/span>' + (item.specifications.length > 0 ? ' <span class="silver">[' + escapeHtml(item.specifications.join(", ")) + ']<\/span>' : '');
		}
	}).result(function(event, item) {
		stock = item.stock;
		$productSn.val(item.sn);
		$sn.text(item.sn).closest("tr").show();
		$name.html(escapeHtml(item.name) + (item.specifications.length > 0 ? ' <span class="silver">[' + escapeHtml(item.specifications.join(", ")) + ']<\/span>' : '')).closest("tr").show();
		$stock.text(item.stock).closest("tr").show();
		$allocatedStock.text(item.allocatedStock).closest("tr").show();
	});
	
	// 表单验证
	$inputForm.validate({
		rules: {
			quantity: {
				required: true,
				integer: true,
				min: 1
			}
		},
		submitHandler: function(form) {
			if ($productSn.val() == "") {
				$.message("warn", "${message("shop.business.stock.productRequired")}");
				return false;
			}
			var quantity = parseInt($quantity.val());
			if (stock != null && stock - quantity < 0) {
				$.message("warn", "${message("shop.business.stock.insufficientStock")}");
				return false;
			}
			$(form).find("input:submit").prop("disabled", true);
			form.submit();
		}
	});

});
</script>
</head>
<body>
	[#assign current = "stockList" /]
	[#include "/shop/${theme}/include/header.ftl" /]
	<div class="container business">
		<div class="row">
			[#include "/shop/${theme}/business/include/menu.ftl" /]
			<div class="span10">
				<div class="item-publish">
					<form id="inputForm" action="stock_out.jhtml" method="post">
						<input type="hidden" id="productSn" name="productSn" value="${(product.sn)!}" />
						<table class="input">
							<tr>
								<th>
									${message("shop.business.stock.productSelect")}:
								</th>
								<td>
									<input type="text" id="productSelect" name="productSelect" class="text" maxlength="200" title="${message("shop.business.stock.productSelectTitle")}" />
								</td>
							</tr>
							<tr[#if !product??] class="hidden"[/#if]>
								<th>
									${message("Product.sn")}:
								</th>
								<td id="sn">
									${(product.sn)!}
								</td>
							</tr>
							<tr[#if !product??] class="hidden"[/#if]>
								<th>
									${message("Product.name")}:
								</th>
								<td id="name">
									${(product.name)!}
									[#if product?? && product.specifications?has_content]
										<span class="silver">[${product.specifications?join(", ")}]</span>
									[/#if]
								</td>
							</tr>
							<tr[#if !product??] class="hidden"[/#if]>
								<th>
									${message("Product.stock")}:
								</th>
								<td id="stock">
									${(product.stock)!}
								</td>
							</tr>
							<tr[#if !product??] class="hidden"[/#if]>
								<th>
									${message("Product.allocatedStock")}:
								</th>
								<td id="allocatedStock">
									${(product.allocatedStock)!}
								</td>
							</tr>
							<tr>
								<th>
									<span class="requiredField">*</span>${message("shop.business.stock.quantity")}:
								</th>
								<td>
									<input type="text" id="quantity" name="quantity" class="text" maxlength="9" />
								</td>
							</tr>
							<tr>
								<th>
									${message("shop.business.stock.memo")}:
								</th>
								<td>
									<input type="text" name="memo" class="text" maxlength="200" />
								</td>
							</tr>
							<tr>
								<th>
									&nbsp;
								</th>
								<td>
									<input type="submit" class="button" value="${message("shop.common.submit")}" />
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