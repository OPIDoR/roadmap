class HomepageMessage < ActiveRecord::Base
  validates :level, :text, presence: true

  def html_classes
    case level
    when 1
      'alert alert-info'
    when 2
      'alert alert-warning'
    else
      'alert alert-error'
    end
  end
end
