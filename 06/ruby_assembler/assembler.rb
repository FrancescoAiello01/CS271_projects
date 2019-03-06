require_relative 'tables'

def parse_command(str, comp, dest, jump)
  a_command = false
  address = 0
  if str[0] == "@" #Check if A or C instruction
    a_command = true
    str = str[1..-1]
  else
    a_command = false
  end

  if a_command == true #Do this if it's an A-command
    str = str.to_i
    address = str.to_s(2).rjust(16,"0") #convert int to binary string & add zeros until 16 bits
    #puts address
  else #Do this if it's a C-command
    address = "111"
    if str[2] != "J" #If no jump
      str = str.strip.split("=")
      address = address + comp[str[1]]
      address = address + dest[str[0]]
      address = address + jump["null"]
    else #If there is a jump
      str = str.strip.split(";")
      address = address + comp[str[0]]
      address = address + dest["null"]
      address = address + jump[str[1]]
    end
  end
  return address
end

assembly_array = []

f = File.open("PongL.asm")
f.each_line { |line| assembly_array << line }
f.close

assembly_array.delete_if {|item| item.start_with?("//")} #Removes comments from array
assembly_array.each {|item| item.chomp!} #Removes \n and \r
assembly_array.delete("") #Removes empty elements from array

assembly_array = assembly_array.map { |item| parse_command(item, COMP, DEST, JUMP) }

#p assembly_array

binary_file = File.new("out.hack", "w")
binary_file.puts(assembly_array)
binary_file.close
