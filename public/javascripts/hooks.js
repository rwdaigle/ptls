$(document).ready(function() {

  /*------------------
   * All links with class 'show' should hide their 'hide' attribute and show
   * their targets when clicked
   */
  $('a.show').click(function() {
    link = $(this);
    $(link.attr('href')).show();
    $(link.attr('hide')).hide();
  });

  /*------------------
   * All links with class 'swap' should hide their 'for' attribute and show
   * their targets when clicked
   */
  $('a.swap').click(function() {
    link = $(this);
    $(link.attr('from')).slideToggle('fast');
    $(link.attr('href')).slideToggle('fast');
  });
  
  /*------------------
   * All forms that have a 'confirm' attribute should
   * display that confirmation message before
   * submitting.
   */
  $("form[confirm]").submit(function() {
  	return confirm($(this).attr('confirm'));
  });

  /*------------------
   * Every form that has a 'key' attribute should
   * be submitted when that key is invoked.
   */
  $("form[key]").each(function() {
    var $form = $(this);
    $(document).bind('keypress.' + $form.attr('key'), function() {
      $form.submit();
    });
  	// $.hotkeys.add($(this).attr('key'), { disableInInput: true },
  	//   function() { form.submit(); });
  });

  /*------------------
   * Every link that has a 'key' attribute should
   * be virtually clicked when that key is invoked.
   */
  $("a[key]").each(function() {
    var $anchor = $(this);
    $anchor.click(function() {
      $(document).attr('location', $anchor.attr('href'));
      return false;
    })
    $(document).bind('keypress.' + $anchor.attr('key'), function() {
      $anchor.click();
    });
  	// $.hotkeys.add($anchor.attr('key'), { disableInInput: true },
  	//   function() { $anchor.click(); }
  	// );
  });
});