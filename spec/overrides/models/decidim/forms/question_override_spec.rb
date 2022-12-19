# frozen_string_literal: true

require "rails_helper"
require "spec_helper"

module Decidim
  module Forms
    describe Question do
      subject { question }

      let(:questionnaire) { create(:questionnaire) }
      let(:question_type) { "short_answer" }
      let(:question) { build(:questionnaire_question, questionnaire: questionnaire, question_type: question_type) }
      let(:display_conditions) { create_list(:display_condition, 2, question: question) }

      describe "when setting curp as question_type" do
        let(:question_type) { "curp" }
        # it "testing" do
        #   debugger
        # end
        it { is_expected.to be_valid }

        context "when the CURP has the correct format" do
          true
        end

        context "when the CURP has the incorrect format" do
          true
        end
      end
    end
  end
end
