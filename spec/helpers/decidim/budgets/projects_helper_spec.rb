require "rails_helper"

describe Decidim::Budgets::ProjectsHelper do
  describe "#budget_to_currency" do
    it "returns currency with es-MX locale" do
      expect(helper.budget_to_currency(50)).to eq "$50.00"
    end
  end
end
