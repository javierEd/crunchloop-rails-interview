require 'swagger_helper'

describe 'Todo lists' do
  path '/api/todolists' do
    get 'Retrieves todo lists' do
      tags 'Todo lists'
      produces 'application/json'

      response 200, 'Ok' do
        schema type: :array,
               items: { type: :object,
                        properties: { id: { type: :integer }, name: { type: :string } } }
        run_test!
      end
    end
  end
end
