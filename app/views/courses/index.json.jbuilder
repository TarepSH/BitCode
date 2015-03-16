json.array!(@courses) do |course|
  json.extract! course, :id, :name, :desc, :logo_file_name, :logo_file_size, :logo_content_type, :logo_updated_at
  json.url course_url(course, format: :json)
end
