require 'rails_helper'

describe Api::TodoItemsController do
  render_views

  let(:todo_list) { TodoList.create(name: 'My list') }
  let(:todo_item) { todo_list.todo_items.create(description: 'My item') }

  describe 'GET index' do
    it 'return status ok' do
      get :index, format: :json, params: { todo_list_id: todo_item.todo_list_id }

      expect(response).to have_http_status :ok
    end

    it 'return one todo item' do
      get :index, format: :json, params: { todo_list_id: todo_item.todo_list_id }

      todo_items = JSON.parse(response.body)

      expect(todo_items.count).to eq(1)
      expect(todo_items[0].keys).to match_array(%w[id description completed completed_at])
      expect(todo_items[0]['id']).to eq(todo_item.id)
      expect(todo_items[0]['description']).to eq(todo_item.description)
      expect(todo_items[0]['completed']).to eq(todo_item.completed)
    end

    it 'return an empty list' do
      get :index, format: :json, params: { todo_list_id: todo_list.id }

      todo_items = JSON.parse(response.body)

      expect(todo_items.count).to eq(0)
    end

    it 'return status not found' do
      get :index, format: :json, params: { todo_list_id: -1 }

      expect(response).to have_http_status :not_found
    end
  end

  describe 'POST create' do
    let(:params) { { todo_list_id: todo_list.id, description: 'My item', completed: false } }

    it 'return status created' do
      post :create, format: :json, params: params

      expect(response).to have_http_status :created
    end

    it 'return todo item' do
      post :create, format: :json, params: params

      todo_item = JSON.parse(response.body)

      expect(todo_item['description']).to eq(params[:description])
      expect(todo_item['completed']).to eq(params[:completed])
      expect(todo_item['completed_at']).to eq(nil)
    end

    it 'return status 422' do
      post :create, format: :json, params: { todo_list_id: todo_list.id, description: '', completed: false }

      expect(response).to have_http_status :unprocessable_entity
    end
  end

  describe 'PATCH update' do
    let(:params) do
      { id: todo_item.id, todo_list_id: todo_item.todo_list_id, description: 'My updated item', completed: true }
    end

    it 'return status ok' do
      patch :update, format: :json, params: params

      expect(response).to have_http_status :ok
    end

    it 'return updated item' do
      patch :update, format: :json, params: params

      updated_todo_item = JSON.parse(response.body)

      expect(updated_todo_item['description']).to eq(params[:description])
      expect(updated_todo_item['completed']).to eq(params[:completed])
    end

    it 'return status not found' do
      patch :update, format: :json, params: { todo_list_id: todo_list.id, id: -1 }

      expect(response).to have_http_status :not_found
    end
  end

  describe 'PATCH complete' do
    let(:params) { { id: todo_item.id, todo_list_id: todo_item.todo_list_id } }

    it 'return status ok' do
      patch :complete, format: :json, params: params

      expect(response).to have_http_status :ok
    end

    it 'return updated item' do
      patch :complete, format: :json, params: params

      completed_todo_item = JSON.parse(response.body)

      expect(completed_todo_item['completed']).to eq(true)
    end

    it 'return status not found' do
      patch :complete, format: :json, params: { todo_list_id: todo_list.id, id: -1 }

      expect(response).to have_http_status :not_found
    end
  end

  describe 'DELETE destroy' do
    let(:params) { { id: todo_item.id, todo_list_id: todo_item.todo_list_id } }

    it 'return status no content' do
      delete :destroy, format: :json, params: params

      expect(response).to have_http_status :no_content
    end

    it 'return status not found' do
      delete :destroy, format: :json, params: { todo_list_id: todo_list.id, id: -1 }

      expect(response).to have_http_status :not_found
    end
  end
end
