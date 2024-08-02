class TodoItem < ApplicationRecord
  belongs_to :todo_list

  validates :description, presence: true

  def completed
    completed_at.present?
  end

  def completed=(value)
    value = value.downcase == 'true' unless value.in?([true, false])

    if value && !completed
      self.completed_at = Time.current
    elsif !value && completed
      self.completed_at = nil
    end
  end
end
