# == Schema Information
#
# Table name: sections
#
#  id             :integer          not null, primary key
#  description    :text
#  modifiable     :boolean
#  number         :integer
#  title          :string(510)
#  created_at     :datetime
#  updated_at     :datetime
#  phase_id       :integer
#  versionable_id :string(36)
#
# Indexes
#
#  index_sections_on_versionable_id  (versionable_id)
#  sections_phase_id_idx             (phase_id)
#
# Foreign Keys
#
#  fk_rails_...  (phase_id => phases.id)
#

FactoryBot.define do
  factory :section do
    title { Faker::Lorem.sentence }
    description { Faker::Lorem.paragraph }
    sequence(:number)
    phase
    modifiable { false }
  end
end
