SocialApp.Views.Header = Backbone.CompositeView.extend({
	template: JST["shared/header"],
	id: "header",
	className: "clearfix",

	initialize: function(options){
		this.current_user = SocialApp.current_user;
		this.parent_view = options.parent_view;
		this.listenTo(this.current_user, "sync change", this.render);
	},

	events: {
		"submit .search-box > form" : "searchFriends",
		"click .btn.sign-out": "signOut",
		"click .btn.sign-out-all": "signOutAllSessions"
	},

	render: function(){
		var content = this.template({
			current_user: this.current_user
		});
		this.$el.html(content);
		return this;
	},

	signOut: function(){
		$.ajax({
			type: "DELETE",
			url: "api/sessions/" + this.current_user.session_id,
			success: function(){
				Backbone.history.navigate("/", {trigger: true});
			}.bind(this)
		});
	},

	signOutAllSessions: function(event){
		$.ajax({
			type: "DELETE",
			url: "api/sessions/sign_out_all",
			success: function() {
				Backbone.history.navigate("/", {trigger: true})
			}.bind(this)
		});
	},

	searchFriends: function(event){
		event.preventDefault();
		var params = $(event.currentTarget).serializeJSON();

		$.ajax({
			type: "GET",
			url: "api/friendships/search",
			data: params,
			success: function(response){
				$("#query-box").val("");
				var new_friends = new SocialApp.Collections.Users(response.friends);
				this.switchMainviewToSearchResult(new_friends);
			}.bind(this)
		})
	},

	switchMainviewToSearchResult: function(new_friends){
		
		//remove old view so it doesnt accumlate view
		var old_main_view = this.parent_view.subviews(".body").splice(2);
		old_main_view.forEach(function(v){v.remove()});

		this.parent_view.addSearchResult(new_friends);
		Backbone.history.navigate(
			"users/" + SocialApp.current_user.id + "/search-friends-result"
			);
	}
});