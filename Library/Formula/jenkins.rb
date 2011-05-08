require 'formula'

class Jenkins < Formula
  url 'http://mirrors.jenkins-ci.org/war/1.410/jenkins.war', :using => :nounzip
  version '1.410'
  md5 'd97c6fe93be5d6b7236805072a39f425'
  homepage 'http://jenkins-ci.org'

  def install
    lib.install "jenkins.war"
    (prefix+'org.jenkins-ci.plist').write startup_plist
  end

  def caveats; <<-EOS
If this is your first install, automatically load on login with:
    mkdir -p ~/Library/LaunchAgents
    cp #{prefix}/org.jenkins-ci.plist ~/Library/LaunchAgents/
    launchctl load -w ~/Library/LaunchAgents/org.jenkins-ci.plist

If this is an upgrade and you already have the org.jenkins-ci.plist loaded:
    launchctl unload -w ~/Library/LaunchAgents/org.jenkins-ci.plist
    cp #{prefix}/org.jenkins-ci.plist ~/Library/LaunchAgents/
    launchctl load -w ~/Library/LaunchAgents/org.jenkins-ci.plist

Or start it manually:
    java -jar #{lib}/jenkins.war
EOS
  end

  def startup_plist
    return <<-EOS
<?xml version="1.0" encoding="UTF-8"?>
<!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
<plist version="1.0">
<dict>
    <key>Label</key>
    <string>Jenkins</string>
    <key>ProgramArguments</key>
    <array>
    <string>/usr/bin/java</string>
    <string>-Dmail.smtp.starttls.enable=true</string>
    <string>-jar</string>
    <string>#{lib}/jenkins.war</string>
    </array>
    <key>RunAtLoad</key>
    <true/>
</dict>
</plist>
EOS
  end

end
