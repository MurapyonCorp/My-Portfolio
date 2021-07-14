json.array!(@tasks) do |task|
  json.extract! task, :id, :title, :body
  json.start task.start_date
  json.end task.end_date
  json.url task_url(task, format: :html)
end
