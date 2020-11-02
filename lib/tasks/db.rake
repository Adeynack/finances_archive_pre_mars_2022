# frozen_string_literal: true

namespace :db do
  desc "Perform a full reset of the database, loads seeds & fixtures, and re-annotate the models"
  task full_reset: [:environment] do
    [
      ["Drop Database", :rake, "db:drop"],
      ["Delete schema cache (schema.rb & structure.sql", :sh, "rm -v -f db/schema.rb db/structure.sql"],
      ["Create Database", :rake, "db:create"],
      ["Migrate Database", :rake, "db:migrate"],
      ["Test Database Setup", :sh, "RAILS_ENV=test rake db:setup"],
      ["Annotate Models", :sh, "annotate --models"],
      ["Seed Database", :rake, "db:seed"],
      ["Load Fixtures into Database", :rake, "db:fixtures:load"]
    ].each do |title, type, command|
      puts title.blue
      case type
      when :rake
        Rake::Task[command].invoke
      when :sh
        sh command
      end
    end
  end
end
