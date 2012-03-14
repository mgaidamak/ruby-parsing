require 'rubygems'
require 'json'

$file = File.open('eltex-msan-fxs', 'w')

puts "Parsing JSON to SMI"

string = File.open('config.json', 'r'){ |file| file.read }

result = JSON.parse(string)
# if the hash has 'Error' as a key, we raise an error
if result.has_key? 'Error'
   raise "JSON parsing ERROR"
end

puts "result size = ",result.size

def format (str)
   res = ""
   if str.include?("-")
      strs=str.split("-")
      puts strs
      strs.each do |st|
         st.capitalize!
      end
      strs[0].downcase!
      strs.each do |st|
         res.concat(st)
      end
   elsif str.include?("_")
      strs=str.split("_")
      puts strs
      strs.each do |st|
         st.capitalize!
      end
      strs[0].downcase!
      strs.each do |st|
         res.concat(st)
      end
   else res=str
   end
   return res
end

def write_object (name,array,tab)
   array.each_with_index do |n,i|
   sum=i+1
   tabb=tab+1
   puts "n class = ",n[1].class
   if n[1] && n[1].class==Hash && n[1].size>0
       $file.write "   "*tab+format(n[0].to_s)+" OBJECT IDENTIFIER ::= { #{name} #{sum} }\n\n"
       write_object(format(n[0].to_s),n[1],tab+1)
   elsif n[1].class==Fixnum
       $file.write "   "*tab+format(n[0].to_s)+" OBJECT-TYPE\n"+"   "*tabb+"SYNTAX Integer32\n"+"   "*tabb+"MAX-ACCESS read-write\n"+"   "*tabb+"STATUS current\n"+"   "*tabb+"DESCRIPTION\n"+"   "*tabb+"   \" \"\n"+"   "*tabb+"::= { #{name} #{sum} }\n\n"
   elsif n[1].class==String
       $file.write "   "*tab+format(n[0].to_s)+" OBJECT-TYPE\n"+"   "*tabb+"SYNTAX DisplayString\n"+"   "*tabb+"MAX-ACCESS read-write\n"+"   "*tabb+"STATUS current\n"+"   "*tabb+"DESCRIPTION\n"+"   "*tabb+"   \" \"\n"+"   "*tabb+"::= { #{name} #{sum} }\n\n"
   elsif n[1].class==FalseClass || n[1].class==TrueClass
       $file.write "   "*tab+format(n[0].to_s)+" OBJECT-TYPE\n"+"   "*tabb+"SYNTAX TruthValue\n"+"   "*tabb+"MAX-ACCESS read-write\n"+"   "*tabb+"STATUS current\n"+"   "*tabb+"DESCRIPTION\n"+"   "*tabb+"   \" \"\n"+"   "*tabb+"::= { #{name} #{sum} }\n\n"
   else
       $file.write "   "*tab+format(n[0].to_s)+" OBJECT-TYPE\n"+"   "*tabb+"SYNTAX DisplayString\n"+"   "*tabb+"MAX-ACCESS read-write\n"+"   "*tabb+"STATUS current\n"+"   "*tabb+"DESCRIPTION\n"+"   "*tabb+"   \" \"\n"+"   "*tabb+"::= { #{name} #{sum} }\n\n"
   end
   end
end

result.each_with_index do |n,i|
   puts "index = ",i.to_s
   puts "n class = ",n[1].class
   puts "n size = ",n[1].size
   sum=i+1
   if n[1] && n[1].class==Hash && n[1].size>0
       $file.write format(n[0].to_s)+" OBJECT IDENTIFIER ::= { eltexMsanFxs #{sum} }\n\n"
       write_object(format(n[0].to_s),n[1],1)
   elsif n[1].class==Fixnum
       $file.write "   "*tab+format(n[0].to_s)+" OBJECT-TYPE\n"+"   "*tabb+"SYNTAX Integer32\n"+"   "*tabb+"MAX-ACCESS read-write\n"+"   "*tabb+"STATUS current\n"+"   "*tabb+"DESCRIPTION\n"+"   "*tabb+"   \" \"\n"+"   "*tabb+"::= { eltexMsanFxs #{sum} }\n\n"
   elsif n[1].class==String
       $file.write "   "*tab+format(n[0].to_s)+" OBJECT-TYPE\n"+"   "*tabb+"SYNTAX DisplayString\n"+"   "*tabb+"MAX-ACCESS read-write\n"+"   "*tabb+"STATUS current\n"+"   "*tabb+"DESCRIPTION\n"+"   "*tabb+"   \" \"\n"+"   "*tabb+"::= { eltexMsanFxs #{sum} }\n\n"
   elsif n[1].class==FalseClass || n[1].class==TrueClass
       $file.write "   "*tab+format(n[0].to_s)+" OBJECT-TYPE\n"+"   "*tabb+"SYNTAX TruthValue\n"+"   "*tabb+"MAX-ACCESS read-write\n"+"   "*tabb+"STATUS current\n"+"   "*tabb+"DESCRIPTION\n"+"   "*tabb+"   \" \"\n"+"   "*tabb+"::= { eltexMsanFxs #{sum} }\n\n"
   else
       $file.write "   "*tab+format(n[0].to_s)+" OBJECT-TYPE\n"+"   "*tabb+"SYNTAX DisplayString\n"+"   "*tabb+"MAX-ACCESS read-write\n"+"   "*tabb+"STATUS current\n"+"   "*tabb+"DESCRIPTION\n"+"   "*tabb+"   \" \"\n"+"   "*tabb+"::= { eltexMsanFxs #{sum} }\n\n"
   end
end

$file.close

__END__
