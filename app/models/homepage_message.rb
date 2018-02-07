class HomepageMessage < ActiveRecord::Base
  validates :level, :text, presence: true
end
