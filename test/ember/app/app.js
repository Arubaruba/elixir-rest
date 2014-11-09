var App = Ember.Application.create();

App.ApplicationAdapter = DS.RESTAdapter.extend({
  updateRecord: function (store, type, record) {
    return this.ajax(this.buildURL(type.typeKey, record.get('id')), 'POST', record);
  },
  deleteRecord: function (store, type, record) {
    return this.ajax(this.buildURL(type.typeKey, record.get('id')), 'POST', {});
  }
});

App.User = DS.Model.extend({
  name: DS.attr('string')
});

App.ApplicationRoute = Ember.Route.extend({
  model: function () {
    return this.store.find('user', {name: 'test'});
  }
});

App.ApplicationController = Ember.Controller.extend({
  newValue: '',
  actions: {
    del: function (user) {
      user.destroyRecord();
    },
    pop: function () {
      //this.get('values').popObject();
    },
    push: function () {
      var controller = this;
      this.store.createRecord('user', {
        name: controller.get('newValue')
      }).save();
    }
  }
});