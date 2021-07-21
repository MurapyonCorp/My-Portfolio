class StartDateValidator < ActiveModel::EachValidator
  def validate_each(record, attribute, value)
    if value.match(start_date.current_user == start_date.current_user)
      record.errors.add(attribute, options[:message] || "別のイベントが存在します")
    end
  end
end