class CreateTickets < ActiveRecord::Migration[7.1]
  def change
    create_table :tickets do |t|
      t.string :request_number
      t.string :sequence_number
      t.string :request_type
      t.string :request_action
      t.datetime :date_time
      t.datetime :response_due_datetime
      t.string :primary_service_area_code
      t.string :additional_service_area_codes
      t.text :well_known_text

      t.timestamps
    end
  end
end
