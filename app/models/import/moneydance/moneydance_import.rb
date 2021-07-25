# frozen_string_literal: true

class Import::Moneydance::MoneydanceImport
  attr_reader :json
  attr_reader :book

  def import(json_content:, book_owner_email:, default_currency:, auto_delete_book: false)
    @json = JSON.parse(json_content)
    set_book book_owner_email: book_owner_email, default_currency: default_currency, auto_delete_book: auto_delete_book
  end

  private

  def metadata
    @metadata ||= json["metadata"]
  end

  def set_book(book_owner_email:, default_currency:, auto_delete_book:)
    raise StandardError, "Book is already initialized" if book.present?

    file_name = metadata["file_name"]
    export_date = metadata["export_date"].to_s
    book_name = "#{file_name} (#{export_date[0..3]}-#{export_date[4..5]}-#{export_date[6..7]})"

    book_candidate = Book.find_by(name: book_name)
    if book_candidate.present?
      if auto_delete_book
        # Use SQL deletion and trust the FKs to delete everything.
        Book.where(name: book_name).delete_all
      else
        raise StandardError, "A book with name \"#{book_name}\" already exist. Can only import from scratch (book must not already exist)." if book_candidate.present?
      end
    end

    book_owner = User.find_by email: book_owner_email
    @book = Book.create! name: book_name, owner: book_owner, default_currency_iso_code: default_currency
  end
end
