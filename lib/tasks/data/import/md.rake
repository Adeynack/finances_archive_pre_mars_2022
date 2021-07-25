# frozen_string_literal: true

namespace :data do
  namespace :import do
    desc "Import data from MoneyDance (raw JSON format)"
    task md: :environment do
      filename = ENV.fetch("MD_IMPORT_FILE", "./tmp/md.json")
      json_content = File.read filename

      book_owner_email = ENV.fetch("BOOK_OWNER_EMAIL", "joe@example.com")
      default_currency = ENV.fetch("DEFAULT_CURRENCY", "EUR")
      auto_delete_book = ["true", "1"].include? ENV.fetch("AUTO_DELETE_BOOK", "false").downcase

      importer = Import::Moneydance::MoneydanceImport.new
      importer.import json_content: json_content, book_owner_email: book_owner_email, default_currency: default_currency, auto_delete_book: auto_delete_book
    end
  end
end
