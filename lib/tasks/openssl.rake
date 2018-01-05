namespace :openssl do
  desc "Generate Base64 encoded bytes for application.yml"
  task generate: :environment do
    {
      ENCRYPT_SECRET_KEY: 32,
      ENCRYPT_IV: 12,
      ENCRYPT_SALT: 128
    }.each do |k, length|
      value = Base64.encode64(SecureRandom.random_bytes(length)).delete("\n")
      puts "#{k}: '#{value}'"
    end
  end
end
