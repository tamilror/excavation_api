class ApiController < ApplicationController
  def create
    file = File.read('sample.json')
    data = JSON.parse(file)
  
    ticket_attributes = ticket_params(data['Ticket']).merge(ticket_params(data['DateTimes'])).merge(ticket_params(data["ExcavationInfo"]["DigsiteInfo"]["WellKnownText"]))
    ticket_attributes[:primary_service_area_code] = data.dig('ServiceArea', 'primary_service_area_code', 'SACode')
    ticket_attributes[:additional_service_area_codes] = data.dig('ServiceArea', 'additional_service_area_codes', 'SACode') || []

    ticket = Ticket.new(ticket_attributes)
    excavator = Excavator.new(excavator_params(data['Excavator']))
    
    if ticket.save
      excavator.ticket_id = ticket.id
      excavator.save
      render json: { message: 'Data saved successfully' }
    else
      render json: { error: 'Data not saved', errors: ticket.errors.full_messages }, status: :unprocessable_entity
    end
  end

  private
  def ticket_params(ticket_data)
    return {} unless ticket_data
  
    ticket_data.slice(
      'request_number', 'sequence_number', 'request_type', 'request_action',
      'response_due_datetime', 'primary_service_area_code','additional_service_area_codes', 'well_known_text'
    )&.transform_keys { |key| key.underscore.to_sym } || {}
  end
  
  def excavator_params(excavator_data)
    excavator_data.slice('company_name', 'address', 'crew_on_site')&.transform_keys { |key| key.underscore.to_sym } || {}
  end
end
