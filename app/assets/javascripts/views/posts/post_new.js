SocialApp.Views.PostNew = Backbone.CompositeView.extend({
	template: JST["posts/new"],
	tagName: "li",

	initialize: function(options){
		this.posts = options.posts;
		this.author_id = options.author_id;
		this.parent_view = options.parent_view;
	},

	events: {
		"submit form": "createPost",
	},

	render: function(){
		var content = this.template({author_id: this.author_id});
		this.$el.html(content);
		return this;
	},

	createPost: function(event){
		event.preventDefault();
		var params = $(event.currentTarget).serializeJSON();
		var newPost = new SocialApp.Models.Post(params);

		var view = this;

		newPost.save({}, {
			success: function(response){
				view.posts.add(newPost);

				$('#title').val('')
				$('#body').val('')
				
				SocialApp.current_user.fetch({
					success: function(){
						response.authorId = response.escape('author_id');
						view.addPost(response);
					}
				})
			}
		});
	},

	addPost: function(post){
		var subview = new SocialApp.Views.PostShow({post: post});
		this.prependSubview("ul.new-posts", subview);
	}


})