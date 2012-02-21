module ControllerMixins
  module WorkUnits
    def index
      if params[:invoiced] != nil
        @work_units = WorkUnit.find_all_by_invoiced(params[:invoiced])
        @search = "Invoiced: " + params[:invoiced]
      else
        @work_units = WorkUnit.find_all_by_paid(params[:paid])
        @search = "Paid: " + params[:paid]
      end
    end
  end
end
