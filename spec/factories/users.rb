# frozen_string_literal: true
# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  firstname              :string
#  surname                :string
#  email                  :string(80)       default(""), not null
#  encrypted_password     :string
#  firstname              :string
#  invitation_accepted_at :datetime
#  invitation_created_at  :datetime
#  invitation_sent_at     :datetime
#  invitation_token       :string
#  invited_by_type        :string
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  ldap_password          :string
#  ldap_username          :string
#  other_organisation     :string
#  dmponline3             :boolean
#  accept_terms           :boolean
#  org_id                 :integer
#  api_token              :string
#  invited_by_id          :integer
#  invited_by_type        :string
#  language_id            :integer
#  recovery_email         :string
#  active                 :boolean          default("true")
#  department_id          :integer
#
# Indexes
#
#  fk_rails_45f4f12508    (language_id)
#  fk_rails_f29bf9cdf2    (department_id)
#  index_users_on_email   (email)
#  index_users_on_org_id  (org_id)
#
# Foreign Keys
#
#  fk_rails_...  (department_id => departments.id)
#  fk_rails_...  (language_id => languages.id)
#  fk_rails_...  (org_id => orgs.id)
#

FactoryBot.define do
  factory :user do
    org
    firstname    { Faker::Name.unique.first_name }
    surname      { Faker::Name.unique.last_name }
    email        { Faker::Internet.unique.safe_email }
    password     { "password" }
    accept_terms { true }

    trait :org_admin do
      after(:create) do |user, evaluator|
        %w[modify_templates modify_guidance
           change_org_details
           use_api
           grant_permissions].each do |perm_name|
          user.perms << Perm.find_or_create_by(name: perm_name)
        end
      end
    end

    trait :super_admin do
      after(:create) do |user, evaluator|
        %w[change_org_affiliation add_organisations
           grant_permissions use_api change_org_details grant_api_to_orgs
           modify_templates modify_guidance].each do |perm_name|
          user.perms << Perm.find_or_create_by(name: perm_name)
        end
      end
    end
  end
end
