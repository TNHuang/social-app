SocialApp.Views.Root = Backbone.CompositeView.extend({
	template: JST["root/root"],
	id: "root",
	className: "clearfix",

	initialize: function(options){
		this.users = options.users;
	},

	render: function(){
		var content = this.template();
		this.$el.html(content);
		return this;
	},

	events: {
		"click #guest-sign-in": "guestSignIn"
	},

	guestSignIn: function(event){
		event.preventDefault();
		$.ajax({
			type: "POST",
			url: "api/guest_sign_in",
			success: function(response){
				SocialApp.current_user = 
					this.users.getOrFetch(response.id);
				Backbone.history.navigate("users/" + response.id, {trigger: true});
			}.bind(this)
		})
	}

});