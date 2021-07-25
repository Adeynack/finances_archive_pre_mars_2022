# frozen_string_literal: true

class Import::Moneydance::MoneydanceImport
  attr_reader :logger
  attr_reader :md_json
  attr_reader :book
  attr_reader :md_items_by_type

  def import(logger:, json_content:, book_owner_email:, default_currency:, auto_delete_book: false)
    @logger = logger
    @md_json = JSON.parse(json_content)
    set_book book_owner_email: book_owner_email, default_currency: default_currency, auto_delete_book: auto_delete_book
    set_md_items_by_type
    import_accounts
  end

  private

  def set_book(book_owner_email:, default_currency:, auto_delete_book:)
    raise StandardError, "Book is already initialized" if book.present?

    file_name = md_json["metadata"]["file_name"]
    export_date = md_json["metadata"]["export_date"].to_s
    book_name = "#{file_name} (#{export_date[0..3]}-#{export_date[4..5]}-#{export_date[6..7]})"

    book_candidate = Book.find_by(name: book_name)
    if book_candidate.present?
      logger.info "Book with name \"#{book_name}\" found"
      if auto_delete_book
        logger.info "Deleting book \"#{book_name}\""
        # Use SQL deletion and trust the FKs to delete everything.
        Book.where(name: book_name).delete_all
      elsif book_candidate.present?
        raise StandardError, "A book with name \"#{book_name}\" already exist. Can only import from scratch (book must not already exist)."
      end
    end

    logger.info "Create book with name \"#{book_name}\" owned by user with email \"#{book_owner_email}\""
    book_owner = User.find_by email: book_owner_email
    @book = Book.create! name: book_name, owner: book_owner, default_currency_iso_code: default_currency
  end

  def set_md_items_by_type
    @md_items_by_type = md_json["all_items"].group_by { |i| i["obj_type"] }
  end

  def import_accounts
    logger.info "Importing registers (MD accounts)"

    accounts_by_id = md_items_by_type["acct"].index_by { |a| a["id"] }

    accounts_by_parent_id = accounts_by_id.values.group_by { |a| a["parentid"] || :root }
    root_accounts = accounts_by_parent_id[:root]
    raise StandardError, "More than one root account found." if root_accounts.length > 1

    root_account = root_accounts.first
    raise StandardError, "No root account found." if root_account.blank?

    accounts_by_parent_id[root_account["id"]].each do |account|
      import_account_recursively parent_account: nil,
                                 md_account: account,
                                 md_accounts_by_parent_id: accounts_by_parent_id
    end
  end

  def import_account_recursively(parent_account:, md_account:, md_accounts_by_parent_id:)
    logger.info "Importing MD account \"#{md_account['name']}\" (ID \"#{md_account["id"]}\")"

    register_class, account_info =
      case md_account["type"]
      when "a" then [Registers::Asset, {}]
      when "b" then [Registers::Bank, extract_bank_account_info(md_account)]
      when "c" then [Registers::Card, extract_card_account_info(md_account)]
      when "e" then [Registers::Expense, {}]
      when "i" then [Registers::Income, {}]
      when "l" then [Registers::Liability, {}]
      when "o" then [Registers::Loan, {}]
      when "v" then [Registers::Investment, extract_investment_info(md_account)]
      else raise StandardError, "Unknown account type code \"#{md_account['type']}\"."
      end

    puts "#{register_class.name} (#{account_info.keys.join(", ")})"
  end

  def extract_bank_account_info(md_account)
    bank_account_number = md_account["bank_account_number"].presence
    {
      account_number: bank_account_number,
      iban: IBANTools::IBAN.valid?(bank_account_number) ? bank_account_number : nil
    }
  end

  def extract_card_account_info(md_account)
    {
      account_number: nil, # "bank_account_number" stores the card number in MD
      bank_name: md_account["bank_name"].presence,
      iban: nil, # "bank_account_number" stores the card number in MD
      interest_rate: md_account["apr"].presence&.to_f,
      credit_limit: md_account["credit_limit"].presence&.to_f&.then { |l| (l * 10).to_i },
      card_number: md_account["bank_account_number"].presence,
      expires_at: expiry_date(md_account["exp_year"], md_account["exp_month"])
    }
  end

  def extract_investment_info(md_account)
    {
      account_number: md_account["invst_account_number"]
    }
  end

  def expiry_date(exp_year, exp_month)
    return nil if exp_year.blank?

    year = exp_year.to_i
    month = exp_month.presence&.to_i || 1
    Date.new(year, month, 1)
  end
end
