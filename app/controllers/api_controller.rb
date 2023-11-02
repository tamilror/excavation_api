class ApiController < ApplicationController
  def create
    data = JSON.parse(request.body.read)

    ticket = Ticket.new(data['Ticket'])
    excavator = Excavator.new(data['Excavator'])
    
    if ticket.save
      excavator.ticket_id = ticket.id
      excavator.save
      render json: { message: 'Data saved successfully' }
    else
      render json: { error: 'Data not saved' }, status: :unprocessable_entity
    end
  end
  
  def ticket_params
    params.require(:Ticket).permit(:request_number, :sequence_number, :request_type, :request_action, :response_due_datetime, :primary_service_area_code, :additional_service_area_codes, :well_known_text)
  end
  
  def excavator_params
    params.require(:Excavator).permit(:company_name, :address, :crew_on_site)
  end
  
end
