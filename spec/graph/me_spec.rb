# frozen_string_literal: true

require "rails_helper"

RSpec.describe "Me", type: :graph do
  fixtures :users, :books, :book_roles

  let(:me_query) do
    <<~GQL
      {
        me {
          id
          email
          displayName
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

  context "querying for current user info, owned books, and accessible books (book_roles)", :n_plus_one do
    populate do |n|
      users = create_list :user, n
      books = Array.new(n) { |i| create :book, owner: users[i % n] }
      n.times { |i| create :book_role, book: books[i % n], user: users[(n + 1) % n] }
    end

    it "does not perform N+1 queries" do
      login :joe
      expect do
        gql me_query
        expect(data.me).not_to be_nil
      end.to perform_constant_number_of_queries
    end

    it "lists the basic user information" do
      joe = users(:joe)
      login joe

      gql me_query

      expect(data.me.id).to eq joe.id
      expect(data.me.email).to eq joe.email
      expect(data.me.displayName).to eq joe.display_name
    end

    it "lists books and their owners" do
      login :joe
      gql me_query

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
    end

    it "lists the permissions the current user has on books" do
      login :joe
      gql me_query

      expect(data.me.bookRoles.map { |r| [r.book.name, r.role, r.effectiveRoles] }).to match_array [
        [books(:joe).name, "OWNER", ["READER", "WRITER", "ADMIN", "OWNER"]],
        [books(:foo).name, "OWNER", ["READER", "WRITER", "ADMIN", "OWNER"]],
        [books(:mary).name, "WRITER", ["READER", "WRITER"]],
      ]
    end
  end
end
