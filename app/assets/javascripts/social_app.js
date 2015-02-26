window.SocialApp = {
	Models: {},
	Collections: {},
	Views: {},
	Routers: {},
	initialize: function(){
		SocialApp.current_user = {};
		var users = new SocialApp.Collections.Users();
		var posts = new SocialApp.Collections.Posts();

		new SocialApp.Routers.Router({
			$main: $("body"),
			posts: posts,
			users: users
		});
		Backbone.history.start()	
	}
} 

$(document).ready(function(){
	window.SocialApp.initialize();
});
