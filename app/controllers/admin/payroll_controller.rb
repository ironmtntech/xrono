class Admin::PayrollController < ApplicationController

  def index
    @users = User.with_unpaid_work_units
    @work_units = WorkUnit.unpaid
  end

  def show
    @user = User.find(params[:id])
    @work_units = @user.work_units.where('paid = "" OR paid IS NULL')
    redirect_to admin_payroll_index_path, :notice => "All payroll is filled for user " + @user.to_s unless @work_units.size > 0
    @clients = @work_units.collect { |wu| wu.client }.uniq
  end

  def update
    params[:work_unit].each do |key, value|
      if key =~ /\d+/
        unless value.blank?
          work_unit = WorkUnit.find(key.to_i)
          if work_unit
            work_unit.update_attributes(:paid => value)
          end
        end
      end
    end

    redirect_to admin_payroll_path
  end
end
