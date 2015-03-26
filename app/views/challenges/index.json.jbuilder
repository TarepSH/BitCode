json.array!(@challenges) do |challenge|
  json.extract! challenge, :id, :name, :desc, :chapter_id
  json.tabs challenge.challenge_tabs do |tab|
    json.name tab.name
    json.language_name tab.language_name
    json.starter_code tab.starter_code
  end
end
