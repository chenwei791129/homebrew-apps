cask "launchpal" do
  version "1.5.0"
  sha256 "01e83cfdd2e3d05456b147baaa33526a9bd67c31f2a101783723d4ebab409425"

  url "https://github.com/chenwei791129/launchpal/releases/download/v#{version}/LaunchPal.dmg"
  name "LaunchPal"
  desc "macOS LaunchAgent GUI management tool"
  homepage "https://github.com/chenwei791129/launchpal"

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
