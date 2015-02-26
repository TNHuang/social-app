SocialApp.Views.UserShow = Backbone.CompositeView.extend({
	template: JST["users/show"],
	
	initialize: function(options){
		this.user = options.user;
		SocialApp.current_user = SocialApp.current_user || sessionStorage.current_user
	},

	render: function(){
		var content = this.template()
		this.$el.html(content);
		this.addHeader();
		this.addSidebar();
		this.addPostIndex();
		return this;
	},

	addHeader: function(){
		var subview = new SocialApp.Views.Header({parent_view: this});
		this.addSubview(".body", subview);
	},

	addSidebar: function(){
		var subview = new SocialApp.Views.SideBar();
		this.addSubview(".body", subview);
	},

	addPostIndex: function(){
		var subview = new SocialApp.Views.PostIndex({author: this.user});
		this.addSubview(".body", subview);
	},

	addSearchResult: function(new_friends){
		var subview = new SocialApp.Views.UserNewFriend({new_friends: new_friends})
		this.addSubview(".body", subview);
	},

});