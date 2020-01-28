# == Schema Information
#
# Table name: question_options
#
#  id          :integer          not null, primary key
#  question_id :integer
#  text        :string
#  number      :integer
#  is_default  :boolean
#  created_at  :datetime
#  updated_at  :datetime
#
# Indexes
#
#  question_options_question_id_idx  (question_id)
#

class QuestionOption < ActiveRecord::Base
  include ValidationMessages
  include ValidationValues

  # ================
  # = Associations =
  # ================

  belongs_to :question

  has_and_belongs_to_many :answers, join_table: :answers_question_options


  # ===============
  # = Validations =
  # ===============

  validates :text, presence: { message: PRESENCE_MESSAGE }

  validates :question, presence: { message: PRESENCE_MESSAGE }

  validates :number, presence: { message: PRESENCE_MESSAGE }

  validates :is_default, inclusion: { in: BOOLEAN_VALUES,
                                      message: INCLUSION_MESSAGE }

  # ==========
  # = Scopes =
  # ==========

  scope :by_number, -> { order(:number) }


  # ===========================
  # = Public instance methods =
  # ===========================

  # ===========================
  # = Public instance methods =
  # ===========================

  def deep_copy(**options)
    copy = self.dup
    copy.question_id = options.fetch(:question_id, nil)
    return copy
  end
end
