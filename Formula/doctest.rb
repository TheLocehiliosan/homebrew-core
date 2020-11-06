class Doctest < Formula
  desc "Feature-rich C++11/14/17/20 single-header testing framework"
  homepage "https://github.com/onqtam/doctest"
  url "https://github.com/onqtam/doctest/archive/2.4.1.tar.gz"
  sha256 "0a0f0be21ee23e36ff6b8b9d63c06a7792e04cce342e1df3dee0e40d1e21b9f0"
  license "MIT"

  bottle do
    cellar :any_skip_relocation
    sha256 "55ddcbc1b4b27cbe269c830a60b89eb77f33be335ebbc277db4f6fdb27fc9ec0" => :catalina
    sha256 "55ddcbc1b4b27cbe269c830a60b89eb77f33be335ebbc277db4f6fdb27fc9ec0" => :mojave
    sha256 "55ddcbc1b4b27cbe269c830a60b89eb77f33be335ebbc277db4f6fdb27fc9ec0" => :high_sierra
  end

  depends_on "cmake" => :build

  def install
    mkdir "build" do
      system "cmake", "..", *std_cmake_args
      system "cmake", "--build", ".", "--target", "install"
    end
  end

  test do
    (testpath/"test.cpp").write <<~EOS
      #define DOCTEST_CONFIG_IMPLEMENT_WITH_MAIN
      #include <doctest/doctest.h>
      TEST_CASE("Basic") {
        int x = 1;
        SUBCASE("Test section 1") {
          x = x + 1;
          REQUIRE(x == 2);
        }
        SUBCASE("Test section 2") {
          REQUIRE(x == 1);
        }
      }
    EOS
    system ENV.cxx, "test.cpp", "-std=c++11", "-o", "test"
    system "./test"
  end
end
