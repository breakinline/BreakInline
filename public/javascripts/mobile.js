jQuery(document).ready(function() {
	jQuery('.category').live('click', function() {
		jQuery('#bodyContainer').load('/mobile/category/' + jQuery(this).find('.categoryId').val());
	});
	
	jQuery('.categoryNavBack').live('click', function() {
		window.location = '/mobile/locations/' + jQuery('#navCategoryId').val();
	});
	
	jQuery('.menuItem').live('click', function() {
		jQuery('#bodyContainer').load('/mobile/menuItem/' + jQuery(this).find('.menuItemId').val());
	});
	
	jQuery('.menuItemNavBack').live('click', function() {
		jQuery('#bodyContainer').load('/mobile/category/' + jQuery('#navMenuItemId').val());
	});
	
	jQuery('#cart').live('click', function() {
		jQuery('#bodyContainer').load('/mobile/cart');
	});
	
	jQuery('#checkout').live('click', function() {
	
	});
	
	function refreshOrder() {
		jQuery('#mobileHeader').load('/mobile/refreshorder');
	}
	
  	jQuery('.cartDelete').live('click', function() {
		var orderItemId = jQuery(this).parent().parent().find('.orderItemId').val();
		jQuery.post('/mobile/deleteitem?orderItemId=' + orderItemId, function(data) {
	  		// refresh order
	  		refreshOrder();
	  		jQuery('#bodyContainer').load('/mobile/cart');
		});	
		return false;
  	});	
  	
   	jQuery('#add2cart').live('click', function() {
		var url = '/mobile/additem2order?menuItemId=' + jQuery('#menuItemId').val();
		var pos = 1;
		jQuery('.choice').each(function(i) {
			url += '&choice' + pos + '=' + jQuery(this).val();
			pos++;
		});
		pos = 1;
		jQuery('.option:checked').each(function(i) {
			url += '&option' + pos + '=' + jQuery(this).val();
			pos++;			
		});	
		var comment = jQuery(this).parent().parent().find('.comment').val();
		if (comment == 'Type your comment here.') {
			comment = '';
		}
		url += '&comment=' + escape(comment);
	
		jQuery.post(url, function(data) {
	  		// refresh order
	  		refreshOrder();
	  		jQuery('#bodyContainer').load('/mobile/cart');
		}); 
  	}); 
  	
  	jQuery('.comment').live('focus', function() {
		if (jQuery(this).val() == 'Type your comment here.') {
	  		jQuery(this).val('');
		}
  	});  		
});
