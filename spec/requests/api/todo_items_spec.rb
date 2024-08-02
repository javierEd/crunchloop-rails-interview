require 'swagger_helper'

describe 'Todo list items' do
  let(:todo_list) { TodoList.create(name: 'My list') }
  let(:todo_item) { todo_list.todo_items.create(description: 'My item') }

  path '/api/todolists/{todo_list_id}/todos' do
    get 'Retrieve todo list items' do
      tags 'Todo list items'
      produces 'application/json'
      parameter name: :todo_list_id, in: :path, type: :integer

      response 200, 'Todo list found' do
        let(:todo_list_id) { todo_list.id }

        schema type: :array, items: { '$ref' => '#/components/schemas/todo_item' }

        run_test!
      end

      response 404, 'Todo list not found' do
        let(:todo_list_id) { -1 }

        schema type: :object, properties: { message: { type: :string } }
        run_test!
      end
    end

    post 'Create a todo list item' do
      tags 'Todo list items'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :todo_list_id, in: :path, type: :integer
      parameter name: :todo_item_params, in: :body, schema: { '$ref' => '#/components/schemas/todo_item_params' }

      let(:todo_list_id) { todo_list.id }
      let(:todo_item_params) { { description: 'My list item' } }

      response 201, 'Created' do
        schema '$ref' => '#/components/schemas/todo_item'

        run_test!
      end

      response 422, 'Failed to create todo list item' do
        let(:todo_item_params) { { description: '' } }

        schema '$ref' => '#/components/schemas/error_message'

        run_test!
      end

      response 404, 'Todo list not found' do
        let(:todo_list_id) { -1 }

        schema '$ref' => '#/components/schemas/error_message'

        run_test!
      end
    end
  end

  path '/api/todolists/{todo_list_id}/todos/{id}' do
    patch 'Update a todo list item' do
      tags 'Todo list items'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :todo_list_id, in: :path, type: :integer
      parameter name: :id, in: :path, type: :integer
      parameter name: :todo_item_params, in: :body, schema: { '$ref' => '#/components/schemas/todo_item_params' }

      let(:todo_list_id) { todo_item.todo_list_id }
      let(:id) { todo_item.id }
      let(:todo_item_params) { { description: 'My updated item' } }

      response 200, 'Updated' do
        schema '$ref' => '#/components/schemas/todo_item'

        run_test!
      end

      response 422, 'Failed to update todo list item' do
        let(:todo_item_params) { { description: '' } }

        schema '$ref' => '#/components/schemas/error_message'

        run_test!
      end

      response 404, 'Todo list item not found' do
        let(:id) { -1 }

        schema '$ref' => '#/components/schemas/error_message'

        run_test!
      end
    end

    delete 'Delete a todo list item' do
      tags 'Todo list items'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :todo_list_id, in: :path, type: :integer
      parameter name: :id, in: :path, type: :integer

      let(:todo_list_id) { todo_item.todo_list_id }
      let(:id) { todo_item.id }

      response 204, 'Deleted' do
        run_test!
      end

      response 404, 'Todo list item not found' do
        let(:id) { -1 }

        schema '$ref' => '#/components/schemas/error_message'

        run_test!
      end
    end
  end

  path '/api/todolists/{todo_list_id}/todos/{id}/complete' do
    patch 'Mark a todo list item as completed' do
      tags 'Todo list items'
      consumes 'application/json'
      produces 'application/json'
      parameter name: :todo_list_id, in: :path, type: :integer
      parameter name: :id, in: :path, type: :integer

      let(:todo_list_id) { todo_item.todo_list_id }
      let(:id) { todo_item.id }

      response 200, 'Updated' do
        schema '$ref' => '#/components/schemas/todo_item'

        run_test!
      end

      response 404, 'Todo list item not found' do
        let(:id) { -1 }

        schema '$ref' => '#/components/schemas/error_message'

        run_test!
      end
    end
  end
end
