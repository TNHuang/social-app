SocialApp.Models.Post = Backbone.Model.extend({
	urlRoot: function(){
		if (this.author_id){
			return "api/users/" + this.escape('authorId') + "/posts"
		} else {
			return "api/users/" + SocialApp.current_user.id + "/posts"
		}
		
	} 
})