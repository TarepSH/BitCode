json.array!(@chapters) do |chapter|
  json.extract! chapter, :id, :title, :desc, :video, :course_id
  json.url chapter_url(chapter, format: :json)
end
