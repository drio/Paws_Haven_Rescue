(function ($) {
    //demo data
    var data_available_dogs = [
        { id: 1, name: "simba", breed: "cocapu", notes: "yes! notes here." },
        { id: 2, name: "dog 2", breed: "cocapu", notes: "yes! notes here." },
        { id: 3, name: "dog 3", breed: "cocapu", notes: "yes! notes here." },
        { id: 4, name: "dog 4", breed: "cocapu", notes: "yes! notes here." },
        { id: 5, name: "dog 5", breed: "cocapu", notes: "yes! notes here." },
        { id: 6, name: "dog 6", breed: "cocapu", notes: "yes! notes here." },
        { id: 7, name: "dog 7", breed: "cocapu", notes: "yes! notes here." },
        { id: 8, name: "dog 8", breed: "cocapu", notes: "yes! notes here." }
    ];

    var data_happy_dogs = [
        { id: 1, name: "dog happy 1" },
        { id: 2, name: "dog happy 2" },
        { id: 3, name: "dog happy 3" },
        { id: 4, name: "dog happy 4" },
        { id: 5, name: "dog happy 1" }
    ];

    // Dog Model
    ///////////////////////////////////////////////////////////////
    var Dog = Backbone.Model.extend({
        defaults: {
          photo: "img/swim-simba.jpg"
        }
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
      routes: {
        "available" : "show_available",
        "happy"     : "show_happy",
        "dog/:id"   : "details",
        "*other"    : "defaultRoute"
      },

      show_available: function() {
        var dogs = new Dogs();
        dogs.reload_col(data_available_dogs);
      },

      show_happy: function() {
        var dogs = new Dogs();
        dogs.reload_col(data_happy_dogs);
      },

      details: function(id) {
        var col     = new colDogs(data_available_dogs),
            dog     = col.get(id),
            details = new DetailsView();
        details.render(dog);
      },

      defaultRoute: function() {
        this.show_available();
      }
    });

    // MAIN
    ///////////////////////////////////////////////////////////
    var routes = new AppRoutes();
    Backbone.history.start();
    routes.navigate();

} (jQuery));
