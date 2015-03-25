window.SocialApp = {
	Models: {},
	Collections: {},
	Views: {},
	Routers: {},
	initialize: function(){
		
		var users = new SocialApp.Collections.Users();
		var posts = new SocialApp.Collections.Posts();
		var current_user_id = parseInt( $("#current-user-id").data("id") );

		if (SocialApp.current_user === undefined){
			if (current_user_id !== 0) {
				SocialApp.current_user = users.getOrFetch(current_user_id);
			} else {
				SocialApp.current_user = new SocialApp.Models.User();
			}
		}

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
