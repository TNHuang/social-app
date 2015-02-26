SocialApp.Views.UserPendingFriends = Backbone.CompositeView.extend({
	template: JST["users/pending_friends"],

	initialize: function(options){
		this.current_user = SocialApp.current_user;
		this.listenTo(this.current_user, 'sync change', this.render);
	},

	render: function (){
		var content = this.template();
		this.$el.html(content);

		var pendingFriends = this.current_user.pendingFriends().models;
		pendingFriends.forEach( function(e){ this.addFriend(e) }.bind(this));	

		return this;
	},

	addFriend: function(friend){
		var subview = new SocialApp.Views.UserFriend({friend: friend, state: "pending"});
		this.addSubview("ol.pending-friends-list", subview);
	}

})