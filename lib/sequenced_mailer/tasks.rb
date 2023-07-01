namespace :sequenced_mailer do
  desc "Add database tables for SequencedMailer"
  task setup: :environment do
    system "rails g sequenced_mailer:install"

    Rake::Task["db:migrate"].invoke
  end
end
