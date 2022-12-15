Decidim::Forms::AnswerForm.class_eval do
  validates :body,
    format: {with: /\A([A-Z][AEIOUX][A-Z]{2}\d{2}(?:0[1-9]|1[0-2])(?:0[1-9]|[12]\d|3[01])[HM](?:AS|B[CS]|C[CLMSH]|D[FG]|G[TR]|HG|JC|M[CNS]|N[ETL]|OC|PL|Q[TR]|S[PLR]|T[CSL]|VZ|YN|ZS)[B-DF-HJ-NP-TV-Z]{3}[A-Z\d])(\d)\z/, message: I18n.t("errors.messages.curp")}, if: ->(answer) { answer.is_curp? }

  delegate :is_curp?, to: :question
  def is_curp?
    question.question_type == "curp"
  end
end
