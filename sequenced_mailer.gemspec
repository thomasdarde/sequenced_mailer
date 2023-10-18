# frozen_string_literal: true

require_relative "lib/sequenced_mailer/version"

Gem::Specification.new do |spec|
  spec.name = "sequenced_mailer"
  spec.version = SequencedMailer::VERSION
  spec.authors = ["Thomas Darde"]
  spec.email = ["thomas@rougecardinal.fr"]

  spec.summary = "Send emails in sequence."
  spec.description = "Send emails at a specific time, in sequence"
  spec.homepage = "https://github.com/thomasdarde/sequenced_mailer"
  spec.license = "MIT"
  spec.required_ruby_version = ">= 2.6.0"

  spec.metadata["allowed_push_host"] = "https://rubygems.org"

  spec.metadata["homepage_uri"] = spec.homepage
  spec.metadata["source_code_uri"] = spec.homepage
  spec.metadata["changelog_uri"] = "https://github.com/thomasdarde/sequenced_mailer/blob/main/CHANGELOG.md"

  # Specify which files should be added to the gem when it is released.
  # The `git ls-files -z` loads the files in the RubyGem that have been added into git.
  spec.files = Dir.chdir(__dir__) do
    `git ls-files -z`.split("\x0").reject do |f|
      (File.expand_path(f) == __FILE__) ||
        f.start_with?(*%w[bin/ test/ spec/ features/ .git .circleci appveyor Gemfile])
    end
  end
  spec.bindir = "exe"
  spec.executables = spec.files.grep(%r{\Aexe/}) { |f| File.basename(f) }
  spec.require_paths = ["lib"]

  # Uncomment to register a new dependency of your gem
  spec.add_runtime_dependency "activerecord", "~> 7.0"

  spec.add_development_dependency "rubocop-performance", "~> 1.11"
  spec.add_development_dependency "rubocop-rails", "~> 2.10"
  spec.add_development_dependency "rubocop-rspec", "~> 2.1"
  spec.add_development_dependency "standard", "~> 1.29"

  # For more information and examples about making a new gem, check out our
  # guide at: https://bundler.io/guides/creating_gem.html
end
