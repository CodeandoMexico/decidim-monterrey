# Decidim::Forms::AnswerQuestionnaire.class_eval do
#   def call
#     return broadcast(:invalid) if @form.invalid? || user_already_answered?
#     answer_questionnaire

#     if @errors
#       reset_form_attachments
#       broadcast(:invalid)
#     else
#       broadcast(:ok)
#     end
#   end
# end
