class Librdkafka < Formula
  desc "The Apache Kafka C/C++ library"
  homepage "https://github.com/edenhill/librdkafka"
  url "https://github.com/edenhill/librdkafka/archive/v1.0.0-RC5.tar.gz"
  sha256 "71bc40e92adfb1741531c16aa27c8ccae6232f9bccb1f2b6294f16e1c7385c66"
  head "https://github.com/edenhill/librdkafka.git"

  depends_on "pkg-config" => :build
  depends_on "lz4"
  depends_on "lzlib"
  depends_on "openssl"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~EOS
      #include <librdkafka/rdkafka.h>
      int main (int argc, char **argv)
      {
        int partition = RD_KAFKA_PARTITION_UA; /* random */
        return 0;
      }
    EOS
    system ENV.cc, "test.c", "-L#{lib}", "-lrdkafka", "-lz", "-lpthread", "-o", "test"
    system "./test"
  end
end
