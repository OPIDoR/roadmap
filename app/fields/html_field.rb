require 'administrate/field/base'

class HtmlField < Administrate::Field::Base
  def to_s
    data.html_safe
  end
end
