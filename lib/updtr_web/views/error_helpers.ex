defmodule UpdtrWeb.ErrorHelpers do
  @moduledoc """
  Conveniences for translating and building error messages.
  """

  use Phoenix.HTML

  @doc """
  Generates tag for inlined form input errors.
  """
  def error_tag(form, field) do
    errors =
      Enum.map(Keyword.get_values(form.errors, field), fn error ->
        content_tag(:div, translate_error(error), class: "ui basic red pointing prompt label transition visible")
      end)

    case errors do
      [] -> nil
      val -> val
    end
  end

  @spec error_class(atom | %{errors: keyword}, atom) :: <<_::96, _::_*88>>
  def error_class(form, field) do
    if Keyword.get_values(form.errors, field) |> length > 0 do
      "form-control is-invalid"
    else
      "form-control"
    end
  end

  @doc """
  Translates an error message using gettext.
  """
  def translate_error({msg, opts}) do
    if count = opts[:count] do
      Gettext.dngettext(UpdtrWeb.Gettext, "errors", msg, msg, count, opts)
    else
      Gettext.dgettext(UpdtrWeb.Gettext, "errors", msg, opts)
    end
  end
end
