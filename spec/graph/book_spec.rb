# frozen_string_literal: true

require "rails_helper"

RSpec.describe Book, type: :graph do
  fixtures :books, :users

  describe "getting books" do
    let(:books_query) do
      <<~GQL
        {
          books {
            id
            name
            owner {
              id
              email
              displayName
            }
            roles {
              role
              effectiveRoles
              user {
                id
                email
                displayName
              }
            }
          }
        }
      GQL
    end

    context "N+1", :n_plus_one do
      populate do |n|
        users = create_list :user, n
        books = Array.new(n) { |i| create :book, owner: users[i % n] }
        n.times { |i| create :book_role, book: books[i % n], user: users[(n + 1) % n] }
      end
      specify do
        expect { gql books_query }.to perform_constant_number_of_queries
      end
    end

    it "lists books and their owners" do
      gql books_query

      joes_book_id = books(:joe).id
      joes_book = data.books.find { |b| b.id == joes_book_id }
      expect(joes_book).not_to be_nil
      expect(joes_book).to have_attributes name: "Joe's Book"

      joe = users(:joe)
      expect(joes_book.owner).to have_attributes id: joe.id,
                                                 email: "joe@foobar.com",
                                                 displayName: "Joe"
    end
  end
end
