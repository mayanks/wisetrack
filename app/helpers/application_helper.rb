module ApplicationHelper
  def stringify_amount(a)
    a = a.to_s
    if a.length <= 3
      return a
    else
      numbers = [a.slice!(-3..-1)]
      while(a.length > 2)
        numbers.insert(0,a.slice!(-2..-1))
      end
      if a.length != 0
        numbers.insert(0,a)
      end
      return numbers.join(",")
    end
  end

  def rs(a)
    if a
      if a < 0
        content_tag(:span,"Rs. -" + stringify_amount(-a),:class => "negative money")
      else
        content_tag(:span,"Rs. " + stringify_amount(a),:class => "money")
      end
    end
  end
end
