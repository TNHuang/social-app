SocialApp.Views.UserNew = Backbone.CompositeView.extend({
	template: JST["shared/user_form"],
	id: "root",

	initialize: function(options){
		this.users = options.users;
	},

	events: {
		"submit form": "createUser"
	},

	render: function(){
		var content = this.template({action: "create", obj: "user"});
		this.$el.html(content)
		return this;
	},

	createUser: function(event){
		event.preventDefault();
		var params = $(event.currentTarget).serializeJSON();
		var newUser = new SocialApp.Models.User(params);

		newUser.save({}, {
			success: function(response){
				this.users.add(newUser);
				SocialApp.current_user = 
					this.users.getOrFetch(response.id);
				Backbone.history.navigate("users/" + response.id, {trigger: true});
			}.bind(this),
			error: function(response){
				console.log(response);
			}
		});
	},
})