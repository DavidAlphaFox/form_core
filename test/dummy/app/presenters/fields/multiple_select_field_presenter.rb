# frozen_string_literal: true

module Fields
  class MultipleSelectFieldPresenter < FieldPresenter
    MAX_HARD_CODE_ITEMS_SIZE = 20

    def include_blank?
      false
    end

    def value_for_preview
      super&.join(", ")
    end

    def can_custom_value?
      !@model.options.strict_select
    end

    def collection
      if can_custom_value? && value.present?
        (value + @model.collection).uniq
      else
        @model.collection
      end
    end

    def options_for_select
      @view.options_for_select(collection, value)
    end

    def max_items_size
      size = @model.validations.length.maximum
      size > 0 ? size : MAX_HARD_CODE_ITEMS_SIZE
    end

    def name
      @model.pluralized_name
    end
  end
end
