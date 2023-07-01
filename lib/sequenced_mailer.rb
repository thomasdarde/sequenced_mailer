# frozen_string_literal: true

require_relative "sequenced_mailer/version"
require "rails"
require "sequenced_mailer/railtie" if defined?(Rails::Railtie)
require_relative "../app/models/mailing"
require_relative "../app/models/mailing/sequence"
require_relative "../app/models/mailing/sequence_owner"
require_relative "../app/models/mailing/sequence_step"
require_relative "../app/concerns/mailing/sequenceable"
module SequencedMailer
  class Error < StandardError; end
  Mailing::Sequence
  Mailing::SequenceOwner
  Mailing::SequenceStep
  Mailing::Sequenceable
end
