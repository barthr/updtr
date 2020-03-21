defmodule UpdtrWeb.InputHelpers do
  use Phoenix.HTML


  def input(form, field, options \\ []) do
    type = options[:using] || Phoenix.HTML.Form.input_type(form, field)
    label_value = options[:label] || nil # humanize(field)
    prepend_icon_value = options[:prepend_icon] || nil

    wrapper_options = [class: "field #{state_class(form, field)}"]
    input_options = [] # To pass custom options to input

    validations = Phoenix.HTML.Form.input_validations(form, field)
    input_options = Keyword.merge(validations, input_options)

    content_tag :div, wrapper_options do
      input = input(type, form, field, input_options)
      error = UpdtrWeb.ErrorHelpers.error_tag(form, field) || ""
      html_elements = [input, error]

      html_elements
      |> prepend_if_true(label_value, [label(form, field, label_value)])

      if prepend_icon_value do
        content_tag :div, class: "ui left icon input" do
          html_elements
        end
      else
        html_elements
      end
    end
  end

  defp prepend_if_true(list, cond, extra) do
    if cond, do: extra ++ list, else: list
  end

  defp state_class(form, field) do
    cond do
      form.errors[field] -> "error"
      true -> nil
    end
  end

  defp input(type, form, field, input_options) do
    apply(Phoenix.HTML.Form, type, [form, field, input_options])
  end
end
