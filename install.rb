puts "=" * 70
puts "Installning Content Refresher"
puts "=" * 70
from = File.join(File.dirname(__FILE__), 'resources', 'public', 'javascripts', 'content_refresher.js')
to = File.join(Rails.root, 'public', 'javascripts', 'content_refresher.js')
puts File.copy(from, to, true)

puts IO.read(File.join(File.dirname(__FILE__), 'README'))


