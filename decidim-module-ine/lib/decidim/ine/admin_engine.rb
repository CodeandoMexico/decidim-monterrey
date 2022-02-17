# frozen_string_literal: true

module Decidim
  module Ine
    # This is the engine that runs on the public interface of `Ine`.
    class AdminEngine < ::Rails::Engine
      isolate_namespace Decidim::Ine::Admin

      paths["db/migrate"] = nil
      paths["lib/tasks"] = nil

      routes do
        resources :pending_authorizations, only: :index do
          resource :confirmations, only: [:new, :create], as: :confirmation
          resource :rejections, only: :create, as: :rejection
        end
        root to: "pending_authorizations#index"
      end

      def load_seed
        nil
      end
    end
  end
end
