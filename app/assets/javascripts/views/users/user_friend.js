SocialApp.Views.UserFriend = Backbone.CompositeView.extend({
	template: JST["users/friend"],
	tagName: "li",
	className: "clearfix",

	initialize: function(options){
		this.state = options.state;
		this.friend = options.friend;
		this.listenTo(this.friend, 'synch change', this.render)
	},

	events: {
		"click .approve-friendship": "approveFriendship",
		"click .deny-friendship": "denyFriendship",
		"click .send-friendship": "sendFriendship"
	},

	render: function(){
		var content = this.template({friend: this.friend, state: this.state});
		this.$el.html(content);
		return this;
	},

	approveFriendship: function(event){
		event.preventDefault();
		urlPath = "api/users/" + SocialApp.current_user.id + "/friendships/" + this.friend.id;
		$.ajax({
			type: "PATCH",
			url: urlPath,
			success: function(response){
				SocialApp.current_user.fetch();
				Backbone.history.loadUrl(Backbone.history.fragment);
			},
			error: function(response){
				console.log(response.error);
			}
		});
	},

	denyFriendship: function(event){
		event.preventDefault();
		var urlPath = "api/users/" + SocialApp.current_user.id +
					"/friendships/1?" + 
					$.param({"left_friend_id": this.friend.id});

		$.ajax({
			type: "DELETE",
			url: urlPath,
			success: function(response){
				console.log(response.message);
				SocialApp.current_user.fetch();
				Backbone.history.navigate("users/"+ 
					SocialApp.current_user.id , {trigger: true});
			},
			error: function(response){
				console.log(response.error);
			}
		});
	},

	sendFriendship: function(event){
		event.preventDefault();
		var urlPath = "api/users/" + SocialApp.current_user.id + "/friendships";
		
		$.ajax({
			type: "POST",
			url: urlPath,
			data: {"right_friend_id" : this.friend.id },
			success: function(response){
				Backbone.history.navigate("users/" + 
					SocialApp.current_user.id, {trigger: true});
			},
			error: function(response){
				console.log(response.error);
			}
		});
	},

})