# frozen_string_literal: true

require "rails_helper"

RSpec.describe Book, type: :graph do
  fixtures :books, :users

  describe "getting books" do
    let(:books_query) do
      <<-GQL.squish
      query {
        books {
          id
          name
          owner {
            id
            email
            displayName
          }
        }
      }
      GQL
    end

    context "N+1", :n_plus_one do
      populate do |n|
        create_list :book, n, owner: create(:user)
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
