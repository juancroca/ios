json.array!(@registrations) do |registration|
  json.extract! registration, :id
  json.url registration_url(registration, format: :json)
end
