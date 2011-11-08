class SiteSettings < ActiveRecord::Base

  has_attached_file :site_logo, :default_url => '/images/logo.png'
  belongs_to :client
end
