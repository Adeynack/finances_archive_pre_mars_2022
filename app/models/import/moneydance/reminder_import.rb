# frozen_string_literal: true

module Import::Moneydance::ReminderImport
  private

  def import_reminders
    logger.info "Importing reminders"
    md_items_by_type["reminder"].each do |md_reminder|
      logger.info "Importing reminder '#{md_reminder['desc']}' (#{md_reminder['id']})"
      import_reminder(md_reminder)
    end
  end

  # rubocop:disable Metrics/AbcSize
  def import_reminder(md_reminder)
    transaction = extract_transaction_hash_from_reminder(md_reminder)
    reminder = book.reminders.create!(
      created_at: from_md_unix_date(md_reminder["txn.dtentered"], DateTime.current),
      title: md_reminder["desc"].presence,
      first_date: from_md_int_date(md_reminder["sdt"].presence),
      last_date: from_md_int_date(md_reminder["ldt"].presence),
      recurrence: extract_reminder_recurence(md_reminder),
      last_commit_at: from_md_unix_date(md_reminder["ts"]),
      exchange_register_id: register_id_by_md_acctid[transaction["acctid"]],
      exchange_description: transaction["desc"].presence,
      exchange_memo: transaction["memo"].presence,
      exchange_status: from_md_stat(transaction["stat"])
    )
    reminder.import_origins.create! external_system: "moneydance", external_id: md_reminder["id"]
    import_reminder_splits(transaction["splits"], reminder)
  end
  # rubocop:enable Metrics/AbcSize

  def extract_transaction_hash_from_reminder(md_reminder)
    transaction_hash = {
      "splits" => {}
    }
    md_reminder.each_key do |key|
      key_parts = key.split(".")
      next unless key_parts.length > 1 && key_parts.first == "txn"

      if key_parts.length == 2
        transaction_hash[key_parts[1]] = md_reminder.delete(key)
      else
        index = key_parts[1].to_i
        split = transaction_hash["splits"][index] ||= {}
        attribute = key_parts[2..].join(".")
        split[attribute] = md_reminder.delete(key)
      end
    end
    transaction_hash
  end

  def extract_reminder_recurence(md_reminder)
    # TODO !
    ""
  end

  def import_reminder_splits(md_splits, reminder)
    md_splits.keys.sort.each do |md_split_index|
      md_split = md_splits[md_split_index]
      import_reminder_split(md_split, reminder)
    rescue StandardError
      logger.error "Error importing reminder split #{md_split['id']}"
      raise
    end
  end

  def import_reminder_split(md_split, reminder)
    split = reminder.reminder_splits.create!(
      created_at: reminder.created_at,
      register_id: register_id_by_md_acctid[md_split["acctid"]],
      amount: md_split["samt"].to_i,
      counterpart_amount: md_split["pamt"].to_i,
      memo: md_split["desc"].presence,
      status: from_md_stat(md_split["stat"])
    )
    split.import_origins.create! external_system: "moneydance", external_id: md_split["id"]
  end
end
