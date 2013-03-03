module ApplicationHelper
  def yield_for(content_sym, default)
    output = content_for(content_sym)
    output = default if output.blank?
    if content_sym == :title and output != 'HelloHero'
      output = output + ' | HelloHero'
    end
    output
  end
end
