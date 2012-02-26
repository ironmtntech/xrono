class DataVault < ActiveRecord::Base
  has_paper_trail
  attr_encrypted :data, :key => "SECRET!", :attribute => :encrypted_data

  belongs_to :data_vaultable, :polymorphic => true
end
