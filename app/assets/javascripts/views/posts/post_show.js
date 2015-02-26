SocialApp.Views.PostShow = Backbone.CompositeView.extend({
	template: JST["posts/show"],
	tagName: "li",
	
	initialize: function(options){
		this.post = options.post;
		this.listenTo(this.post, "sync change", this.render);
	},

	render: function (){
		var content = this.template({post: this.post});
		this.$el.html(content);
		return this;
	},

})