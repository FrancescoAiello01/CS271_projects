assembly_array = []

f = File.open("Add.asm")
f.each_line { |line| assembly_array << line }
f.close

puts assembly_array

binary_file = File.new("out.hack", "w")
binary_file.puts(assembly_array)
binary_file.close
