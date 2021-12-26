# README

## Develop

### Initial Setup

```bash
bundle # installs ruby gems
yarn install # installs the JavaScript packages
rails db:create db:migrate # creates the database and loads the schema
rails db:fixtures:load # (optional) creates demo data within the app
```

Look in [`test/fixtures/users.yml`](test/fixtures/users.yml) for a list
of development accounts loaded with the fixtures, to log in the application
in development mode.

### Start a development session

#### Dependencies

Keep this open in a terminal tab.

```bash
docker compose up # starts the dependencies (ex: Redis, PostgreSQL)
```

#### Rails Application

Keep this open in a terminal tab.

```bash
rails serve
```

#### WebPack Development Server

Keep this open in a terminal tab.

```bash
bin/webpack-dev-server
```

### Code Maintenance

#### Annotations

Annotate models after migrations through the *Rake* task.

```bash
bundle exec rake annotate_models
```

#### Annotate Controllers

Annotate controllers with their routes using the *chusaku* command.

```bash
bundle exec chusaku
```

## Import

### Moneydance

```bash
bundle rake data:import:md
```

Options (via ENV):

| ENV                | Default         | Description                                                        |
| ------------------ | --------------- | ------------------------------------------------------------------ |
| `MD_IMPORT_FILE`   | ./tmp/md.json   | Path to the JSON file to import, exported from Moneydance.         |
| `BOOK_OWNER_EMAIL` | joe@example.com | E-Mail of the owner of the book to create.                         |
| `DEFAULT_CURRENCY` | EUR             | Default currency of the book to create.                            |
| `AUTO_DELETE_BOOK` | 0 (false)       | Destroy the book if it already exists (clean import from scratch). |

Here's a useful command during development. It is faster than destroying the existing book. It
simply truncates all of the development database, seeds it with the test fixtures and imports.

```bash
rake db:truncate_all db:seed db:fixtures:load data:import:md
```

## Development Notes

### GEMS & Libs to consider

https://viewcomponent.org/motivation.html
