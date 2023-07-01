require "rails/generators"
require File.expand_path("utils", __dir__)

module SequencedMailer
  class InstallGenerator < Rails::Generators::Base
    source_root File.expand_path("templates", __dir__)
    include Rails::Generators::Migration

    desc "This generator creates the migrations for sequenced_mailer"
    def create_sequenced_mailer_migrations_file
      migration_template "migration.rb", "db/migrate/create_sequenced_mailer_tables.rb"
    end

    def self.next_migration_number(dirname)
      if ActiveRecord::Base.timestamped_migrations
        migration_number = Time.now.utc.strftime("%Y%m%d%H%M%S").to_i
        migration_number += 1
        migration_number.to_s
      else
        format("%.3d", (current_migration_number(dirname) + 1))
      end
    end
  end
end
