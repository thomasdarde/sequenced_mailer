module SequencedMailer
  class Railtie < Rails::Railtie
    rake_tasks do
      load "sequenced_mailer/tasks.rb"
    end
  end
end
