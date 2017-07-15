class DataSource < FieldOptions
  def type_key
    self.class.model_name.name.split("::").last.underscore
  end

  def stored_type
    :integer
  end

  def foreign_field_name_suffix
    "_id"
  end

  def foreign_field_name(field_name)
    "#{field_name}#{foreign_field_name_suffix}"
  end

  def value_method
    :id
  end

  def text_method
    raise NotImplementedError
  end

  def scoped_condition
    self.to_h
  end

  def scoped_records
    self.class.scoped_records(scoped_condition)
  end

  def interpret_to(model, field_name, accessibility, _options = {})
    klass = self.class
    scoped_condition = self.scoped_condition
    foreign_field_name = foreign_field_name(field_name)
    primary_key = self.value_method

    model.define_method field_name do
      find_condition = {primary_key => send(foreign_field_name)}
      klass.find_record find_condition, scoped_condition
    end
  end

  class << self
    def scoped_records(_condition)
      raise NotImplementedError
    end

    def find_record(find_condition, scoped_condition = {})
      scoped_records(scoped_condition).where(find_condition).first
    end
  end
end
