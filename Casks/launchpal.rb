cask "launchpal" do
  version "1.21.1"
  sha256 "1cc96a3b1b5c1bb8d6ab5cc2df36c67f9a3800118a468e2c6c4c9fbe2c0a03c0"

  url "https://github.com/chenwei791129/launchpal/releases/download/v#{version}/LaunchPal.dmg"
  name "LaunchPal"
  desc "macOS LaunchAgent GUI management tool"
  homepage "https://github.com/chenwei791129/launchpal"

  # Must stay in step with LSMinimumSystemVersion in the app bundle. LaunchPal's
  # binaries are stamped as requiring macOS 13, and dyld refuses to load them on
  # anything older — without this stanza Homebrew would install an app that
  # cannot launch, and on an unsigned app that failure reads as a Gatekeeper
  # problem rather than a version one.
  depends_on macos: :ventura

  app "launchpal.app"

  postflight do
    system_command "/usr/bin/xattr",
                   args: ["-dr", "com.apple.quarantine", "#{appdir}/launchpal.app"]
  end

  uninstall quit: "com.wails.launchpal"
  zap trash: "~/Library/Preferences/com.wails.launchpal.plist"

  caveats <<~EOS
    LaunchPal is not code-signed or notarized.
    The quarantine attribute has been automatically removed during installation
    so macOS Gatekeeper will not block the app from opening.
    This is safe because LaunchPal is open-source:
      https://github.com/chenwei791129/launchpal
  EOS
end
