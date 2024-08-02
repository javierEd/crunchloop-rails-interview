module Api
  class TodoItemsController < ApiController
    # GET /api/todolists/:todo_list_id/todo_items
    def index
      @todo_items = current_todo_list.todo_items

      respond_to :json
    end

    def create
      @todo_item = current_todo_list.todo_items.new(todo_item_params)

      if @todo_item.save
        render 'show', status: :created
      else
        render json: { message: 'Failed to create item' }, status: :unprocessable_entity
      end
    end

    def update
      @todo_item = current_todo_list.todo_items.find(params[:id])

      if @todo_item.update(todo_item_params)
        render 'show', status: :ok
      else
        render json: { message: 'Failed to update item' }, status: :unprocessable_entity
      end
    end

    def complete
      @todo_item = current_todo_list.todo_items.find(params[:id])

      if @todo_item.update(completed: true)
        render 'show', status: :ok
      else
        render json: { message: 'Failed to complete item' }, status: :unprocessable_entity
      end
    end

    def destroy
      @todo_item = current_todo_list.todo_items.find(params[:id])

      if @todo_item.destroy
        head :no_content
      else
        render json: { message: 'Failed to remove item' }, status: :unprocessable_entity
      end
    end

    private

    def todo_item_params
      params.permit(:description, :completed)
    end

    def current_todo_list
      TodoList.find(params[:todo_list_id])
    end
  end
end
