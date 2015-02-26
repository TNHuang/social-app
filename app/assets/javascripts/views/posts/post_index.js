SocialApp.Views.PostIndex = Backbone.CompositeView.extend({
	template: JST["posts/index"],
	id: "main-container",

	initialize: function(options){
		this.author = options.author;
		this.posts = this.author.allPosts();
		this.listenTo(this.author, "sync change", this.render);

	},

	render: function(){
		var content = this.template({});
		this.$el.html(content);

		if (this.author.id === SocialApp.current_user.id) {
			this.addPostNew();
		}
		this.posts.models.forEach( this.addPost.bind(this) );

		return this;
	},

	addPostNew: function(){
		var subview = new SocialApp.Views.PostNew({
			posts: this.posts,
			author_id: this.author.id,
			parent_view: this
		});
		this.addSubview("ul.posts", subview);
	},

	addPost: function(post){
		var subview = new SocialApp.Views.PostShow({post: post, state: "new"});
		this.addSubview("ul.posts", subview);
	},

})