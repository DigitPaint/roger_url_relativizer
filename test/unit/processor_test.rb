require File.dirname(__FILE__) + "/../../lib/roger_url_relativizer/processor"
require "test/unit"
require "roger/testing/mock_release"

class UrlRelativizerTest < ::Test::Unit::TestCase
  def setup
    @release = Roger::Testing::MockRelease.new
    @processor = RogerUrlRelativizer::UrlRelativizer.new
  end

  def teardown
    @release.destroy
    @release = nil
  end

  def test_empty_release_runs
    files = @processor.call(@release)
    assert_equal 0, files.length
  end

  def test_basic_relativization
    @release.project.construct.directory "build/sub" do |dir|
      dir.file "test.html", "<a href='/test.html'>link</a>"
    end
    @release.project.construct.file "build/test.html"

    files = @processor.call(@release)
    assert_equal 2, files.length

    contents = File.read((@release.build_path + "sub/test.html").to_s)
    assert contents.include?("../test.html")
  end
end
