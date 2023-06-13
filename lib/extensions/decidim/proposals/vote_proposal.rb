# frozen_string_literal: true

module Extensions
  module Decidim
    module Proposals
      module VoteProposal
        include Extensions::Decidim::Proposals::CurrentUserScope

        def call
          return broadcast(:invalid) if @proposal.maximum_votes_reached? && !@proposal.can_accumulate_supports_beyond_threshold

          return broadcast(:invalid) unless can_user_vote_in_proposal?

          build_proposal_vote
          return broadcast(:invalid) unless vote.valid?

          ActiveRecord::Base.transaction do
            @proposal.with_lock do
              vote.save!
              update_temporary_votes
            end
          end

          # Decidim::Gamification.increment_score(@current_user, :proposal_votes)

          broadcast(:ok, vote)
        end

        private

        def can_user_vote_in_proposal?
          GeographicScopeMatcher.call(@proposal, @current_user) do
            on(:ok) do
              return true
            end
            on(:nil) do
              return false
            end
          end
          # @proposal.scope == current_user_scope(@proposal)
        end
      end
    end
  end
end

Decidim::Proposals::VoteProposal.prepend Extensions::Decidim::Proposals::VoteProposal
