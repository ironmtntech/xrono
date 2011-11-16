class SiteSettings < ActiveRecord::Base
  has_attached_file :site_logo, :default_url => '/assets/logo_97x40.png'
  belongs_to :client
end
