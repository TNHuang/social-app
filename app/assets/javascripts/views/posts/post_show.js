SocialApp.Views.PostShow = Backbone.CompositeView.extend({
	template: JST["posts/show"],
	tagName: "li",
	
	initialize: function(options){
		this.post = options.post;
		
		if (this.post.escape('author_id') !== "" ) {
			this.post.set({ authorId: this.post.escape('author_id') });
		}

		this.listenTo(this.post, "sync change", this.render);
	},

	render: function (){
		var content = this.template({post: this.post});
		this.$el.html(content);
		return this;
	},

	events: {
		"click .swap-view": "swapView",
		"click .delete-post": "deletePost",
		"submit .edit-post-form": "updatePost",
	},

	swapView: function(event){
		event.preventDefault();
		this.$(".default, .edit").toggleClass("hidden");
	},

	updatePost: function(event){
		event.preventDefault();
		var params = this.$("form").serializeJSON();
		this.post.save({post: params["post"], id: this.post.id}, {
			success: function(){
				console.log("post udpated");
			}
		});
	},

	deletePost: function(event){
		event.preventDefault();
		this.post.destroy();
		this.remove();
	}

})