defmodule Updtr.Image.Transformer do
  def transform(original_file, operation \\ "convert") do
    thumb_path = generate_thumb_file(original_file)

    System.cmd(operation, operation_commands(original_file, thumb_path, "600x400"))

    thumb_path
  end

  defp generate_thumb_file(original_file) do
    original_file
    |> String.replace(".", "_thumb.")
  end

  defp operation_commands(original_file_path, thumb_path, size \\ "250x90") do
    [
      "-define",
      "jpeg:size=500x180",
      original_file_path,
      "-auto-orient",
      "-thumbnail",
      size,
      "-unsharp",
      "0x.5",
      thumb_path
    ]
  end
end
