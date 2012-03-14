require 'rubygems'
require 'rexml/document'

$file = File.open('types-fxs-xml-valid', 'w')

puts "Parsing XML to C VALID"

def parse_xml (xml_file)
string = File.open(xml_file, 'r'){ |file| file.read }

result = REXML::Document.new(string)

# if the hash has 'Error' as a key, we raise an error
#if result.has_key? 'Error'
#   raise "XML parsing ERROR"
#end

puts "result size = ",result.size

result[2].each_with_index do |n,i|
   #puts n.class
   if n.class==REXML::Element
      puts "index = ",i.to_s
      puts n
   end
end

result[2].elements.each("PTYPE") do |element|
   puts element.attributes["name"]
   $file.write element.attributes["name"]+"\n"
   #puts element.attributes["method"]
   #puts element.attributes["method"].class
   #puts element.attributes["pattern"]
   #puts met.class
   
   unless element.attributes["method"].class==NilClass
      #puts element.attributes["method"].class
      met = element.attributes["method"]
      puts met
      if met.eql?("integer")
         puts "int"
         pattern = element.attributes["pattern"]
         $file.write pattern+"\n"
         if pattern.include?("..")
            strs=pattern.split("..")
            $file.write "     "*1+"if (*requests->requestvb->val.integer<"+strs[0]+" || *requests->requestvb->val.integer>"+strs[1]+")\n"+"     "*2+"netsnmp_set_request_error(reqinfo, requests, SNMP_ERR_WRONGVALUE );\n\n"
         end
      end
      next
   end
   
   unless element.attributes["pattern"].class==NilClass
      met = element.attributes["pattern"]
      if met.end_with?("}")
         strs=met.split("{")
         strs2=strs[1].split("}")
         strs3=strs2[0].split(",")
         $file.write "     "*1+"if (requests->requestvb->val_len>"+strs3[1]+")\n"+"     "*2+"netsnmp_set_request_error(reqinfo, requests, SNMP_ERR_WRONGLENGTH );\n\n"
      end
      next
   end
end
end

parse_xml("types.xml")
parse_xml("types-fxs.xml")

$file.close

__END__
