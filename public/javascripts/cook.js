var loginDialog;

jQuery('#loginButton').live('click', function() {
  var url = '/cookview/login?email=' + jQuery('#email').val() + '&password=' + jQuery('#password').val();
  if (jQuery('#location').val() != null) {
	url = url + '&locationId=' + jQuery('#location').val();
  }
  jQuery.post(url, function(data) {
	var result = jQuery.parseJSON(data)
	if (result.iserror == true) {
		alert(result.message);
	} else if (result.showlocations == true) {
	  // add our locations to our dropdown
	  for (var i=0;i<result.locations.length;i++) {
		jQuery('#location').append('<option value="' + result.locations[i].id + '">' + result.locations[i].name + '</option>');
	  }
	  jQuery('#locationContainer').slideDown();
	} else {
	  loginDialog.dialog('close');
	  jQuery('#cook_header').load('/cookview/refreshmyaccount')
	  jQuery('#orderContainer').load('/cookview/refresh?status=Prepare');
	  jQuery('#prepareStatus').addClass('selected');
	}		
  });	
});

jQuery('#status').live('change', function() {
	console.debug('Status: ' + jQuery(this).val());
  	jQuery('#orderContainer').load('/cookview/refresh?status=' + jQuery(this).val());	
});

jQuery('#prepareStatus').live('click', function() {
	jQuery('#completeStatus').removeClass('selected');
	jQuery(this).addClass('selected');
	jQuery('#orderContainer').load('/cookview/refresh?status=Prepare');
});

jQuery('#completeStatus').live('click', function() {
	jQuery('#prepareStatus').removeClass('selected');
	jQuery(this).addClass('selected');
	jQuery('#orderContainer').load('/cookview/refresh?status=Complete');
});


jQuery('#detailBtn').live('click', function() {
	jQuery(this).addClass('selected');
	window.setTimeout(function() {
		jQuery('#detailBtn').removeClass('selected');	
	}, 500);
});


