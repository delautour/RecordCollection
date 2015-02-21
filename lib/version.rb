build = nil
if File.exists?('.build')
  File.open(".build", 'r') do |f|
    build = f.readline
  end
end

VERSION = build || "0.1.#{Time.now.utc.to_i}"
