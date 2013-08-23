f = File.open("t.html")
doc = Nokogiri::HTML(f)
puts doc.inspect
f.close
