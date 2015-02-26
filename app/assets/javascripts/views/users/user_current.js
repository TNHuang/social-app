SocialApp.Views.UserCurrent = Backbone.CompositeView.extend({
	template: JST["users/current"],

	initialize: function(){
		this.current_user = SocialApp.current_user;
	},

	render: function(){
		var content = this.template({current_user: this.current_user});
		this.$el.html(content);

		this.addFriend(this.current_user);
		
		return this;	
	},

	addFriend: function(friend){
		var subview = new SocialApp.Views.UserFriend({friend: friend, state: "self"});
		this.addSubview("ol.current-user-info" , subview);
	}
});