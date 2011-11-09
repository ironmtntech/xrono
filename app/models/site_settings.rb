class SiteSettings < ActiveRecord::Base
  has_attached_file :site_logo, :default_url => '/assets/logo_122x40.png'
  belongs_to :client
end
