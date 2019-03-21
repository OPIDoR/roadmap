# == Schema Information
#
# Table name: plans
#
#  id                                :integer          not null, primary key
#  complete                          :boolean
#  data_contact                      :string(510)
#  data_contact_email                :string(510)
#  data_contact_phone                :string(510)
#  description                       :text
#  feedback_requested                :boolean
#  funder_name                       :string(510)
#  grant_number                      :string(510)
#  identifier                        :string(510)
#  principal_investigator            :string(510)
#  principal_investigator_email      :string(510)
#  principal_investigator_identifier :string(510)
#  principal_investigator_phone      :string(510)
#  title                             :string(510)
#  visibility                        :integer          default(3), not null
#  created_at                        :datetime
#  updated_at                        :datetime
#  template_id                       :integer
#
# Indexes
#
#  plans_template_id_idx  (template_id)
#
# Foreign Keys
#
#  fk_rails_...  (template_id => templates.id)
#

FactoryBot.define do
  factory :plan do
    title { Faker::Company.bs }
    template
    grant_number { SecureRandom.rand(1_000) }
    identifier { SecureRandom.hex }
    description { Faker::Lorem.paragraph }
    principal_investigator { Faker::Name.name }
    funder_name { Faker::Company.name }
    data_contact_email { Faker::Internet.safe_email }
    principal_investigator_email { Faker::Internet.safe_email }
    feedback_requested { false }
    complete { false }
    transient do
      phases { 0 }
      answers { 0 }
      guidance_groups { 0 }
    end
    trait :creator do
      after(:create) do |obj|
        obj.roles << create(:role, :creator, user: create(:user, org: create(:org)))
      end
    end
    trait :commenter do
      after(:create) do |obj|
        obj.roles << create(:role, :commenter, user: create(:user, org: create(:org)))
      end
    end
    trait :organisationally_visible do
      visibility { "organisationally_visible" }
    end

    trait :publicly_visible do
      visibility { "publicly_visible" }
    end

    trait :is_test do
      visibility { "is_test" }
    end

    trait :privately_visible do
      visibility { "privately_visible" }
    end

    after(:create) do |plan, evaluator|
      create_list(:answer, evaluator.answers, plan: plan)
    end

    after(:create) do |plan, evaluator|
      plan.guidance_groups << create_list(:guidance_group, evaluator.guidance_groups)
    end

  end
end
