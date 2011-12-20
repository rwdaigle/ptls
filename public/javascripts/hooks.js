var $j = jQuery.noConflict();

$j(document).ready(function() {

  /*------------------
   * All links with class 'show' should hide their 'hide' attribute and show
   * their targets when clicked
   */
  $j('a.show').click(function() {
    link = $j(this);
    $j(link.attr('href')).show();
    $j(link.attr('hide')).hide();
  });

  /*------------------
   * All links with class 'swap' should hide their 'for' attribute and show
   * their targets when clicked
   */
  $j('a.swap').click(function() {
    link = $j(this);
    $j(link.attr('from')).slideToggle('fast');
    $j(link.attr('href')).slideToggle('fast');
  });
  
  /*------------------
   * All forms that have a 'confirm' attribute should
   * display that confirmation message before
   * submitting.
   */
  $j("form[@confirm]").submit(function() {
  	return confirm($j(this).attr('confirm'));
  });

  /*------------------
   * Every form that has a 'key' attribute should
   * be submitted when that key is invoked.
   */
  $j("form[@key]").each(function() {
    var form = $j(this);
  	$j.hotkeys.add($j(this).attr('key'), { disableInInput: true },
  	  function() { form.submit(); });
  });

  /*------------------
   * Every link that has a 'key' attribute should
   * be virtually clicked when that key is invoked.
   */
  $j("a[@key]").each(function() {
    var anchor = $j(this);
    anchor.click(function() {
      $j(document).attr('location', anchor.attr('href'));
      return false;
    })
  	$j.hotkeys.add($j(this).attr('key'), { disableInInput: true },
  	  function() { anchor.click(); }
  	);
  });
});