json.array!(@challenges) do |challenge|
  json.extract! challenge, :id, :name, :desc, :chapter_id
end
