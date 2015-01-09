defmodule DevtoolsTest do
  use ExUnit.Case

  test "can generate files" do
    File.rm_rf "tmp/files"
    File.mkdir_p "tmp/files"
    File.cd "tmp/files"

    Devtools.generate("ruby", "gen", "app/models/bar")

    assert File.exists?("app/models/bar.rb")
    assert File.exists?("unit/models/bar_spec.rb")
    { :ok, content } = File.read("app/models/bar.rb")
    assert Regex.match?(~r/class Bar/, content)
  end
end
