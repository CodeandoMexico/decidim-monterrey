Decidim::Forms::Question.class_eval do
  # Resetting QUESTION_TYPES constant so I can add "curp" element
  remove_const(:QUESTION_TYPES)
  QUESTION_TYPES = %w[short_answer long_answer single_option multiple_option sorting files matrix_single matrix_multiple curp].freeze
  const_set(:QUESTION_TYPES, QUESTION_TYPES)

  # Re-declaring SEPARATOR_TYPE and DESCRIPTION_TYPE so it grabs them
  SEPARATOR_TYPE = "separator"
  TITLE_AND_DESCRIPTION_TYPE = "title_and_description"

  # Resetting TYPES constant so I can re-assign validations
  remove_const(:TYPES)
  TYPES = (QUESTION_TYPES + [SEPARATOR_TYPE, TITLE_AND_DESCRIPTION_TYPE]).freeze
  const_set(:TYPES, TYPES)

  # Because the validation array was created at the first load time, it contained the old QUESTION_TYPES; We need to reset the array
  # Clearing old validation array for :question_type so I can reset it
  # Solution according to https://stackoverflow.com/a/26964557
  _validators[:question_type].find { |v| v.is_a? ActiveModel::Validations::InclusionValidator }
    .attributes
    .delete(:question_type)

  validates :question_type, inclusion: {in: TYPES}
end
