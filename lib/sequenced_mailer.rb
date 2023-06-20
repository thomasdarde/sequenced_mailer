# frozen_string_literal: true

require_relative "sequenced_mailer/version"
require "rails"
require_relative "../app/models/mailing"
require_relative "../app/models/mailing/sequence"
module SequencedMailer
  class Error < StandardError; end
  Mailing::Sequence
  Mailing::SequenceOwner
end
