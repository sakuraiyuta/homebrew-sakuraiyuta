class ScreenUtf8 < Formula
  desc "Terminal multiplexer with VT100/ANSI terminal emulation"
  homepage "https://www.gnu.org/software/screen"
  license "GPL-3.0"

  stable do
    url "https://ftp.gnu.org/gnu/screen/screen-4.8.0.tar.gz"
    mirror "https://ftpmirror.gnu.org/screen/screen-4.8.0.tar.gz"
    sha256 "6e11b13d8489925fde25dfb0935bf6ed71f9eb47eff233a181e078fde5655aa1"

    # This patch is to disable the error message
    # "/var/run/utmp: No such file or directory" on launch
    patch :p2 do
      url "https://gist.githubusercontent.com/yujinakayama/4608863/raw/75669072f227b82777df25f99ffd9657bd113847/gistfile1.diff"
      sha256 "9c53320cbe3a24c8fb5d77cf701c47918b3fabe8d6f339a00cfdb59e11af0ad5"
    end

    patch :p2 do
      # url "https://gist.github.com/raw/626040/be6a04f0e64c56185ba5850415ac59dad4cd62a0/screen-utf8-nfd.patch"
      url "https://gist.githubusercontent.com/rcmdnk/b0bf57d422c875fb70645556d7770091/raw/16c81629ab2f83ec9e99241a34f9e8b28b773c61/screen-utf8-nfd.patch"
      sha256 "d0c03d35fadeb872891b5b387b219f865dd01bde777f29eed7f5f6f2313e1d45"
    end

    patch :p2 do
      # url "http://zuse.jp/misc/screen-utf8-osc.diff"
      url "https://gist.githubusercontent.com/rcmdnk/8a90eba829fd789a4e058492b494f862/raw/859b14c0ba82e855394dd2ec3df64be79ab452fc/screen-utf8-osc.diff"
      sha256 "e0d75f895b34e2c5107ef1758c738a06273328be4b68e6ea80cff3083ee8659a"
    end
  end

  head do
    url "https://git.savannah.gnu.org/git/screen.git"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build

  uses_from_macos "ncurses"

  def install
    cd "src" if build.head?

    # With parallel build, it fails
    # because of trying to compile files which depend osdef.h
    # before osdef.sh script generates it.
    ENV.deparallelize

    # Fix for Xcode 12 build errors.
    # https://savannah.gnu.org/bugs/index.php?59465
    ENV.append "CFLAGS", "-Wno-implicit-function-declaration"

    system "./autogen.sh"
    system "./configure", "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--infodir=#{info}",
                          "--enable-colors256",
                          "--enable-pam"

    system "make"
    system "make", "install"
  end

  test do
    shell_output("#{bin}/screen -h", 1)
  end
end
