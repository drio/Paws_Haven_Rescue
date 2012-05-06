(function ($) {
  //demo data
  /*
  var data_available_dogs = [ { id: 8, name: "dog 8", breed: "cocapu", notes: "yes! notes here." } ],
      data_happy_dogs = [ { id: 1, name: "dog happy 1" } ];
  */

  // Get doggy data via an AJAX request
  ///////////////////////////////////////////////////////////////
  var data_available_dogs, data_happy_dogs, data_all_dogs;
  $.ajax({
    async: false,
    dataType: "json",
    url: "dogs.json/available",
    success: function(data) { data_available_dogs = data }
  });
  $.ajax({
    async: false,
    dataType: "json",
    url: "dogs.json/happy",
    success: function(data) { data_happy_dogs = data }
  });
  $.ajax({
    async: false,
    dataType: "json",
    url: "dogs.json/all",
    success: function(data) { data_all_dogs = data }
  });

  // Dog MODEL
  //////////////////////////////////////////////////////////////
  var Dog = Backbone.Model.extend({
      defaults: { }
  });

  // Collection of Dogs
  //////////////////////////////////////////////////////////////
  var colDogs = Backbone.Collection.extend({
      model: Dog
  });

  // View of a Dog within the group
  ///////////////////////////////////////////////////////////
  var DogView = Backbone.View.extend({
    tagName: "article",
    className: "dog-container",
    template: $("#dogTemplate").html(),

    render: function () {
      var tmpl = _.template(this.template);
      $(this.el).html(tmpl(this.model.toJSON()));
      return this;
    }
  });

  // View for a SINGLE dog
  /////////////////////////////////////////////////////////////
  var DetailsView = Backbone.View.extend({
    el: $("#dynamic-content"),
    tagName: "article",
    className: "dog-details",
    template: $("#detailsTemplate").html(),

    render: function (dog) {
      this.model = dog;
      var tmpl   = _.template(this.template);
      $(this.el).html(tmpl(this.model.toJSON()));
      return this;
    }
  });

  // View to show collection of dogs
  /////////////////////////////////////////////////////////////
  var Dogs = Backbone.View.extend({
    el: $("#dynamic-content"),

    initialize: function () {
        this.collection = new colDogs([]);
    },

    reload_col: function(new_col) {
      this.$el.empty();
      this.collection = new colDogs(new_col);
      this.render();
    },

    render: function () {
        var that = this;
        _.each(this.collection.models, function (item) {
            that.renderContact(item);
        }, this);
    },

    renderContact: function (item) {
        var dogView = new DogView({
            model: item
        });
        this.$el.append(dogView.render().el);
    }
  });

  // ROUTES
  ////////////////////////////////////////////////////////
  var AppRoutes = Backbone.Router.extend({
    el: $("#dynamic-content"),

    routes: {
      "home"      : "show_home",
      "stories"   : "show_stories",
      "available" : "show_available",
      "happy"     : "show_happy",
      "dog/:id"   : "details",
      "*other"    : "defaultRoute"
    },

    /* TODO: This could be a single function for all the static templates */
    show_home   : function() { this.el.html($("#home_template").html()); },
    show_stories: function() { this.el.html($("#stories_template").html()); },

    show_available: function() {
      var dogs = new Dogs();
      dogs.reload_col(data_available_dogs);
    },

    show_happy: function() {
      var dogs = new Dogs();
      dogs.reload_col(data_happy_dogs);
    },

    details: function(id) {
      var col     = new colDogs(data_all_dogs),
          dog     = col.get(id),
          details = new DetailsView();
      details.render(dog);
    },

    defaultRoute: function() {
      this.show_home();
    }
  });

  // MAIN
  ///////////////////////////////////////////////////////////
  var routes = new AppRoutes();
  Backbone.history.start();
  routes.navigate();

} (jQuery));
