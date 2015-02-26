SocialApp.Routers.Router = Backbone.Router.extend({
	initialize: function(options){
		this.$main = options.$main;
		this.posts = options.posts;
		this.users = options.users;
	},

	routes: {
		"": "root",
		"sessions/new": "sessionNew",
		"users/new": "userNew",
		"users/:id":  "userShow",
	},

	root: function(){
		var view = new SocialApp.Views.Root({users: this.users});
		this._swapView(view);
	},

	sessionNew: function(){
		var view = new SocialApp.Views.SessionNew({users: this.users});
		this._swapView(view);
	},

	userNew :function(){
		var view = new SocialApp.Views.UserNew({users: this.users});
		this._swapView(view);
	},

	userShow: function(id){
		var user = this.users.getOrFetch(id);
		var view = new SocialApp.Views.UserShow({user: user});
		this._swapView(view);
	},

	_swapView: function(view){
		this.currentView && this.currentView.remove();
		this.currentView = view;
		this.$main.html(view.render().$el);
	}
});