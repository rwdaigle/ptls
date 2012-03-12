jQuery.fn.toggleHint = function() {
  this.toggleClass('expanded').toggleClass('collapsed');
}  

jQuery.fn.editHint = function() {
  this.showHint();
  if(this.inEditHintMode()) {
    $('#association_body').focus().select();
  } else {
    $('#edit_hint').click();
  }
}

jQuery.fn.showHint = function() {
  if(this.hasClass('collapsed')) {
    this.toggleClass('expanded').toggleClass('collapsed');
  }
}

jQuery.fn.hideHint = function() {
  if(this.hasClass('expanded')) {
    this.toggleClass('expanded').toggleClass('collapsed');
  }
}

jQuery.fn.inEditHintMode = function() {
  return this.find('form').length > 0
}

