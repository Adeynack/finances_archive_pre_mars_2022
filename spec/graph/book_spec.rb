# frozen_string_literal: true

require "rails_helper"

RSpec.describe Book, type: :graph do
  fixtures :users, :books, :book_roles

  describe "getting books" do
    let(:books_query) do
      <<~GQL
        {
          me {
            books {
              id
              name
              owner {
                email
              }
              roles {
                role
                user {
                  email
                }
              }
            }
            bookRoles {
              role
              effectiveRoles
              book {
                name
                owner {
                  email
                }
              }
              user {
                email
              }
            }
          }
        }
      GQL
    end

    context "Querying for owned books and accessible books (book_roles)", :n_plus_one do
      populate do |n|
        users = create_list :user, n
        books = Array.new(n) { |i| create :book, owner: users[i % n] }
        n.times { |i| create :book_role, book: books[i % n], user: users[(n + 1) % n] }
      end

      it "does not perform N+1 queries" do
        login :joe
        expect do
          gql books_query
          expect(data.me).not_to be_nil
        end.to perform_constant_number_of_queries
      end

      it "lists books and their owners" do
        login :joe
        gql books_query

        expect(data.me.books.map(&:name)).to match_array [books(:joe).name, books(:foo).name]

        book_joe = data.me.books.find { |b| b.id == books(:joe).id }
        expect(book_joe).to have_attributes books(:joe).slice(:id, :name)
        expect(book_joe.owner.email).to eq users(:joe).email
        expect(book_joe.roles.map { |r| [r.role, r.user.email] }).to match_array [
          ["OWNER", users(:joe).email],
          ["WRITER", users(:mary).email],
          ["READER", users(:vlad).email],
        ]

        book_foo = data.me.books.find { |b| b.id == books(:foo).id }
        expect(book_foo).to have_attributes books(:foo).slice(:id, :name)
        expect(book_foo.owner.email).to eq users(:joe).email
        expect(book_foo.roles.map { |r| [r.role, r.user.email] }).to match_array [
          ["OWNER", users(:joe).email],
        ]

        expect(data.me.bookRoles.map { |r| [r.book.name, r.role, r.effectiveRoles] }).to match_array [
          [books(:joe).name, "OWNER", ["READER", "WRITER", "ADMIN", "OWNER"]],
          [books(:foo).name, "OWNER", ["READER", "WRITER", "ADMIN", "OWNER"]],
          [books(:mary).name, "WRITER", ["READER", "WRITER"]],
        ]
      end
    end
  end
end
