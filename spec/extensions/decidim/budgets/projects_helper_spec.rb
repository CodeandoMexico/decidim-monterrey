require "rails_helper"

describe Extensions::Decidim::Budgets::ProjectsHelper do
  subject(:projects_helper) { Decidim::Budgets::ProjectsHelper }

  it "prepends properly into Decidim::Budgets::ProjectsHelper" do
    expect(projects_helper.ancestors.first).to eq Extensions::Decidim::Budgets::ProjectsHelper
  end
end
