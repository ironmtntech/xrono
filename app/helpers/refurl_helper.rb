module RefurlHelper
  def redirect_to_ref_url
    if params[:refurl]
      redirect_to params[:refurl]
    else
      redirect_to root_path
    end
  end
end
