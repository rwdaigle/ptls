jQuery.fn.extend({
  
  hideAnswer: function() {
    $('a.hideAnswer').hide();
    $('a.showAnswer').show();
    $('#answer').hide();
  },
  
  showAnswer: function() {
    $('a.showAnswer').hide();
    $('a.hideAnswer').show();
    $('#answer').show();
  }
});

/* Bind onclick of tab to hide */
$(document).ready(function() {
	$('#answer_wrapper p.tab a.showAnswer').click(function() {
		$().showAnswer();
		this.class_name = 'show hidden'
	});
	$('#answer_wrapper p.tab a.hideAnswer').click(function() {
		$().hideAnswer();
	});
});

/* Keyboard shortcuts */
$().keypress(function (e) {
  if(String.fromCharCode(e.which) == "s")
    $().showAnswer();
  else if(String.fromCharCode(e.which) == "g")
    alert('g');
  else if(String.fromCharCode(e.which) == "m")
    alert('m');
  else if(String.fromCharCode(e.which) == "h")
    $().hideAnswer();
  else if(String.fromCharCode(e.which) == "n")
    alert('n');
  else if(String.fromCharCode(e.which) == "q")
    document.location = '/subjects/show'
});