json.array!(@challenges) do |challenge|
  json.extract! challenge, :id, :name, :desc, :chapter_id
  json.url challenge_url(challenge, format: :json)
end
