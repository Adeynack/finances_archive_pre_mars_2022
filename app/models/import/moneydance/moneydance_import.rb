# frozen_string_literal: true

# rubocop:disable Metrics/ClassLength
# rubocop:disable Metrics/AbcSize
# rubocop:disable Metrics/PerceivedComplexity
class Import::Moneydance::MoneydanceImport
  attr_reader :logger
  attr_reader :md_json
  attr_reader :book
  attr_reader :register_by_md_old_id

  def import(logger:, json_content:, book_owner_email:, default_currency:, auto_delete_book: false)
    @logger = logger

    @register_by_md_old_id = {}
    @md_json = JSON.parse(json_content)

    set_book book_owner_email: book_owner_email, default_currency: default_currency, auto_delete_book: auto_delete_book
    import_accounts
  end

  private

  def from_md_unix_date(md_date)
    return nil if md_date.blank?

    DateTime.strptime(md_date, "%Q")
  end

  def from_md_int_date(md_date)
    return nil if md_date.blank?

    md_date = md_date.to_s
    raise ArgumentError, "expecting a 8 digits number" unless md_date.length == 8

    DateTime.parse(md_date)
  end

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
        book_candidate.destroy!
      elsif book_candidate.present?
        raise StandardError, "A book with name \"#{book_name}\" already exist. Can only import from scratch (book must not already exist)."
      end
    end

    logger.info "Create book with name \"#{book_name}\" owned by user with email \"#{book_owner_email}\""
    book_owner = User.find_by email: book_owner_email
    @book = Book.create! name: book_name, owner: book_owner, default_currency_iso_code: default_currency
  end

  def md_items_by_type
    @md_items_by_type ||= md_json["all_items"].group_by { |i| i["obj_type"] }
  end

  def md_currencies_by_old_id
    @md_currencies_by_old_id ||= md_items_by_type["curr"].index_by { |c| c["old_id"] }
  end

  def md_currencies_by_id
    @md_currencies_by_id ||= md_items_by_type["curr"].index_by { |c| c["id"] }
  end

  def md_accounts_by_old_id
    @md_accounts_by_old_id ||= md_items_by_type["acct"].index_by { |a| a["old_id"] }
  end

  def import_accounts
    logger.info "Importing registers (MD accounts)"

    accounts_by_id = md_items_by_type["acct"].index_by { |a| a["id"] }

    accounts_by_parent_id = accounts_by_id.values.group_by { |a| a["parentid"] || :root }
    root_accounts = accounts_by_parent_id[:root]
    raise StandardError, "More than one root account found." if root_accounts.length > 1

    root_account = root_accounts.first
    raise StandardError, "No root account found." if root_account.blank?

    first_level_accounts_per_type = accounts_by_parent_id[root_account["id"]].group_by { |a| a["type"] }

    [
      first_level_accounts_per_type.delete("i"),
      first_level_accounts_per_type.delete("e"),
      first_level_accounts_per_type.values.flatten,
    ].each do |accounts_to_import|
      types = accounts_to_import.map { |a| a["type"] }.uniq!.sort!
      logger.info "Importer MD accounts of type#{types.many? ? 's' : ''} #{types.join(', ')}"

      accounts_to_import.each do |account|
        import_account_recursively parent_account: nil,
                                   md_account: account,
                                   md_accounts_by_parent_id: accounts_by_parent_id
      end
    end
  end

  def register_class_and_info_from_md_account(md_account)
    case md_account["type"]
    when "a" then [Registers::Asset, nil]
    when "b" then [Registers::Bank, extract_bank_account_info(md_account)]
    when "c" then [Registers::Card, extract_card_account_info(md_account)]
    when "e" then [Registers::Expense, nil]
    when "i" then [Registers::Income, nil]
    when "l" then [Registers::Liability, nil]
    when "o" then [Registers::Loan, nil]
    when "v" then [Registers::Investment, extract_investment_info(md_account)]
    else raise StandardError, "Unknown account type code \"#{md_account['type']}\"."
    end
  end

  def import_account_recursively(parent_account:, md_account:, md_accounts_by_parent_id:)
    logger.info "Importing MD '#{md_account['type']}' type account \"#{md_account['name']}\" (ID \"#{md_account['id']}\")"

    register_class, account_info = register_class_and_info_from_md_account(md_account)
    register = register_class.create!(
      created_at: from_md_unix_date(md_account["creation_date"]),
      name: md_account["name"].presence&.strip,
      book: book,
      parent: parent_account,
      starts_at: from_md_int_date(md_account["date_created"]),
      currency_iso_code: md_account["currid"].presence&.then { |curr_id| md_currencies_by_id[curr_id]["currid"] },
      initial_balance: md_account["sbal"]&.then(&:to_i),
      active: md_account["is_inactive"] != "y",
      default_category_id: md_account["default_category"].presence&.then { |c| register_by_md_old_id[c] },
      info: account_info,
      notes: md_account["comment"].presence&.strip
    )
    md_account["old_id"].presence&.tap { |old_id| register_by_md_old_id[old_id] = register }
    register.import_origins.create! external_system: "moneydance", external_id: md_account["id"]

    (md_accounts_by_parent_id[md_account["id"]] || []).each do |child|
      import_account_recursively parent_account: register,
                                 md_account: child,
                                 md_accounts_by_parent_id: md_accounts_by_parent_id
    end
  end

  def extract_bank_account_info(md_account)
    bank_account_number = md_account["bank_account_number"].presence
    Registers::BankInfo.new(
      account_number: bank_account_number,
      iban: IBANTools::IBAN.valid?(bank_account_number) ? bank_account_number : nil
    )
  end

  def extract_card_account_info(md_account)
    Registers::CardInfo.new(
      account_number: nil, # "bank_account_number" stores the card number in MD
      bank_name: md_account["bank_name"].presence,
      iban: nil, # "bank_account_number" stores the card number in MD
      interest_rate: md_account["apr"].presence&.to_f,
      credit_limit: md_account["credit_limit"].presence&.to_f&.then { |l| (l * 10).to_i },
      card_number: md_account["bank_account_number"].presence,
      expires_at: expiry_date(md_account["exp_year"], md_account["exp_month"])
    )
  end

  def extract_investment_info(md_account)
    Registers::InvestmentInfo.new(
      account_number: md_account["invst_account_number"]
    )
  end

  def expiry_date(exp_year, exp_month)
    return nil if exp_year.blank?

    year = exp_year.to_i
    month = exp_month.presence&.to_i || 1
    Date.new(year, month, 1)
  end
end
# rubocop:enable Metrics/ClassLength
# rubocop:enable Metrics/AbcSize
# rubocop:enable Metrics/PerceivedComplexity
