# Finances MVP (Most Valuable Product)

## Goal

- [ ] Import, without any loss, the data from _Moneydance_ (actual finances application
      of the creator of this project).
- [ ] Perform day to day tasks actually performed by _Moneydance_ (being able to drop
      in the MVP and stop using _Moneydance_).

## Features required for the MVP

- [ ] Users
  - [ ] Manage through _ActiveAdmin_
  - [ ] Log In through _Devise_
- [ ] Books
  - [ ] CRUD
  - [ ] Delete only if no transaction
  - [ ] Chose current book (book to work in)
- [ ] Accounts
  - [ ] CRUD
  - [ ] Types:
    - [ ] Bank
    - [ ] Credit Card
    - [ ] Investment
    - [ ] Asset
    - [ ] Liability
    - [ ] Loan
  - [ ] Tree index of accounts
  - [ ] Delete only if no transaction
  - [ ] Only an account of the same type can be parent
- [ ] Categories
  - [ ] CRUD
  - [ ] Types:
    - [ ] Expense
    - [ ] Income
  - [ ] Tree index of categories
  - [ ] Delete only if no transaction
- [ ] Currencies
  - [ ] Anything supported by the money GEM (no CRUD), no custom currency at first.
- [ ] Transactions and their Splits
  - [ ] List transactions
    - [ ] for an accounts
    - [ ] for a category
  - [ ] Display balance on each line
  - [ ] Create a new transaction
    - [ ] Including a variable list of splits
  - [ ] Edit
  - [ ] Delete
- [ ] Reminders
  - [ ] Data Model only, no CRUD in MVP
- [ ] Import from MoneyDance
  - [ ] Import as new book or into existing book
  - [ ] Import Accounts
  - [ ] Import Categories
  - [ ] Import Transactions and their splits
  - [ ] Import Reminders

## Features that can wait

Those are features currently used in _Moneydance_, but that are not needed for an
immediate drop in replacement for entering data.

- [ ] Reminders
  - [ ] CRUD
  - [ ] ...

## Model Requirements Brainstorm

### Accounts

| Attribute \ Type        | BASE   | META | Bank    | Credit Card | Investment | Asset | Liability | Loan      |
| ----------------------- | ------ | ---- | ------- | ----------- | ---------- | ----- | --------- | --------- |
| Account Name            | req    |      | x       | x           | x          | x     | x         | x         |
| Start Date              | req    |      | x       | x           | x          | x     | x         | x         |
| Currency                | req    |      | x       | x           | x          | x     | x         | x         |
| Default Category        | opt    |      | x       | x           | x          |       |           |           |
| Parent Account          | opt    |      | x       | x           |            | x     | x         | x         |
| Initial...              | `0`    |      | Balance | Debt        | Balance    | Value | Liability | Principal |
| Active                  | `true` |      | x       | x           | x          | x     | x         | x         |
| Comments                | opt    |      | x       | x           | x          | x     | x         | x         |
| Website                 | opt    |      | x       | x           | x          |       |           |           |
| Bank Name               |        | x    | x       | x           | x          |       |           |           |
| Account Number          |        | x    | x       |             | x          |       |           |           |
| Routing Number          |        | x    | x       |             |            |       |           |           |
| Check Numbers           |        | x    | x       | x           | x          | x     | x         |           |
| Card Number             |        | x    |         | x           |            |       |           |           |
| APR                     |        | x    |         | x           |            |       |           | x         |
| ... until               |        | x    |         | x           |            |       |           |           |
| ... then                |        | x    |         | x           |            |       |           |           |
| Credit Limit            |        | x    |         | x           |            |       |           |           |
| Payment Plan (type)     |        | x    |         | x           |            |       |           |           |
| Payment Plan (amount)   |        | x    |         | x           |            |       |           |           |
| Expires at              |        | x    |         | x           |            |       |           |           |
| Loan Points             |        | x    |         |             |            |       |           | x         |
| Payments per Year       |        | x    |         |             |            |       |           | x         |
| Number of Payments      |        | x    |         |             |            |       |           | x         |
| Interest Category       |        | x    |         |             |            |       |           | x         |
| Escrow Payment          |        | x    |         |             |            |       |           | x         |
| Escrow Account          |        | x    |         |             |            |       |           | x         |
| Specify Payment (or...) |        | x    |         |             |            |       |           | x         |
| Calculate Payment       |        | x    |         |             |            |       |           | x         |

### Categories

| Attribute \ Type | BASE    | Expense | Income |
| ---------------- | ------- | ------- | ------ |
| Name             | req     | x       | x      |
| Currency         | req     | x       | x      |
| Parent Category  | opt     | x       | x      |
| Tax Related      | `false` | x       | x      |
| Active           | `true`  | x       | x      |
| Comments         | opt     | x       | x      |

### Reminders

Focussing only on the _Transaction Reminders_, dropping the _General Reminder_ concept
of _Moneydance_.

| Attribute                          | BASE |
| ---------------------------------- | ---- |
| Description                        | req  |
| From                               | req  |
| To                                 | opt  |
| Period (TBD)                       | req  |
| Auto-Commit (days before schedule) | opt  |
| Transaction Template               | req  |

### Transactions / Splits / Tags

#### Transactions

| Attribute   | BASE                                |
| ----------- | ----------------------------------- |
| Account     | req fk                              |
| Date        | req                                 |
| Cheque      | opt                                 |
| Description | req                                 |
| Status      | uncleared<br>reconciling<br>cleared |
| Memo        | opt                                 |
|             |                                     |

#### Splits (Transaction Splits)

| Attribute   | BASE     |
| ----------- | -------- |
| Transaction | req fk   |
| Category    | req fk   |
| Amount      | req      |
| Memo        | opt      |
| Tags        | has_many |
|             |          |

#### Tags (Transaction Split Tags)

| Attribute | BASE     |
| --------- | -------- |
| Name      | req      |
| Splits    | has_many |

## Misc Notes

### Convert from Epoch

In _Moneydance_, the `ts` field on transaction is specified in _Epoch_ (aka _Unix Time_).

```ruby
DateTime.strptime("1614116785891",'%Q')
```
