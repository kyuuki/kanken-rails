class AddIndexActionToLogActions < ActiveRecord::Migration[7.0]
  def change
    add_index :log_actions, :action
  end
end
