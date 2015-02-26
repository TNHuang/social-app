SocialApp.Views.UserFriends = Backbone.CompositeView.extend({
	template: JST["users/friends"],
	
	initialize: function(){
		this.current_user = SocialApp.current_user;
		this.listenTo(this.current_user, 'sync change', this.render);
	},

	render: function (){
		var content = this.template();
		this.$el.html(content);

		var friends = this.current_user.friends().models;
		friends.forEach( function(e){ this.addFriend(e) }.bind(this));	
	
		return this;
	},

	addFriend: function(friend){
		var subview = new SocialApp.Views.UserFriend({friend: friend, state: "approve"});
		this.addSubview("ol.friends-list" , subview);
	}

})