SocialApp.Views.UserNewFriend = Backbone.CompositeView.extend({
	template: JST["users/new_friends"],
	id: "main-container",
	className: "clearfix",

	initialize: function(options){
		this.new_friends = options.new_friends;
	},

	render: function(){
		var content = this.template();
		this.$el.html(content);

		this.new_friends.forEach(this.addFriend.bind(this))
		return this;
	},

	addFriend: function(friend){
		var subview = new SocialApp.Views.UserFriend({friend: friend, state: "sending"});
		this.addSubview("ol.new-friends-list", subview);
	}
})