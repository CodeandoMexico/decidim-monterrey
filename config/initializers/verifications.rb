Decidim::Verifications.register_workflow(:ine) do |workflow|
  workflow.engine = Decidim::Ine::Engine
  workflow.admin_engine = Decidim::Ine::AdminEngine
  workflow.renewable = false
end
