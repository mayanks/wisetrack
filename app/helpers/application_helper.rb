module ApplicationHelper
  def rs(a)
    if a
      if a < 0
        content_tag(:span,"Rs. " + a.to_s,:class => "negative money")
      else
        content_tag(:span,"Rs. " + a.to_s,:class => "money")
      end
    end
  end
end
