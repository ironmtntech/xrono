class Admin::InvoicesController < ApplicationController
  before_filter :load_unpaid_work_units, :only => [:index]
  before_filter :load_client, :only => [:show]
  before_filter :load_unpaid_work_units_for_client, :only => [:show]

  def index
    @clients = Client.for(@work_units)
  end

  def show
    @tickets = @work_units.collect{ |wu| wu.ticket }.uniq
  end

  def update
    params[:work_units].each do |key, value|
      if key =~ /\d+/
        work_unit = WorkUnit.find(key.to_i)
        if work_unit && !value["invoiced"].blank? && !value["invoiced_at"].blank?
          value.each do |k, v|
            work_unit.update_attributes(k.to_sym => v)
          end
        end
      end
    end

    redirect_to admin_invoices_path
  end

  private

  def load_unpaid_work_units
    @work_units = WorkUnit.not_invoiced
  end

  def load_unpaid_work_units_for_client
    @work_units = WorkUnit.for_client(@client).not_invoiced
  end

  def load_client
    @client = Client.find(params[:id])
  end
end
