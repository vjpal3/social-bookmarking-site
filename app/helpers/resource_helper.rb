module ResourceHelper
  # def devise_error_messages!
  #   if resource.errors.full_messages.any?
  #       flash.now[:error] = "Please correct following fields: \\n"
  #       flash.now[:error] += resource.errors.full_messages.join('\\n')
  #   end
  #   return ''
  # end

  def resource_error_messages!
    return "" unless resource_error_messages?

   messages = resource.errors.full_messages.map { |msg| content_tag(:li, msg) }.join
   # sentence = I18n.t("errors.messages.not_saved",
   #                   :count => resource.errors.count,
   #                   :resource => resource.class.model_name.human.downcase)
   sentence = "Please correct following errors: "

   html = <<-HTML
   <div id="error_explanation">
     <span>#{sentence}</span>
     <ul>#{messages}</ul>
   </div>
   HTML

   html.html_safe
 end

 def resource_error_messages?
   !resource.errors.empty?
 end

end
