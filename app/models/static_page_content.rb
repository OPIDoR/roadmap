# == Schema Information
#
# Table name: static_page_contents
#
#  id             :integer          not null, primary key
#  title          :string
#  content        :text
#  static_page_id :integer          not null
#  language_id    :integer          not null
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#
# Indexes
#
#  index_static_page_contents_on_language_id     (language_id)
#  index_static_page_contents_on_static_page_id  (static_page_id)
#

class StaticPageContent < ActiveRecord::Base
  belongs_to :static_page
  belongs_to :language

  validates :language, uniqueness: { scope: :static_page_id }
end