# frozen_string_literal: true

require "rails"
require "decidim/core"
# require "decidim/verifications"

module Decidim
  module Ine
    # This is the engine that runs on the public interface of ine.
    class Engine < ::Rails::Engine
      isolate_namespace Decidim::Ine

      routes do
        resource :authorizations, only: [:new, :create, :edit, :update], as: :authorization do
          collection do
            get :choose
          end
        end
        root to: "authorizations#new"
      end

      initializer "Ine.webpacker.assets_path" do
        Decidim.register_assets_path File.expand_path("app/packs", root)
      end
    end
  end
end
