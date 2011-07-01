module ApplicationHelper
  def title
    base_title = "Breakinline"
    if @title.nil?
      base_title
    else
      "#{base_title} | #{@title}"
    end
  end
  def html_escape(s)
    s.to_s.gsub(/&/, "&amp;").gsub(/\"/, "&quot;").gsub(/>/, "&gt;").gsub(/</, "&lt;").gsub(/'/, "&#39;")
  end
end
