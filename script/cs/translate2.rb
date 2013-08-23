# Find all files and look for strings within them
require 'set'
s = Set.new
Dir.glob("**/*.{rb,haml}").each do |d|
  next if d =~ /(^spec)|(^feature)|(^db)|(^lib\/template)/
  File.open(d, 'r').each_line do |line|
    line.scan(/(?:'[^']+')|(?:"[^"]+")/).each do |w|
      s.add(w)
    end
  end
end

s.sort.each_with_index do |w, i|
  puts w.parameterize.underscore + ': ' + w + "# <s#{i}>"
  puts w.parameterize.underscore + ': ' + w[0] + "<s#{i}>" + w[1..-2] + "</s>" + w[-1]
end

