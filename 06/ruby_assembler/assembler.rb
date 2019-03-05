#Hash tables
comp = {
  "0" => 0101010,
  "1" => 0111111,
  "-1" => 0111010,
  "D" => 0001100,
  "A" => 0110001,
  "!D" => 0001100,
  "!A" => 0110001,
  "-D" => 0001111,
  "-A" => 0110011,
  "D+1" => 0011111,
  "A+1" => 0110111,
  "D-1" => 0001110,
  "A-1" => 0110010,
  "D+A" => 0000010,
  "D-A" => 0010011,
  "A-D" => 0000111,
  "D&A" => 0000000,
  "D|A" => 0010101,
  "M" => 1110000,
  "!M" => 1110001,
  "-M" => 1110011,
  "M+1" => 1110111,
  "M-1" => 1110010,
  "D+M" => 1000010,
  "D-M" => 1010011,
  "M-D" => 1000111,
  "D&M" => 1000000,
  "D|M" => 1010101
}

dest = {
  nil => 000,
  "M" => 001,
  "D" => 010,
  "MD" => 011,
  "A" => 100,
  "AM" => 101,
  "AD" => 110,
  "AMD" => 111
}

jump = {
  nil => 000,
  "JGT" => 001,
  "JEQ" => 010,
  "JGE" => 011,
  "JLT" => 100,
  "JNE" => 101,
  "JLE" => 110,
  "JMP" => 111
}

def parse_command(str, comp, dest, jump)
  a_command = false
  if str[0] == "@" #Check if A or C instruction
    a_command = true
    str = str[1..-1]
  else
    a_command = false
  end

  if a_command == true #Do this if it's an A-command
    str = str.to_i #convert string to int
    address = str.to_s(2).rjust(16,"0") #convert int to binary string & add zeros until 16 bits
    #puts address
  else #Do this if it's a C-command
    address = "111"
    #TODO: Fix this part, D = M would be dest + comp, add some logic to concatinate this stuff in the right order
    address = address + comp[str].to_s
    address = address + dest[str].to_s
    address = address + jump[str].to_s
    puts address
  end


  #p binary_command
  #p str
end

assembly_array = []

f = File.open("Add.asm")
f.each_line { |line| assembly_array << line }
f.close

assembly_array.delete_if {|item| item.start_with?("//")} #Removes comments from array
assembly_array.each {|item| item.chomp!} #Removes \n and \r
assembly_array.delete("") #Removes empty elements from array

assembly_array.each {|item| parse_command(item, comp, dest, jump)}

p assembly_array

# binary_file = File.new("out.hack", "w")
# binary_file.puts(assembly_array)
# binary_file.close
