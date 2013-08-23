# Find all files change items that need translatit(:' t(:t(:on)) ')
repl = {}
File.open('keep.yml', 'r').each_line do |line|
  next if line =~ %r{</s>}
  p = line.split(': ', 2)[1].split('# <s')[0]
  w = line.split(': ', 2)[0]
  repl[p] = w
  puts ".#{w}."
end

Dir.glob("**/*.{rb,haml}").each do |d|
  next if d =~ /(^spec)|(^feature)|(^db)|(^lib\/template)/
  changed = false
  File.open(d, 'r') do |old|
    File.open("#{d}.new", 'w') do |n|
      old.each_line do |line|
        repl.each do |replacing, replace_with|
          if line =~ %r{#{replacing}}
            line.gsub! replacing, "t(:#{replace_with})"
            changed = true
          end
        end
        n.puts line
      end
    end
    if changed
      File.delete(d)
      File.rename("#{d}.new", d)
    else
      File.delete("#{d}.new")
    end
  end
end

