class Picker {
  constructor() {
    this.bind_events();
  }

  bind_events() {
    var self = this;
    var input = $("#btag_input")[0];
    $("#btag_submit").bind("click", function() {
      self.set_battletag(input.value);
    });
  }

  set_battletag(tag) {
    window.alert("battletag: " + tag);
  }
};

window.picker = new Picker();
