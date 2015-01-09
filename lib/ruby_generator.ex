defmodule RubyGenerator do
  defmodule File do
    defstruct path: nil, content: ""
  end

  def generate(path) do
    partial_path = Regex.replace(~r/\.rb/, path, "")
    [ class_file(partial_path), spec_file(partial_path) ]
  end

  defp class_file(partial_path) do
    %File{ path: "#{partial_path}.rb", content: name(partial_path) |> class_file_content }
  end

  defp spec_file(partial_path) do
    base_path = String.split(partial_path, "/") |>
      Enum.reject(fn(element) -> element == "app" end) |>
      Enum.join("/")

    %File{ path: "unit/#{base_path}_spec.rb", content: name(partial_path) |> spec_file_content }
  end

  defp name(partial_path) do
    String.split(partial_path, "/") |>
      Enum.at(-1)
  end

  defp class_file_content(name) do
    """
class #{camelize(name)}
  method_object :run

  def run
  end
end
"""
  end

  defp spec_file_content(name) do
    class_name = camelize(name)
    """
require "spec_helper"
require "#{name}"

describe #{class_name}, ".run" do
  it "works" do
    #{class_name}.run
  end
end
"""
  end

  defp camelize(name) do
    Mix.Utils.camelize(name)
  end
end
