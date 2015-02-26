SocialApp.Collections.Users = Backbone.Collection.extend({
	url: "/api/users",
	model: SocialApp.Models.User,

	getOrFetch: function (id){
		var user = this.get(id);
		if (!user){
			user = new SocialApp.Models.User({id: id});
			user.fetch({
				success: function(){
					this.add(user);
				}.bind(this)
			});
		} else{
			user.fetch();
		}
		return user;
	},
});