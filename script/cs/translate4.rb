def okay(c)
  while @taken.include? c
    c += 1
  end
  c
end

@taken = []
File.open('config/locales/es.yml').each_line do |line|
  m = %r{<s(\d+)>}.match(line)
  if m
    @taken << m[1]
  end
end

c = 1
File.open('es.yml.new', 'w') do |n|
  File.open('config/locales/es.yml').each_line do |line|
    m = %r{<s\d*>}.match(line)
    p m
    if !m.nil?
      c = okay(c)
      parts = line.split(%r{<s\d*>}, 2)
      mod_line = "#{parts[0]}<s#{c}>#{parts[1]}"
      n.puts mod_line
      c += 1
      puts "mod   line: #{mod_line}"
    else
      puts "plain line: #{line}"
      n.puts line
    end
  end
end

