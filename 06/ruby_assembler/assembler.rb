require_relative 'tables'
$custom_symbol = Hash.new
$custom_symbol_memory_index = 16
$rom_location = 0

def a_command(str, symbol)
  str = str[1..-1]
  if str.count("0-9") == 0 #Checks if string has a number in it
    $custom_symbol[str] = $custom_symbol_memory_index
    $custom_symbol_memory_index += 1 #increments index
  elsif str.scan(/\D/).empty? #checks if string contains only ints (if it doesn't, we're going to assume it's a symbol of some kind)
    str = str.to_i
    address = str.to_s(2).rjust(16,"0") #convert int to binary string & add zeros until 16 bits
  elsif str[0] == "R" #It's a predefined symbol (R0, R1, etc)
    str = symbol[str]
    str = str.to_i
    address = str.to_s(2).rjust(16,"0") #convert int to binary string & add zeros until 16 bits
  else
    if $custom_symbol[str] != nil
      address = $custom_symbol[str]
      address = address.to_i
      address = address.to_s(2).rjust(16,"0")
    else
      $custom_symbol[str] = $custom_symbol_memory_index
      $custom_symbol_memory_index += 1
      address = $custom_symbol[str]
      address = address.to_s(2).rjust(16,"0")
    end
  end
  return address
end

def c_command(str, comp, dest, jump)
  p str
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
    return address
  end

def user_defined_symbol_handling(str, rom_location)
  if str[0] == "(" #(SYMBOL) format
    str.slice!(0)
    str.slice!(-1) #Delete first and last character removing ()
    $custom_symbol[str] = rom_location
  else
    rom_location += 1
  end
end

def parse_command(str, comp, dest, jump, symbol)
  address = 0
  if str[0] == "@" #Check if A or C instruction
    address = a_command(str, symbol)
  elsif str[0] != "(" && $custom_symbol[str] == nil
    address = c_command(str, comp, dest, jump)
  end
  return address
end

assembly_array = []

f = File.open("Max.asm")
f.each_line { |line| assembly_array << line }
f.close

assembly_array = assembly_array.map { |item| item.sub /\/\/(.*)/, ''} #Removes comments
assembly_array = assembly_array.map { |item| item.strip } #Removes comments
assembly_array.each {|item| item.chomp!} #Removes \n and \r
assembly_array.delete("") #Removes empty elements from array

#First Pass
assembly_array.each {|item| user_defined_symbol_handling(item, assembly_array.index(item))}
#Second Pass
assembly_array = assembly_array.map { |item| parse_command(item, COMP, DEST, JUMP, PREDEFINED_SYMBOLS) }

binary_file = File.new("out.hack", "w")
binary_file.puts(assembly_array)
binary_file.close
