SocialApp.Models.User = Backbone.Model.extend({
	urlRoot: "/api/users",

	friends: function(){
		if(!this._friends){
			this._friends = new SocialApp.Collections.Users([], { user: this});
		}
		return this._friends;
	},

	pendingFriends: function(){
		if(!this._pendingFriends){
			this._pendingFriends = new SocialApp.Collections.Users([], { user: this});
		}
		return this._pendingFriends;
	},

	allPosts: function(){
		if(!this._allPosts){
			this._allPosts = new SocialApp.Collections.Posts([], { user: this})
		}
		return this._allPosts;
	},

	parse: function(response){
		if(response.friends){
			this.friends().set(response.friends, {parse: true});
			delete response.friends;
		}
		if (response.pendingFriends){
			this.pendingFriends().set(response.pendingFriends, {parse: true});
			delete response.pendingFriends;
		}
		if (response.allPosts){
			this.allPosts().set(response.allPosts, {parse: true});
			delete response.allPosts;
		}
		return response;
	},
});