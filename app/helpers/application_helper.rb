module ApplicationHelper
 
  # Set the title for the page
  def page_title(page_title)
    content_for(:page_title, page_title)
  end
  
  # Display any flash messages
  def messages
    flash.collect do |type, msg|
      content_tag(:div, msg, :class => type)
    end.join("\n")
  end
  
  def messages?
    flash.size > 0
  end
  
  # Print out this percentage
  def p(percent)
    sprintf("%0.0f%", percent)
  end
end
