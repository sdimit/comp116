require 'packetfu'
include PacketFu
#print("enter interface: ")
#iface = gets.strip

#stream.show_live()
#print Packet.respond_to?(:to_pcap)

$incident_number = 0
def alert(attack, pkt)
	$incident_number+=1
	puts "%3d. " % $incident_number + 
         "ALERT: #{attack} is detected from " + 
         "%14s (#{pkt.proto.last}) !!!\n" % pkt.ip_saddr
    puts "     packet to: %s, size: %s" % [pkt.ip_daddr, pkt.size ]#pkt.tcp_header.tcp_flags_readable]
end

$sawLoginKeyWords = false

iface = 'en1'
cap = Capture.new(:start => true, :iface => iface, :promisc => true)
packets = cap.stream
puts "loading..."
#cap = PcapFile.read_packets('new.pcap')
#packets = cap
#puts cap[0].class
puts "done."

packets.each do |p|
	pkt = Packet.parse p
#	pkt = p

	if pkt.is_tcp?

		flags = pkt.tcp_header.tcp_flags_readable
		#puts flags
			#puts pkt.payload.class
		case flags
			# --- Stealth scans --- "
		when "......" # we have no flags set
		   	alert("NULL scan", pkt)
		when "U.P..F" # we have URG, PUSH & FIN set
		   	alert("XMAS scan", pkt)
		when ".....F" # FIN set
		   	alert("FIN scan", pkt)
		when "....S."
			# nmap SYN packets dont have any of the fragmentation flags set
			# such packets appear in SYN & other nmap scans like:
			# Ping -sP, Version Detection -sV, UDP scans -sU, 
			# IP protocol -sO, ACK -sA, Window -sW, RPC -sR
			# looks like NMAP courteously sends a SYN franken-packet
			# (with no frag flags set) before most of its scans
			if (pkt.ip_header.ip_frag == 0)
				alert("Nmap (SYN?) scan", pkt)
			end
		end

		if (flags.include? "SF") # we have SYN & FIN illegal combo
		   	alert("Nmap scan", pkt)
		end

	    case pkt.tcp_header.tcp_dst
	   	when 143 #We have an IMAP request, check for LOGIN
	   		matches = /LOGIN (.*) (.*)\r*\n*/.match(pkt.payload)
	   		if (matches != nil)
	   			alert("IMAP login data leaked", pkt)
	   		#	puts "user:" + matches[1]
	   		#	puts "pass:" + matches[2]
	   		end
	   	when 110 #We have a POP request, check for USER and PASS
	   		usermatch = /USER (.*)\r*\n*/.match(pkt.payload)
	   		passmatch = /PASS (.*)\r*\n*/.match(pkt.payload)
	   		if (usermatch != nil)
	   			alert("POP login leaked", pkt)
	   		#	puts "user:" + usermatch[1]
	   		elsif (passmatch != nil)
	   			alert("POP password leaked", pkt)
	   		#	puts "pass:" + passmatch[1]
	   		end
	   	when 23 #We have a TELNET request. Since nothing is 
	   			#encrypted here just dump it all
				# puts pkt.payload
		when 25 # this is SMTP
			if (pkt.payload.include? "AUTH LOGIN") 
				$sawLoginKeyWords = true
			end
			if ($sawLoginKeyWords == true) 
				alert("SMTP login leaked", pkt)
				#puts pkt.payload
			end
		when 80 # HTTP stuff -> check for XSS attacks and credit card numbers
			attackVectors = ["GET", "POST", "Window.location", "Document.referrer", "document.location"]
			if (attackVectors.any? { |evil| /#{evil}/i =~ pkt.payload })
				if (/<script>.*<\/script>/i =~ pkt.payload)  # i at the end to ignore case.. 
					alert("XSS attack", pkt)
				end
			end
			if (/POST|GET|PUT/i =~ pkt.payload)
				# this regex courtesy of http://stackoverflow.com/questions/9315647/regex-credit-card-number-tests
				creditCardRegEx = /(?:4[0-9]{12}(?:[0-9]{3})?|5[1-5][0-9]{14}|6(?:011|5[0-9][0-9])[0-9]{12}|3[47][0-9]{13}|3(?:0[0-5]|[68][0-9])[0-9]{11}|(?:2131|1800|35\d{3})\d{11})/
	   			normalizedPayload = pkt.payload.gsub!(/-*\,*/, "")
		   		if (creditCardRegEx.match(normalizedPayload))
	   				alert("Leaked credit card number", pkt)
	   			end
	   		end
	   	end
	elsif pkt.is_udp?
		alert("Nmap scan", pkt)
	end
end

