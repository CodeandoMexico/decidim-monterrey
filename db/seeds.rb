# frozen_string_literal: true

require "csv"

require "./db/seeds/organization"
require "./db/seeds/scopes"
require "./db/seeds/neighborhoods"

organization = Seeds::Organization.call
Seeds::Scopes.call(organization)
Seeds::Neighborhoods.call
