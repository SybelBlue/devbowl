module QuestionsHelper
  def format_display_name(format)
    case format
    when "MultipleChoice"
      "Multiple Choice"
    when "ShortAnswer"
      "Short Answer"
    when "UmActually"
      "Um Actually"
    else
      format
    end
  end
end
