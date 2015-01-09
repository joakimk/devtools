defmodule Devtools do
  def main(args) do
    [ language, action, path ] = args
    Devtools.generate(language, action, path)
  end

  def generate("ruby", "gen", path) do
    RubyGenerator.generate(path) |>
      Enum.each(&write_file/1)
  end

  def generate(_) do
    IO.puts("Usage example: devtools ruby gen app/models/foo.rb")
  end

  defp write_file(file) do
    File.mkdir_p parent_directory(file)
    { :ok, fd } = File.open(file.path, [ :write ])
    IO.binwrite(fd, file.content)
    File.close(fd)
  end

  # TODO: Reimplement in a sane way
  defp parent_directory(file) do
    [ _filename | rest ] = String.split(file.path, "/") |> Enum.reverse
    Enum.join(Enum.reverse(rest), "/")
  end
end
