SocialApp.Views.SessionNew = Backbone.CompositeView.extend({
	template: JST["shared/user_form"],
	id: "root",

	initialize: function(options){
		this.users = options.users;
	},

	events: {
		"submit form": "createSession",
	},

	render: function(){
		var content = this.template({action: "create", obj: "session"});
		this.$el.html(content)
		return this;
	},

	createSession: function(event){
		event.preventDefault();
		var sessionsParams = $(event.currentTarget).serializeJSON();
		//sign in sessiosn then assign current user to front end
		$.ajax({
			type: "POST",
			url: "api/sessions",
			data: sessionsParams,
			success: function(response){
				SocialApp.current_user = 
					this.users.getOrFetch(response.id);
				Backbone.history.navigate("users/" + response.id, {trigger: true});
			}.bind(this)
		});
	},

})