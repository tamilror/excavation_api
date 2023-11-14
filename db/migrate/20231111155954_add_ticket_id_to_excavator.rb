class AddTicketIdToExcavator < ActiveRecord::Migration[7.1]
  def change
    add_column :excavators, :ticket_id, :integer
  end
end
