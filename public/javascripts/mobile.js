jQuery(document).ready(function() {
	jQuery('.category').live('click', function() {
		jQuery('#menuContainer').load('/mobile/category/' + jQuery(this).find('.categoryId').val());
	});
	
	jQuery('.categoryNavBack').live('click', function() {
		window.location = '/mobile/locations/' + jQuery('#navCategoryId').val();
	});
	
	jQuery('.menuItem').live('click', function() {
		jQuery('#menuContainer').load('/mobile/menuItem/' + jQuery(this).find('.menuItemId').val());
	});
	
	jQuery('.menuItemNavBack').live('click', function() {
		jQuery('#menuContainer').load('/mobile/category/' + jQuery('#navMenuItemId').val());
	});
	
	

});
