require 'kaminari'
module ControllerMixins
  module WorkUnits

    def search
      index
      render :index
    end

    def index
      @q = WorkUnit.search(params[:q])
      @work_units = @q.result(distinct: true)

      case params[:filter]
      when 'Invoiced'
        @work_units = @work_units.is_invoiced.reverse_order.page(params[:page])
      when 'Paid'
        @work_units = @work_units.is_paid.reverse_order.page(params[:page])
      else
        @work_units = @work_units.reverse_order.page(params[:page])
      end
    end
  end
end
