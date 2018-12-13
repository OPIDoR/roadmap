json.theme @theme.title
json.answers @answers do |a|
  json.id a.id
  json.answer a.text
  json.created_at a.created_at
  json.question do
    json.id a.question.id
    json.title a.question.text
    json.type a.question.question_format.title
  end
  json.plan do
    json.id a.plan.id
    json.title a.plan.title
  end
end