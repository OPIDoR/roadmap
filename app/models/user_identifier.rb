# == Schema Information
#
# Table name: user_identifiers
#
#  id                   :integer          not null, primary key
#  identifier           :string(510)
#  created_at           :datetime
#  updated_at           :datetime
#  identifier_scheme_id :integer
#  user_id              :integer
#
# Indexes
#
#  user_identifiers_identifier_scheme_id_idx  (identifier_scheme_id)
#  user_identifiers_user_id_idx               (user_id)
#
# Foreign Keys
#
#  fk_rails_...  (identifier_scheme_id => identifier_schemes.id)
#  fk_rails_...  (user_id => users.id)
#

class UserIdentifier < ActiveRecord::Base
  include ValidationMessages

  # ================
  # = Associations =
  # ================

  belongs_to :user
  belongs_to :identifier_scheme

  # ===============
  # = Validations =
  # ===============

  validates :user, presence: true

  validates :identifier_scheme, presence: { message: PRESENCE_MESSAGE }

  validates :identifier, presence: { message: PRESENCE_MESSAGE }

end
