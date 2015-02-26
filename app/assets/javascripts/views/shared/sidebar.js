SocialApp.Views.SideBar = Backbone.CompositeView.extend({
	template: JST["shared/sidebar"],

	initialize: function(){
		this.current_user = SocialApp.current_user
	},

	render: function(){
		var content = this.template({current_user: this.current_user});
		this.$el.html(content);

		this.addCurrentUser();
		this.addFriends();
		this.addPendingFriends();
		
		return this;
	},

	addCurrentUser: function(){
		var subview = new SocialApp.Views.UserCurrent();
		this.addSubview("#sidebar", subview);
	},

	addFriends: function(){
		var subview = new SocialApp.Views.UserFriends();
		this.addSubview("#sidebar", subview);
	},

	addPendingFriends: function(){
		var subview = new SocialApp.Views.UserPendingFriends();
		this.addSubview( "#sidebar", subview);
	},
});