# frozen_string_literal: true

module Decidim
  module Ine
    # This is the engine that runs on the public interface of `Ine`.
    class AdminEngine < ::Rails::Engine
      isolate_namespace Decidim::Ine::Admin

      paths["db/migrate"] = nil
      paths["lib/tasks"] = nil

      routes do
        # Add admin engine routes here
        # resources :ine do
        #   collection do
        #     resources :exports, only: [:create]
        #   end
        # end
        # root to: "ine#index"
      end

      def load_seed
        nil
      end
    end
  end
end
