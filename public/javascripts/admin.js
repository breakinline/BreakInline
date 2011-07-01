Ext.BLANK_IMAGE_URL = '/images/s.gif';
var COMPANY = 1;
var LOCATION = 2;
var CATEGORY = 3;
var MENU_ITEM = 4;
var GROUP = 5;
var CHOICE_OPTION = 6;
var USER = 4;

Ext.onReady(function(){
	Ext.QuickTips.init();
	// If loggedIn is false, try and log in.
	var loginForm = new Ext.form.FormPanel({
		frame:true,
		width:330,
		labelWidth:60,
		defaults: {
			width:165
		},
		items: [
			new Ext.form.TextField({
				id: "email",
				fieldLabel: "Email",
				allowBlank:false,
				minWidth:300,
				name:"email",
				blankText:"Enter your email"
			}),
			new Ext.form.TextField({
				id: "password",
				fieldLabel: "Password",
				allowBlank:false,
				minWidth:300,
				name:"password",
				inputType: 'password',
				blankText:"Enter your password"
			}),
			
		],
		buttons: [{
			text: 'Login',
			handler: function() {
				if (loginForm.getForm().isValid()) {
					loginForm.submit({
						url: '/admin/login',
						waitMsg: 'Processing Login',
						success: function(form, action) {
							showAdmin();
							loginWindow.close();
						},
						failure: function(form, action) {
							Ext.Msg.alert('Login Failed', action.result.failure);
						}
					});
				}
			}
		}]
	});
	var loginWindow = new Ext.Window({
		title: 'Welcome to Breakinline Admin',
		layout: 'fit',
		height:125,
		width:330,
		closable:false,
		resizable:false,
		draggable:false,
		items: [loginForm]
	});
	loginWindow.show();
}); //end onReady

function showAdmin() {
	var path;
	var tree = Ext.create('Ext.tree.Panel', {
		store: store,
		renderTo: 'tree-div',
		id: 'treeNav',
		height: 700,
		width: 300,
		title: 'Editor',
		useArrows: true,
		listeners: {
			itemclick: function(node,e) {
				var btn = Ext.getCmp('saveBtn');
				btn.enable();
				path = e.data.id.split('\/');
				var depth = e.data.depth + 1;
				switch (depth) {
					case COMPANY:
						this.getComponent('toolbar').getComponent('new').disable();
						this.getComponent('toolbar').getComponent('copy').disable();
						this.getComponent('toolbar').getComponent('del').disable();						
						showCompany(formPanel, path[COMPANY]);
						e.expand(false);
						break;
					case LOCATION:
						this.getComponent('toolbar').getComponent('new').enable();
						this.getComponent('toolbar').getComponent('copy').disable();					
						this.getComponent('toolbar').getComponent('del').disable();
						showLocation(formPanel, path[LOCATION], path[COMPANY]);
						e.expand(false);											
						break;
					case CATEGORY:
						if (path[USER-1] == 'users') {
					 		this.getComponent('toolbar').getComponent('new').enable();
							this.getComponent('toolbar').getComponent('copy').disable();					
							this.getComponent('toolbar').getComponent('del').disable();	
							formPanel.removeAll(true);	
							formPanel.setTitle('');			
						} else {
					 		this.getComponent('toolbar').getComponent('new').enable();
							this.getComponent('toolbar').getComponent('copy').disable();
							this.getComponent('toolbar').getComponent('del').enable();
							showCategory(formPanel, path[CATEGORY], path[LOCATION]);
						}
						e.expand(false);
						break;
					case MENU_ITEM:
						this.getComponent('toolbar').getComponent('new').enable();
						this.getComponent('toolbar').getComponent('copy').enable();
						this.getComponent('toolbar').getComponent('del').enable();					
						if (path[CATEGORY] == 'users') {
							showUser(formPanel, path[USER], path[LOCATION]);
						} else {
							showMenuItem(formPanel, path[MENU_ITEM], path[CATEGORY]);						
						}
						e.expand(false);
						break;					
					case GROUP:
						this.getComponent('toolbar').getComponent('new').enable();
						this.getComponent('toolbar').getComponent('copy').enable();
						this.getComponent('toolbar').getComponent('del').enable();					
						showGroup(formPanel, path[GROUP], path[MENU_ITEM]);
						e.expand(false);					
						break;
					case CHOICE_OPTION:
						this.getComponent('toolbar').getComponent('new').disable();
						this.getComponent('toolbar').getComponent('copy').enable();
						this.getComponent('toolbar').getComponent('del').enable();					
						showChoiceOption(formPanel, path[CHOICE_OPTION], path[GROUP]);
						break;
				}
			}
		},
		dockedItems: [{
			itemId: 'toolbar',
			xtype: 'toolbar',
			dock: 'top', 
			items: [{
				itemId: 'new',
				text: 'New',
				icon:'/images/Add.gif',
				disabled:true,
				handler: function() {
					var node = Ext.getCmp('treeNav').getSelectionModel().selected.get(0);
					var path = node.data.id.split('\/');
					// get the current selected row. 
					var depth =  node.data.depth + 1;
					switch(depth) {							
						case LOCATION:
							showCategory(formPanel, -1, path[LOCATION]);
							break;
						case CATEGORY:
							if (path[MENU_ITEM] == 'users') {
								showUser(formPanel, -1, path[LOCATION])
							} else {
								showMenuItem(formPanel, -1, path[CATEGORY]);
							}							
							break;
						case MENU_ITEM:
							showGroup(formPanel, -1, path[MENU_ITEM]);
							break;
						case GROUP:
							showChoiceOption(formPanel, -1, path[GROUP]);
							break;
					}
				}
			}, '-', {
				itemId: 'copy',
				text: 'Copy',
				icon:'/images/Copy.gif',
				disabled:true,
				handler: function() {
					var node = Ext.getCmp('treeNav').getSelectionModel().selected.get(0);
					// get the current selected row.  
					var depth = node.data.depth + 1;
					switch(depth) {							
						case MENU_ITEM:
							copyItem(MENU_ITEM, node);				
							break;
						case GROUP:
							copyItem(GROUP, node);
							break;
						case CHOICE_OPTION:
							copyItem(CHOICE_OPTION, node);
							break;
					}
				}
			}, '-', {
				itemId: 'del',
				text: 'Delete',
				icon: '/images/Delete.gif',		
				disabled:true,
				handler: function() {
					var node = Ext.getCmp('treeNav').getSelectionModel().selected.get(0);
					var path = node.data.id.split('\/');
					// get the current selected row and delete
					var depth = node.data.depth+1;
					switch(depth) {
						case CATEGORY:
							deleteItem(CATEGORY, node);								
							break;
						case MENU_ITEM:
							if (path[USER-1] == 'users') {
								deleteItem(USER, node, path[LOCATION]);
							} else {
								deleteItem(MENU_ITEM, node);
							}
							break;
						case GROUP:
							deleteItem(GROUP, node);
							break;
						case CHOICE_OPTION:
							deleteItem(CHOICE_OPTION, node);
							break;
					}
					formPanel.removeAll(true);	
					formPanel.setTitle('');					
				}
			}]
		}]
	});
	var formPanel = Ext.create('Ext.form.Panel', {
		frame:true,
		itemId: 'formPanel',
		title:'Detail',
		width:520,
		height:700,
		bodyPadding: 5,
			
		fieldDefaults: {
			labelAlign: 'left',
			labelWidth: 120,
			anchor: '100%'
		},
			
		items: [{
			
		}],
		buttons:[
			{text:'Save', 
			disabled:true, 
			id: 'saveBtn',
			formBind: true,
			handler: function() {
				var thisForm = this.up('form').getForm();
				if (thisForm.isValid()) {
					thisForm.submit({
						success: function(form, action) {
							var jsonObj = Ext.decode(action.response.responseText);
							var node = Ext.getCmp('treeNav').getSelectionModel().selected.get(0);
							var path = node.data.id.split('\/');
							if (thisForm.method == 'PUT') {
								node.set('text', jsonObj.name);
							} else {
								if (path.length == 6) {
									node.appendChild({id: jsonObj.id, text: jsonObj.name, iconCls: jsonObj.iconCls, leaf:true});
								} else {
									node.appendChild({id: jsonObj.id, text: jsonObj.name, iconCls: jsonObj.iconCls, leaf:false});
								}
							}						
						},
						failure: function(form, action) {
							Ext.Msg.alert('Failed', action.result.failure);
						}
					});
				}
			}
		}]
	});
	formPanel.render('form-div');	
}

function copyItem(type, node) {
	var path = node.data.id.split('\/');
	var message = 'Are you sure you would like to copy ';
	var url = '/admin/';
	switch (type) {
		case MENU_ITEM:
			url += 'menuItem/' + path[MENU_ITEM] + '?copy=true&parent=' + path[CATEGORY];
			message += node.data.text;
			break;
		case GROUP:
			url += 'choiceOptionGroup/' + path[GROUP] + '?copy=true&parent=' + path[MENU_ITEM];
			message += node.data.text;
			break;
		case CHOICE_OPTION:
			url += 'choiceOption/' + path[CHOICE_OPTION] + '?copy=true&parent=' + path[GROUP];
			message += node.data.text;
			break;
	}
	message += '?';
	Ext.Msg.confirm('Copy?', message, function(btn) {
		if (btn == "yes") {
			Ext.Ajax.request({
				url: url,
				method: 'PUT',
				success: function(response) {
					var jsonObj = Ext.decode(response.responseText);
					var treeNode = Ext.getCmp('treeNav').getSelectionModel().selected.get(0).parentNode;
					var path = treeNode.data.id.split('\/');
					if (path.length == 6) {
						treeNode.appendChild({id: jsonObj.id, text: jsonObj.name, iconCls: jsonObj.iconCls, leaf:true});
					} else {
						treeNode.appendChild({id: jsonObj.id, text: jsonObj.name, iconCls: jsonObj.iconCls, leaf:false});
					}
					switch (type) {
						case MENU_ITEM:
							showMenuItem(formPanel, jsonObj.id, path[CATEGORY]);
							break;
						case GROUP:
							showGroup(formPanel, jsonObj.id, path[MENU_ITEM]);
							break;
						case CHOICE_OPTION:
							showChoiceOption(formPanel, jsonObj.id, path[CHOICE_OPTION]);
							break;
					}
				}
			});		
		}
	});	
}

function deleteItem(type, node, locationId) {
	var message = 'Are you sure you would like to delete ';
	var path = node.data.id.split('\/');
	var url = '/admin/';
	switch (type) {
		case CATEGORY:
			url = url + 'category/' + path[CATEGORY];
			message += 'category: ' + node.data.text;
			break;
		case MENU_ITEM:
			message += 'menu item: ' + node.data.text;
			url = url + 'menuItem/' + path[MENU_ITEM];
			break;
		case GROUP:
			message += 'group: ' + node.data.text;
			url = url + 'choiceOptionGroup/' + path[GROUP];
			break;
		case CHOICE_OPTION:
			message += 'choice / option: ' + node.data.text;
			url = url + 'choiceOption/' + path[CHOICE_OPTION];
			break;
		case USER:
			message += 'user: ' + node.data.text;
			url = url + 'user/' + path[USER] + '?locationId=' + locationId;
	}
	message += '?';
	Ext.Msg.confirm('Delete?', message, function(btn) {
		if (btn == "yes") {
			Ext.Ajax.request({
				url: url,
				method: 'DELETE',
				success: function() {
					Ext.getCmp('treeNav').getSelectionModel().selected.get(0).remove(true);
				}
			});			
		}
	});
}

function showUser(form, id, parentId) {
	form.setTitle('User Detail');
	if (id == -1) {
		form.form.url = '/admin/user';
		form.form.method='POST';
	} else {
		form.form.url = '/admin/user/'+id;			
		form.form.method='PUT';
	}
	form.removeAll(true);
	var parent = new Ext.form.Hidden({
		xtype: 'hiddenfield',
		name: 'parent',
		value: parentId
	});
	form.add(parent);
	var firstName = new Ext.form.TextField({
        xtype: 'textfield',
        name: 'firstName',
		allowBlank: false,
        fieldLabel: 'First Name'
	});
	form.add(firstName);				
	var lastName = new Ext.form.TextField({
        xtype: 'textfield',
        name: 'lastName',
		allowBlank: false,
        fieldLabel: 'Last Name'
	});
	form.add(lastName);
	var email = new Ext.form.TextField({
        xtype: 'textfield',
        name: 'email',
		allowBlank: false,
        fieldLabel: 'Email'
	});
	form.add(email);		
	var address1 = new Ext.form.TextField({
        xtype: 'textfield',
        name: 'address1',
		allowBlank: false,
        fieldLabel: 'Address'
	});
	form.add(address1);			
	var address2 = new Ext.form.TextField({
        xtype: 'textfield',
        name: 'address2',
        fieldLabel: 'Address 2'
	});
	form.add(address2);			
	var city = new Ext.form.TextField({
        xtype: 'textfield',
        name: 'city',
		allowBlank: false,
        fieldLabel: 'City'
	});
	form.add(city);			
	var state = new Ext.form.ComboBox({
        name: 'state',
        fieldLabel: 'State',
		store: [
			['AL', 'Alabama'],
			['AK', 'Alaska'],
			['AZ', 'Arizona'],
			['AR', 'Arkansas'],
			['CA', 'California'],
			['CO', 'Colorado'],
			['CT', 'Connecticut'],
			['DE', 'Delaware'],
			['DC', 'District of Columbia'],
			['FL', 'Florida'],
			['GA', 'Georgia'],
			['HI', 'Hawaii'],
			['ID', 'Idaho'],
			['IL', 'Illinois']
		]
	});
	form.add(state);
	var postal = new Ext.form.TextField({
        xtype: 'textfield',
        name: 'postal',
		allowBlank: false,
        fieldLabel: 'Postal'
	});
	form.add(postal);
	var phone = new Ext.form.TextField({
        xtype: 'textfield',
        name: 'phone',
		allowBlank: false,
        fieldLabel: 'Phone'
	});
	form.add(phone);
	var cardType = new Ext.form.ComboBox({
        name: 'cardType',
        fieldLabel: 'Card Type',
		store: [
			['visa', 'Visa'],
			['mc', 'Mastercard'],
			['amex', 'American Express'],
			['disc', 'Discover']
		]
	});
	form.add(cardType);
	var cardNumber = new Ext.form.TextField({
        xtype: 'textfield',
        name: 'cardNumber',
		allowBlank: false,
        fieldLabel: 'Card Number'
	});
	form.add(cardNumber);
	var expMonth = new Ext.form.NumberField({
        xtype: 'numberfield',
        name: 'expMonth',
		allowBlank: false,
		allowNegative: false,
		allowDecimals: false,
		minValue: 1,
		maxValue: 12,
        fieldLabel: 'Exp. Month',
		step:1,
		value: new Date().getMonth() + 1
	});
	form.add(expMonth);
	var expYear = new Ext.form.NumberField({
        xtype: 'numberfield',
        name: 'expYear',
		allowBlank: false,
		allowNegative: false,
		allowDecimals: false,
		minValue: new Date().getFullYear(),
		maxValue: new Date().getFullYear() + 10,
        fieldLabel: 'Exp. Year',
		value: new Date().getFullYear(),
		step:1
	});
	form.add(expYear);
	var role = new Ext.form.RadioGroup({
		fieldLabel: 'Role',
		columns: 2,
		items: [
			{boxLabel: 'User', name: 'role', inputValue: 'user', checked: true},
			{boxLabel: 'Admin', name: 'role', inputValue: 'admin'}					
		]
	});
	form.add(role);
	if (id > -1) {
		Ext.Ajax.request({
			url: '/admin/user/' + id,
			success: function(response) {
				var user = Ext.decode(response.responseText).user;
				firstName.setValue(user.first_name);
				lastName.setValue(user.last_name);
				email.setValue(user.email);
				address1.setValue(user.address_1);
				address2.setValue(user.address_2);
				city.setValue(user.city);
				state.setValue(user.state);
				postal.setValue(user.postal);
				phone.setValue(user.phone);
				if (user.role == 'user') {
					role.setValue({role: ['user']});
				} else {
					role.setValue({role: ['admin']});
				}	
				cardType.setValue(user.card_type);
				expMonth.setValue(user.expiration_month);
				expYear.setValue(user.expiration_year);	
				cardNumber.setValue(user.card_number);		
			}
		});	
	}	
}

function showGroup(form, id, parentId) {
	form.setTitle('Group Detail');
	if (id == -1) {
		form.form.url = '/admin/choiceOptionGroup';
		form.form.method='POST';
	} else {
		form.form.url = '/admin/choiceOptionGroup/'+id;			
		form.form.method='PUT';
	}
	form.removeAll(true);
	var parent = new Ext.form.Hidden({
		xtype: 'hiddenfield',
		name: 'parent',
		value: parentId
	});
	form.add(parent);			
	var name = new Ext.form.TextField({
        xtype: 'textfield',
        name: 'name',
		allowBlank: false,
        fieldLabel: 'Name'
	});
	form.add(name);
	var position = new Ext.form.NumberField({
        xtype: 'numberfield',
        name: 'position',
		allowBlank: false,
		allowNegative: false,
		allowDecimals: false,
		minValue: 0,
        fieldLabel: 'Position',
		step:1,
		minValue:1
	});
	form.add(position);
	var maxQuantity = new Ext.form.NumberField({
        xtype: 'numberfield',
        name: 'maxQuantity',
        fieldLabel: 'Max Quantity',
		allowBlank: false,
		allowNegative: false,
		allowDecimals: false,
		minValue: 0,
		step:1,
		minValue:1
	});
	form.add(maxQuantity);
	var itemType = new Ext.form.RadioGroup({
		fieldLabel: 'Type',
		columns: 2,
		items: [
			{boxLabel: 'Choice', name: 'itemType', inputValue: 'choice', checked: true},
			{boxLabel: 'Option', name: 'itemType', inputValue: 'option'}					
		]
	});
	form.add(itemType);	
	if (id > -1) {
		Ext.Ajax.request({
			url: '/admin/choiceOptionGroup/' + id,
			success: function(response) {
				var choiceOptionGroup = Ext.decode(response.responseText).choice_option_group;
				name.setValue(choiceOptionGroup.name);
				position.setValue(choiceOptionGroup.position);
				maxQuantity.setValue(choiceOptionGroup.max_quantity);
				if (choiceOptionGroup.item_type == 2) {
					itemType.setValue({itemType: ['choice']});
				} else {
					itemType.setValue({itemType: ['option']});
				}
			}
		});	
	}
}

function showChoiceOption(form, id, parentId) {
	form.setTitle('Choice / Option Detail');
	if (id == -1) {
		form.form.url = '/admin/choiceOption';
		form.form.method='POST';
	} else {
		form.form.url = '/admin/choiceOption/'+id;			
		form.form.method='PUT';
	}	
	form.removeAll(true);
	var parent = new Ext.form.Hidden({
		xtype: 'hiddenfield',
		name: 'parent',
		id: 'parent',
		value: parentId
	});
	form.add(parent);			
	var name = new Ext.form.TextField({
        xtype: 'textfield',
        name: 'name',
		allowBlank:false,
        fieldLabel: 'Name'
	});
	form.add(name);
	var position = new Ext.form.NumberField({
        xtype: 'numberfield',
        name: 'position',
		allowBlank: false,
		allowNegative: false,
		allowDecimals: false,
		minValue: 0,		
        fieldLabel: 'Position',
		step:1,
		minValue:1
	});
	form.add(position);
	var price = new Ext.form.TextField({
        xtype: 'numberfield',
		allowBlank:false,
		allowNegative: false,
		allowDecimals: true,
		minValue: 0,		
        name: 'price',
        fieldLabel: 'Price'
	});
	form.add(price);
	if (id > -1) {	
		Ext.Ajax.request({
			url: '/admin/choiceOption/' + id,
			success: function(response) {
				var choiceOption = Ext.decode(response.responseText).choice_option;
				name.setValue(choiceOption.name);
				position.setValue(choiceOption.position);
				price.setValue(choiceOption.price);
			}
		});	
	}
}

function showCompany(form, id) {
	form.setTitle('Company Detail');
	if (id == -1) {
		form.form.url = '/admin/company';
		form.form.method='POST';
	} else {
		form.form.url = '/admin/company/'+id;			
		form.form.method='PUT';
	}
	form.removeAll(true);
	var name = new Ext.form.TextField({
        xtype: 'textfield',
        name: 'name',
		allowBlank: false,
        fieldLabel: 'Name'
	});
	form.add(name);
	var context = new Ext.form.TextField({
        xtype: 'textfield',
        name: 'context',
		allowBlank: false,
        fieldLabel: 'Context'
	});
	form.add(context);	
	if (id > -1) {
		Ext.Ajax.request({
			url: '/admin/company/' + id,
			success: function(response) {
				var company = Ext.decode(response.responseText).company;
				name.setValue(company.name);
				context.setValue(company.context);	
			}
		});
	}
}

function showLocation(form, id, parentId) {
	form.setTitle('Location Detail');
	if (id == -1) {
		form.form.url = '/admin/location';
		form.form.method='POST';
	} else {
		form.form.url = '/admin/location/'+id;			
		form.form.method='PUT';
	}	
	form.removeAll(true);
	var parent = new Ext.form.Hidden({
		xtype: 'hiddenfield',
		name: 'parent',
		id: 'parent',
		value: parentId
	});
	form.add(parent);			
	var name = new Ext.form.TextField({
        xtype: 'textfield',
        name: 'name',
		allowBlank: false,
        fieldLabel: 'Name'
	});
	form.add(name);
	var context = new Ext.form.TextField({
        xtype: 'textfield',
        name: 'context',
		allowBlank: false,
        fieldLabel: 'Context'
	});
	form.add(context);	
	var address1 = new Ext.form.TextField({
        xtype: 'textfield',
        name: 'address1',
		allowBlank: false,
        fieldLabel: 'Address'
	});
	form.add(address1);	
	var address2 = new Ext.form.TextField({
        xtype: 'textfield',
        name: 'address2',
		allowBlank: true,
        fieldLabel: 'Address 2'
	});
	form.add(address2);
	var city = new Ext.form.TextField({
        xtype: 'textfield',
        name: 'city',
		allowBlank: false,
        fieldLabel: 'City'
	});
	form.add(city);	
	var state = new Ext.form.TextField({
        xtype: 'textfield',
        name: 'state',
		allowBlank: false,
        fieldLabel: 'State'
	});
	form.add(state);	
	var postal = new Ext.form.TextField({
        xtype: 'textfield',
        name: 'postal',
		allowBlank: false,
        fieldLabel: 'Postal'
	});
	form.add(postal);
	var phone = new Ext.form.TextField({
        xtype: 'textfield',
        name: 'phone',
        fieldLabel: 'Phone',
		allowBlank: false,
		value: location.phone
	});
	form.add(phone);																	
	var taxRate = new Ext.form.TextField({
        xtype: 'numberfield',
        name: 'taxRate',
        fieldLabel: 'Tax Rate',
		minValue:00,
		maxValue:99,
		allowBlank: false,
		allowNegative: false,
		allowDecimals: true
	});
	form.add(taxRate);	
	var deliveryIncrement = new Ext.form.TextField({
        xtype: 'numberfield',
        name: 'deliveryIncrement',
        fieldLabel: 'Delivery Increment',
		allowBlank: false,
		allowNegative: false,
		allowDecimals: false,
		minValue: 0
	});
	form.add(deliveryIncrement);
	var deliveryPadding = new Ext.form.TextField({
        xtype: 'numberfield',
        name: 'deliveryPadding',
        fieldLabel: 'Delivery Padding',
		allowBlank: false,
		allowNegative: false,
		allowDecimals: false,
		minValue: 0
	});
	form.add(deliveryPadding);	
	var merchantId = new Ext.form.TextField({
        xtype: 'numberfield',
        name: 'merchantId',
        fieldLabel: 'Merchant Id',
		allowBlank: false
	});
	form.add(merchantId);	
	var apiTransactionKey = new Ext.form.TextField({
        xtype: 'textfield',
        name: 'apiTransactionKey',
        fieldLabel: 'API Transaction Key',
		allowBlank: false
	});
	form.add(apiTransactionKey);	
	
	if (id > -1) {
		Ext.Ajax.request({
			url: '/admin/location/' + id,
			success: function(response) {
				var location = Ext.decode(response.responseText).location;
				name.setValue(location.name);
				context.setValue(location.context);
				address1.setValue(location.address1);
				address2.setValue(location.address2);
				city.setValue(location.city);
				state.setValue(location.state);
				postal.setValue(location.postal);
				phone.setValue(location.phone);
				taxRate.setValue(location.tax_rate);
				deliveryIncrement.setValue(location.delivery_increment);
				deliveryPadding.setValue(location.delivery_padding);
				merchantId.setValue(location.merchant_id);
				apiTransactionKey.setValue(location.api_transaction_key);
			}
		});	
	}
}

function showCategory(form, id, parentId) {
	form.setTitle('Category Detail');
	if (id == -1) {
		form.form.url = '/admin/category';
		form.form.method='POST';
	} else {
		form.form.url = '/admin/category/'+id;			
		form.form.method='PUT';
	}
	form.removeAll(true);
	var parent = new Ext.form.Hidden({
		xtype: 'hiddenfield',
		name: 'parent',
		id: 'parent',
		value: parentId
	});
	form.add(parent);			
	var name = new Ext.form.TextField({
        xtype: 'textfield',
        name: 'name',
		allowBlank: false,
        fieldLabel: 'Name'
	});
	form.add(name);
	var position = new Ext.form.NumberField({
        xtype: 'numberfield',
        name: 'position',
        fieldLabel: 'Position',
		step:1,
		allowBlank: false,
		allowNegative: false,
		allowDecimals: false,
		minValue: 0,		
		minValue:1
	});
	form.add(position);
	if (id > -1) {		
		Ext.Ajax.request({
			url: '/admin/category/' + id,
			success: function(response) {
				var category = Ext.decode(response.responseText).category;
				name.setValue(category.name);
				position.setValue(category.position);
			}
		});
	}	
}

function showMenuItem(form, id, parentId) {
	form.setTitle('Menu Item Detail');
	if (id == -1) {
		form.form.url = '/admin/menuItem';
		form.form.method='POST';
	} else {
		form.form.url = '/admin/menuItem/'+id;			
		form.form.method='PUT';
	}	
	form.removeAll(true);
	var parent = new Ext.form.Hidden({
		xtype: 'hiddenfield',
		name: 'parent',
		id: 'parent',
		value: parentId
	});
	form.add(parent);			
	var name = new Ext.form.TextField({
        xtype: 'textfield',
        name: 'name',
		allowBlank: false,
        fieldLabel: 'Name'
	});
	form.add(name);
	var description = new Ext.form.TextArea({
        xtype: 'textareafield',
        name: 'description',
		allowBlank: false,
        fieldLabel: 'Description',
		grow:true,
	});
	form.add(description);	
	var price = new Ext.form.TextField({
        xtype: 'textfield',
        name: 'price',
		allowBlank: false,
		allowNegative: false,
		allowDecimals: true,
		minValue: 0,
        fieldLabel: 'Price'
	});
	form.add(price);
	var position = new Ext.form.NumberField({
        xtype: 'numberfield',
        name: 'position',
        fieldLabel: 'Position',
		allowBlank: false,
		allowNegative: false,
		allowDecimals: false,
		minValue: 0,
		step:1
	});
	form.add(position);	
	if (id > -1) {
		Ext.Ajax.request({
			url: '/admin/menuItem/' + id,
			success: function(response) {
				var menuItem = Ext.decode(response.responseText).menu_item;
				name.setValue(menuItem.name);
				description.setValue(menuItem.description);
				price.setValue(menuItem.price);
				position.setValue(menuItem.position);
			}
		});	
	}
}