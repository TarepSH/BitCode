json.array!(@challenges) do |challenge|
  json.extract! challenge, :id, :name, :desc, :chapter_id
  json.hints_number challenge.hints.count
  json.tabs challenge.challenge_tabs do |tab|
    json.name tab.name
    json.language_name tab.language_name
    json.starter_code tab.starter_code
  end
  json.hints challenge.hints do |hint|
    json.id hint.id
  end
  json.styles challenge.style_needed
end
