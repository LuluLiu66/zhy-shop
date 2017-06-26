[#escape x as x?html]
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=utf-8" />
<meta http-equiv="X-UA-Compatible" content="IE=edge" />
<title>${message("shop.business.storeTag.edit")}[#if showPowered][/#if]</title>
<meta name="author" content="SHOP++ Team" />
<meta name="copyright" content="SHOP++" />
<link href="${base}/resources/shop/${theme}/css/common.css" rel="stylesheet" type="text/css" />
<link href="${base}/resources/shop/${theme}/css/business.css" rel="stylesheet" type="text/css" />
<script type="text/javascript" src="${base}/resources/shop/${theme}/js/jquery.js"></script>
<script type="text/javascript" src="${base}/resources/shop/${theme}/js/jquery.tools.js"></script>
<script type="text/javascript" src="${base}/resources/shop/${theme}/js/jquery.validate.js"></script>
<script type="text/javascript" src="${base}/resources/shop/${theme}/js/webuploader.js"></script>
<script type="text/javascript" src="${base}/resources/shop/${theme}/js/common.js"></script>
<script type="text/javascript" src="${base}/resources/shop/${theme}/datePicker/WdatePicker.js"></script>
<script type="text/javascript" src="${base}/resources/shop/${theme}/js/input.js"></script>
<script type="text/javascript">
$().ready(function() {

	var $inputForm = $("#inputForm");
	var $browserButton = $("a.browserButton");
	
	[@flash_message /]
	
	// 文件上传
	$browserButton.uploader();
	
	// 表单验证
	$inputForm.validate({
		rules: {
			name: "required",
			icon: {
				pattern: /^(http:\/\/|https:\/\/|\/).*$/i
			},
			order: "digits"
		}
	});

});
</script>
</head>
<body>
	[#assign current = "storeTagList" /]
	[#include "/shop/${theme}/include/header.ftl" /]
	<div class="container business">
		<div class="row">
			[#include "/shop/${theme}/business/include/menu.ftl" /]
			<div class="span10">
				<div class="item-publish">
					<div class="main clearfix">
						<div class="breadcrumb">
							${message("shop.business.storeTag.edit")}
						</div>
						<form id="inputForm" action="update.jhtml" method="post">
							<input type="hidden" name="id" value="${storeTag.id}" />
							<table class="input">
								<tr>
									<th>
										<span class="requiredField">*</span>${message("StoreTag.name")}:
									</th>
									<td>
										<input type="text" name="name" class="text" value="${storeTag.name}" maxlength="200" />
									</td>
								</tr>
								<tr>
									<th>
										${message("StoreTag.icon")}:
									</th>
									<td>
										<span class="fieldSet">
										<input type="text" id="icon" name="icon" class="text" value="${storeTag.icon}" maxlength="200" />
										<a href="javascript:;"  class="button browserButton">${message("shop.common.upload")}</a>
										[#if storeTag.icon??]
											<span class="preview"><a href="${storeTag.icon}" target="_blank"><img src="${storeTag.icon}" width="56" height="56"/></a></span>
										[#else]
											<span class="preview"></span>
										[/#if]
										</span>
									</td>
								</tr>
								<tr>
									<th>
										<span class="requiredField">*</span>${message("StoreTag.isShow")}:
									</th>
									<td>
										<label>
											<input type="checkbox" name="isShow" value="true"[#if storeTag.isShow] checked="checked"[/#if] />${message("StoreTag.isShow")}
											<input type="hidden" name="_isShow" value="false" />
										</label>
									</td>
								</tr>
								<tr>
									<th>
										${message("StoreTag.memo")}:
									</th>
									<td>
										<input type="text" name="memo" class="text" value="${storeTag.memo}" maxlength="200" />
									</td>
								</tr>
								<tr>
									<th>
										${message("StoreTag.order")}:
									</th>
									<td>
										<input type="text" name="order" class="text" value="${storeTag.order}" maxlength="200" />
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
	</div>
	[#include "/shop/${theme}/include/footer.ftl" /]
</body>
</html>
[/#escape]