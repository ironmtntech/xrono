class DataVaultsController < ApplicationController

  def show
    @data_vault = DataVault.find(params[:id])
    render :text => @data_vault.data
  end

  def update
    @data_vault = DataVault.find(params[:id])
    @data_vault.update_attribute(:data, params[:value])
    render :text => ::Kramdown::Document.new(@data_vault.data).to_html
  end
end
