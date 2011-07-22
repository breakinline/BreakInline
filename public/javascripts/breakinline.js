var inCheckout = false;
var loginDialog;
var selectedMenuItem;
var menuItemDialog;
var selectedOrderItemId;
var itemFor;

function refreshOrder() {
  jQuery('#os_container').load('/main/refreshorder');
}

function refreshAccount() {
  jQuery('#headerContainer').load('/main/refreshmyaccount');
  jQuery('#po_container').load('/main/refreshprevorders');
}

jQuery(document).ready(function() {

  jQuery.validator.addMethod("phoneUS", function(phone_number, element) {
    phone_number = phone_number.replace(/\s+/g, ""); 
	return this.optional(element) || phone_number.length > 9 &&
				phone_number.match(/^(1-?)?(\([2-9]\d{2}\)|[2-9]\d{2})-?[2-9]\d{2}-?\d{4}$/);
	}, "Please specify a valid phone number"
  );

  jQuery('.menuitemPriceContainer').mouseenter(function() {
  	var pos = jQuery(this).offset();
	var width = jQuery(this).width();
	jQuery('.menuitemPopup', this).css( { "left": (pos.left + width/2) + "px", "top":pos.top + "px" } );
	jQuery('.menuitemPopup', this).show();
	jQuery('.menuitemPopup', this).find('.menuItemFor').val(itemFor);
  });

  jQuery('.menuitemPriceContainer').mouseleave(function() {
	jQuery('.menuitemPopup', this).hide();
  }); 

  jQuery('.menuitemPopupContainerChoiceOptionTitle').live('click', function() {
	jQuery('.menuitemPopupContainerChoiceOptionList').slideUp();
	jQuery(this).parent().find('.menuitemPopupContainerChoiceOptionList').slideDown();	
  });

  jQuery('.choice').live('click', function() {
    var sItem = jQuery(this).siblings('.choiceOptionName').html().trim();
	jQuery(this).parent().parent().parent().find('.menuitemPopupContainerChoiceOptionItems').html(sItem);
  });

  jQuery('.option').live('click', function() {
    var sItem = jQuery(this).siblings('.choiceOptionName').html().trim();
	var displayName = jQuery(this).parent().parent().parent().find('.menuitemPopupContainerChoiceOptionItems').html();
	var maxNum = parseInt(jQuery(this).parent().parent().siblings('.max_quantity').val());
	var currentNum = displayName.split('|').length;
	if (displayName.length == 0) currentNum = 0;
	if (jQuery(this).is(':checked')) {
	  // if we already have this, cancel the click event.
	  if (displayName.indexOf(sItem) > -1) {
	    return false;
	  } else {
		// if we're trying to add an item and we've already got our maximum.  Cancel the click event
		if (currentNum >= maxNum) {
			return false;
		} 
	  }
	}
	var checkArr = jQuery(this).parent().parent().parent().find('.option:checked');
	displayName = '';
	jQuery.each(checkArr, function(idx, val) {
	  var opt = jQuery(val).siblings('.choiceOptionName').html().trim();
	  if (displayName.length > 0) {
	    displayName += '|' + opt;
	  } else {
		displayName = opt;
	  }
	});
	jQuery(this).parent().parent().parent().find('.menuitemPopupContainerChoiceOptionItems').html(displayName);
  });

  jQuery('.addButton').click('click', function() {
	selectedOrderItemId = '';
	jQuery('.menuitemPopup').hide();	
	selectedMenuItem = jQuery(this).parent();
	var menuItemId = jQuery(this).siblings('.menuItemAddId').val();
	var name = jQuery('.menuItemAddId[value="'+menuItemId+'"]').siblings('.menuItemName').val();
	var arr = jQuery(this).siblings('.menuitemPopupContainer').find('.menuitemPopupContainerChoiceOptionItems');
	var t_itemFor = jQuery(this).parent().find('.menuItemFor').val();
	if (t_itemFor.length > 0) {
		itemFor = t_itemFor;
	}
	jQuery.each(arr, function(idx, val) {
	  jQuery(val).html('');	
	});
	menuItemDialog = jQuery(this).siblings('.menuitemPopupContainer').dialog({
		modal:true,
		width: '600px',
		title: name,
		resizable:false,
		autoOpen:false,
		close: function(ev, ui) {
			jQuery(this).find('.comment').val('Type your comment here.');
			jQuery(this).find('.choice').attr('checked', false);
			jQuery(this).find('.option').attr('checked', false);
			jQuery(this).dialog('destroy').remove();
			jQuery(this).appendTo(selectedMenuItem);		
		}
	});
	menuItemDialog.dialog('open');
	return false;
  });

  jQuery('.menuitemPopupContainerClose').live('click', function() {
	jQuery(this).parent().parent().dialog('close');
	selectedOrderItemId = '';
  });

  jQuery('.menuitemPopupContainerAdd').live('click', function() {
	var url = '/order/additem2order?menuItemId=';
	if (selectedOrderItemId != undefined && selectedOrderItemId.length > 0) {
		url = '/order/updateorderitem?orderItemId=' + selectedOrderItemId + '&menuItemId=';
	}
	jQuery(selectedMenuItem).find('.menuItemAddId').each(function(i) {
		url += jQuery(this).val();
	});
	var pos = 1;
	jQuery(this).parent().parent().find('.choice:checked').each(function(i) {
		url += '&choice' + pos + '=' + jQuery(this).val();
		pos++;
	});
	pos = 1;
	jQuery(this).parent().parent().find('.option:checked').each(function(i) {
		url += '&option' + pos + '=' + jQuery(this).val();
		pos++;			
	});	
	var comment = jQuery(this).parent().parent().find('.comment').val();
	if (comment == 'Type your comment here.') {
		comment = '';
	}
	url += '&comment=' + escape(comment);
	if (itemFor != undefined) {
	  url += '&itemFor=' + escape(itemFor);
	}
	
	jQuery.post(url, function(data) {
	  menuItemDialog.dialog('close');
	  // refresh order
	  refreshOrder();
	}); 
  });
	
  jQuery('#poCancel').live('click', function() {
    loginDialog.dialog('close');
  });

  jQuery('#poCopy').live('click', function() {
    jQuery.post('/order/copyorder?orderId=' + jQuery('input[name="selectedOrder"]').val(), function(data) {
      if (data == 'success') {
	    loginDialog.dialog('close');
	    // refresh order
	    refreshOrder();
	  } else {
	    alert(data);
	  }
    });
    return false;	
  });
  	
  jQuery('#forgotPassword').live('click', function() {
    jQuery('#login_password_label').hide();
    jQuery('#login_password').hide();
    jQuery('#forgotPassword').hide();
    jQuery('#reset_answer').addClass('required');
	jQuery('#loginButton').html('Reset');
    jQuery('#resetPasswordContainer').slideDown();
  });		

  jQuery('#loginContainer').validate({
    errorElement: "div",
    errorPlacement: function(error, element) {
      error.insertBefore(element.prev());
      error.css('padding-left', element.prev().outerWidth());
      error.css('width', element.outerWidth());
    }
  });

  jQuery('#registerContainer').validate({
    errorElement: "div",
    errorPlacement: function(error, element) {
	  error.insertBefore(element.prev());
	  error.css('padding-left', element.prev().outerWidth());
	  error.css('width', element.outerWidth());
    }
  });	
	
  jQuery('#loginButton').live('click', function() {
	// check to see if we're doing forgotten password or login
	if (jQuery('#resetPasswordContainer').is(':visible')) {
	  // forgotten password
	  if (jQuery('#login_email').valid() && jQuery('#reset_answer').valid()) {
	    var url = '/main/resetpassword?email=' + jQuery('#login_email').val() + '&answer=' + escape(jQuery('#reset_answer').val());
		jQuery.post(url, function(data) {
		  if (data == 'success') {
		    alert('Your temporary password is being emailed!');
			loginDialog.dialog('close');
		  } else {
		    alert(data);
		  }
		});
	  }
	} else {
	  if (jQuery('#loginContainer').valid()) {
	    // try and login
	    jQuery.post('/main/login?email=' + jQuery('#login_email').val() + '&password=' + jQuery('#login_password').val(), function(data) {
	      if (data == 'success') {
		    loginDialog.dialog('close');
		    // refresh account area
		    refreshAccount();
		    // refresh order
		    refreshOrder();			
	      } else {
		    alert(data);
	      }
	    });
	  }
	}	
	return false;
  });

  jQuery('#registerButton').live('click', function() {
    if (jQuery("#registerContainer").valid()) {	
	  // now check our expiration date
	  var expyear = jQuery('#expyear').val();
	  var expmonth = jQuery('#expmonth').val();
	  var dt = new Date();
	  var year = dt.getYear();
	  if (year < 1900) {
		year += 1900;
	  }
	  if (expmonth <= (dt.getMonth() + 1) && expyear <= year) {
		alert('expiration is not valid.');
		return true;
	  }
	  var url = '/main/register?email=' + jQuery('#email').val() + '&password=' + jQuery('#password').val() +
	  	  '&firstname=' + escape(jQuery('#first_name').val()) + '&lastname=' + escape(jQuery('#last_name').val()) +
		  '&address1=' + escape(jQuery('#address_1').val()) + '&address2=' + escape(jQuery('#address_2').val()) +
		  '&city=' + escape(jQuery('#city').val()) + '&state=' + jQuery('#state').val() +
		  '&postal=' + jQuery('#postal').val() + '&phone=' + jQuery('#phone').val() + '&challenge=' +
		  jQuery('#challenge').val() + '&answer=' + escape(jQuery('#answer').val()) + '&cardtype=' +
		  jQuery('#card_type').val() + '&cardno=' + jQuery('#card_number').val() + '&expyear=' +
		  jQuery('#expyear').val() + '&expmonth=' + jQuery('#expmonth').val() + '&cvv=' + jQuery('#cvv').val() +
		  '&editmode=' + jQuery('#editmode').val() + '&answer=' + escape(jQuery('#answer').val()) +
		  '&challenge=' + escape(jQuery('#challenge').val());
		
	  jQuery.post(url, function(data) {
	    if (data == 'success') {
	      loginDialog.dialog('close');
		  // refresh account area
		  refreshAccount();
		  // refresh order
		  refreshOrder();
	    } else {
		  alert(data);
	    }
	  });
	}
	return false;
  });

  jQuery('#cancelButton').live('click', function() {
    loginDialog.dialog('close');
  });

  jQuery('#loadprevious').live('click', function() {
	jQuery('#po_container').load('/main/refreshprevorders', function() {
	  loginDialog = jQuery('#po_container').dialog({
	  	  modal:true,
		  width: '600px',
		  resizable:false,
	      autoOpen:false,
		  close: function(ev, ui) {	    
			jQuery('#po_container').appendTo('#bodyContainer');	
			jQuery(this).dialog('destroy');	
		  }	
		});
		loginDialog.dialog('open');	
	});
  });

  jQuery('#deletecard').live('click', function() {
	jQuery('#card_number').val('');
	jQuery('#card_type').val('Visa');
	jQuery('#cvv').val('');	
	jQuery('#card_number').removeAttr('disabled');
	jQuery('#card_type').removeAttr('disabled');
	jQuery('#expmonth').removeAttr('disabled');
	jQuery('#expyear').removeAttr('disabled');
	jQuery('#cvv').show();	
	jQuery('#cvv').addClass('required');
	jQuery('#cvv').prev().show();
	jQuery('#creditcard_delete').hide();	
  });

  jQuery('#signIn').live('click', function() {
	jQuery('#editmode').val('false');
	jQuery('#email').val('');
	jQuery('#loginButton').html('Login');
	jQuery('#first_name').val('');
	jQuery('#last_name').val('');
	jQuery('#address_1').val('');
	jQuery('#address_2').val('');
	jQuery('#city').val('');
	jQuery('#state').val('');
	jQuery('#postal').val('');
	jQuery('#phone').val('');
	jQuery('#card_number').val('');
	jQuery('#card_type').val('');
	jQuery('#cvv').val('');	
	jQuery('#login_email').val('');
	jQuery('#password').val('');
	jQuery('#confirm_password').val('');
	jQuery('#login_password').val('');
	jQuery('#answer').val('');
	jQuery('#card_number').removeAttr('disabled');
	jQuery('#card_type').removeAttr('disabled');
	jQuery('#expmonth').removeAttr('disabled');
	jQuery('#cvv').show();	
	jQuery('#cvv').prev().show();
	jQuery('#creditcard_delete').hide();
	jQuery('#reset_answer').removeClass('required');
	jQuery('#expyear').empty();
	jQuery('#creditcard_delete').hide();
	var year = new Date().getYear();
	if (year < 1900) {
	  year += 1900;
	}
	for (var x=year;x<year+10;x++) {
	  jQuery('#expyear').append('<option value="'+x+'">'+x+'</option>');	
	}	
	jQuery('#expyear').removeAttr('disabled');
	loginDialog = jQuery('#loginRegisterContainer').dialog({
	  modal:true,
	  width: '700px',
	  resizable:false,
	  title: 'Sign In / Register',
      autoOpen:false,
	  close: function(ev, ui) {
		jQuery('#registerContainer').data('validator').resetForm();
		jQuery('#loginContainer').data('validator').resetForm();
	    jQuery(this).dialog('destroy');
		jQuery(this).appendTo('#bodyContainer');
		jQuery('#login_password_label').show();
		jQuery('#login_password').show();
		jQuery('#forgotPassword').show();
	    jQuery('#resetPasswordContainer').hide();		
	  }	
	});
	loginDialog.dialog('open');  
	return false;
  });

  jQuery('#logout').live('click', function() {
	jQuery.post('/main/logout', function(data) {
	  if (data == 'success') {
	    // refresh account area
		refreshAccount();
		// refresh order
		refreshOrder();
	  } else {
	    alert(data);
	  }
	});
	return false;	  	
  });

  jQuery('#myaccountedit').live('click', function() {
	// hide our email and change our Title.  disable validation on email
	jQuery('#email').removeClass('required email');
	jQuery('#rc_signup_label').html('Profile:');
	jQuery('#email').attr('disabled', 'disabled');
	jQuery('#registerButton').html('Save');
	jQuery('#editmode').val('true');
	jQuery('#creditcard_delete').show();
	// now request our profile information
	jQuery.post('/main/getprofile', function(data) {
		var profile = jQuery.parseJSON(data).user;
		jQuery('#password').val(profile.password);
		jQuery('#confirm_password').val(profile.password);	
		jQuery('#email').val(profile.email);
		jQuery('#first_name').val(profile.first_name);
		jQuery('#last_name').val(profile.last_name);
		jQuery('#address_1').val(profile.address_1);
		jQuery('#address_2').val(profile.address_2);
		jQuery('#city').val(profile.city);
		jQuery('#state').val(profile.state);
		jQuery('#postal').val(profile.postal);
		jQuery('#phone').val(profile.phone);
		jQuery('#card_number').val(profile.card_number);
		jQuery('#card_type').val(profile.card_type);
		jQuery('#expmonth').val(profile.expiration_month);
		jQuery('#challenge').val(profile.challenge);
		jQuery('#answer').val(profile.answer);
		// disable our credit card info
		jQuery('#card_number').attr('disabled', 'disabled');
		jQuery('#card_type').attr('disabled', 'disabled');
		jQuery('#expmonth').attr('disabled', 'disabled');
		jQuery('#expyear').attr('disabled', 'disabled');
		jQuery('#cvv').hide();
		jQuery('#cvv').removeClass('required');
		jQuery('#cvv').prev().hide();
		jQuery('#expyear').empty();
		var year = new Date().getYear();
		if (year < 1900) {
		  year += 1900;
		}
		for (var x=year;x<year+10;x++) {
		  jQuery('#expyear').append('<option value="'+x+'">'+x+'</option>');	
		}
		jQuery('#expyear').val(profile.expiration_year);	
		loginDialog = jQuery('#registerContainer').dialog({
		  modal:true,
		  width: '420px',
		  resizable:false,
	      autoOpen:false,
		  close: function(ev, ui) {
			jQuery('#registerContainer').data('validator').resetForm();
		    jQuery(this).dialog('destroy');
		    jQuery(this).appendTo('#loginRegisterContainer');
			jQuery('#rc_signup_label').html('Sign Up:');
			jQuery('#editmodel').val('false');
			jQuery('#email').attr('disabled', '');
			jQuery('#email').addClass('required email');
			jQuery('#registerButton').html('Register');		
			jQuery('#registerContainer').show();
			
		  }	
		});
		loginDialog.dialog('open');	 
	});
	return false;
  });

  jQuery('.comment').live('focus', function() {
	if (jQuery(this).val() == 'Type your comment here.') {
	  jQuery(this).val('');
	}
  });
	
  jQuery('.menuItemEdit').live('click', function() {
    var orderItemId = jQuery(this).parent().parent().find('.orderItemId').val();
	var menuItemId = jQuery(this).parent().parent().find('.menuItemId').val();
	var options = jQuery(this).parent().parent().find('.orderItemOptions').val();
	var choices = jQuery(this).parent().parent().find('.orderItemChoices').val();
	var comment = jQuery(this).parent().parent().find('.orderItemComment').val();
		
	selectedOrderItemId = orderItemId;
	selectedMenuItem = jQuery('.menuItemAddId[value="'+menuItemId+'"]').siblings('.menuitemPopupContainer').parent();
	jQuery('.option').attr('checked', false);
	jQuery('.choice:eq(0)').attr('checked', true);
	jQuery(selectedMenuItem).find('.comment').attr('value',comment);
	var opts = options.split('|');
	for (var i=0;i<opts.length;i++) {
	  jQuery(selectedMenuItem).find('.option[value="'+opts[i]+'"]').attr('checked', true);
	}	
	var chs = choices.split('|');
	for (var i=0;i<chs.length;i++) {
	  jQuery(selectedMenuItem).find('.choice[value="'+chs[i]+'"]').attr('checked', true);
	}
	var containerArr = jQuery(selectedMenuItem).find('.menuitemPopupContainerChoiceOptionContainer');
	jQuery.each(containerArr, function(idx, obj) {
	  var checkArr = jQuery(obj).find('.option:checked');	
	  var displayName = '';
	  jQuery.each(checkArr, function(idx, val) {
	    var opt = jQuery(val).siblings('.choiceOptionName').html().trim();
	    if (displayName.length > 0) {
	      displayName += '|' + opt;
	    } else {
		  displayName = opt;
	    }
	  });
	  if (displayName.length == 0) {
		if (jQuery(obj).find('.choice:checked').siblings('.choiceOptionName').html() != undefined) {
		  displayName = jQuery(obj).find('.choice:checked').siblings('.choiceOptionName').html().trim();
		}
	  }
	  jQuery(obj).find('.menuitemPopupContainerChoiceOptionItems').html(displayName);
	});
			
	var name = jQuery('.menuItemAddId[value="'+menuItemId+'"]').siblings('.menuItemName').val();		
	menuItemDialog = jQuery('.menuItemAddId[value="'+menuItemId+'"]').siblings('.menuitemPopupContainer').dialog({
	  modal:true,
	  width: '600px',
	  title: name,
	  resizable:false,
	  autoOpen:false,
	  close: function(ev, ui) {
		jQuery(this).find('.comment').val('Type your comment here.');
	    jQuery(this).dialog('destroy').remove();
		jQuery(this).appendTo(selectedMenuItem);
	  }
	});
	menuItemDialog.dialog('open');
	
  });
	
  jQuery('.menuItemDelete').live('click', function() {
	var orderItemId = jQuery(this).parent().parent().find('.orderItemId').val();
	jQuery.post('/order/deleteitem?orderItemId=' + orderItemId, function(data) {
	  // refresh order
	  refreshOrder();
	});	
	return false;
  });

  jQuery('.quantity').live('change', function() {
	var orderItemId = jQuery(this).parent().parent().find('.orderItemId').val();
	jQuery.post('/order/updatequantity?orderItemId=' + orderItemId + '&quantity=' + jQuery(this).val(), function(data) {
	  // refresh order
	  refreshOrder();
	});	
  });

  jQuery('#checkoutButton').live('click', function() {
	// check out order total
	if (jQuery('.orderItemId').length == 0) {
	  alert('There are no items to checkout with.');
	  return false;
	}
	if (jQuery('#signIn').is(':visible')) {
	  jQuery('#signIn').trigger('click');
	  return false;
	}
	jQuery.blockUI();
	// should be okay, let's try and auth
	var url = '/order/checkout?cvv=' + jQuery('#cvv').val();
	if (jQuery('.pickup').val() == 'later') {
		url += '&pickupDate=' + escape(jQuery('#pickupDatePicker').val());
	}
	jQuery.post(url, function(data) {
	  if (data == 'success') {
		jQuery('.contentContainer').load('/order/thankyou?prevOrderId='+jQuery('#orderId').val());
		jQuery('#po_container').load('/main/refreshprevorders');
	  } else {
		alert(data);
		jQuery.unblockUI();		
	  }
	});
	return false;	
  });
  
  jQuery('.pickup').live('click', function() {
    if (jQuery(this).val() == 'now') {
	  jQuery('#os_pickup_time_container').slideUp();
    } else {
	  jQuery('#os_pickup_time_container').slideDown();
	  jQuery('#pickupDatePicker').datepicker('setDate', calculateStartTime(new Date()));
	  jQuery('#pickupDatePicker').datepicker('show');
	  
    }	
  });
});

function calculateStartTime(dt) {
	var newDt = dt;
	newDt.setTime(dt.getTime() + (deliveryPadding * 60 * 1000));
	var numIncrements = Math.round(((newDt.getTime() / 1000) / 60) / deliveryIncrement);
	if (Math.round((newDt.getTime() / 1000) / 60) % deliveryIncrement > 0) {
		numIncrements += 1;
	}
	newDt.setTime(numIncrements * deliveryIncrement * 60 * 1000);
	return newDt;
}
  

