defmodule RubyGeneratorTest do
  use ExUnit.Case

  test "can generate a class and spec file" do
    files = RubyGenerator.generate("app/models/foo")
    [ class_file, spec_file ] = files

    assert class_file.path == "app/models/foo.rb"
    assert class_file.content == """
    class Foo
      method_object :run

      def run
      end
    end
    """

    assert spec_file.path == "unit/models/foo_spec.rb"
    assert spec_file.content == """
    require "spec_helper"
    require "foo"

    describe Foo, ".run" do
      it "works" do
        Foo.run
      end
    end
    """
  end

  test "it can generate a file in lib" do
    files = RubyGenerator.generate("lib/foo")
    [ class_file, spec_file ] = files

    assert class_file.path == "lib/foo.rb"
    assert spec_file.path == "unit/lib/foo_spec.rb"
  end

  test "it can handle .rb added to the input path" do
    files = RubyGenerator.generate("lib/foo.rb")
    [ class_file, spec_file ] = files

    assert class_file.path == "lib/foo.rb"
  end
end

