Ext.ns('mobile', 'Ext.ux');

Ext.ux.UniversalUI = Ext.extend(Ext.Panel, {
	fullscreen: true,
	layout: 'card',
	items: [{
		
	}],
	backText: 'Back',
	useTitleAsBackText: true,
	initComponent : function() {
		this.backButton = new Ext.Button({
			text: this.backText,
			ui: 'back',
			handler: this.onUiBack,
			hidden: true,
			scope: this
		});
		this.bottomTabs = new Ext.TabPanel({
			tabBar: {
				dock: 'bottom',
				ui: 'light',
				layout: {
					pack: 'center'
				}
			},
			cardSwitchAnimation: {
				type: 'slide',
				cover: true
			},
			defaults: {
				scroll: 'vertical'
			},
			items: [{
				title: 'About',
				html: '<p>Docking tabs to the bottom</p>',
				iconCls: 'info',
				cls: 'card card1'
			}]
		})
	},
	onUiBack: function() {
		
	}	
});


Ext.setup({
    tabletStartupScreen: 'tablet_startup.png',
    phoneStartupScreen: 'phone_startup.png',
    icon: 'icon.png',
    glossOnIcon: false,
    onReady: function() {
        this.ui = new Ext.ux.UniversalUI({
            title: Ext.is.Phone ? 'Mobile' : 'Breakinline Sink',
            useTitleAsBackText: false,
            buttons: [{xtype: 'spacer'}, this.sourceButton],
            listeners: {
                scope: this
            }
        });		
    }
});