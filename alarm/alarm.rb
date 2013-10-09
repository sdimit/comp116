require 'packetfu'
include PacketFu

$incident_number = 0
def alert(attack, pkt)
	$incident_number+=1
	puts "%3d. " % $incident_number + 
         "ALERT: #{attack} is detected from " + 
         "%14s (#{pkt.proto.last})!\n" % pkt.ip_saddr
#    puts "     packet to: %s, size: %s" % [pkt.ip_daddr, pkt.size ]#pkt.tcp_header.tcp_flags_readable]
end

def checkForScans(pkt)
	tcpFlags = pkt.tcp_header.tcp_flags_readable
	case tcpFlags
	when "......" # we have no flags set
	   	alert("NULL scan", pkt)
	when "U.P..F" # we have URG, PUSH & FIN set
	   	alert("XMAS scan", pkt)
	when ".....F" # FIN is set
	   	alert("FIN scan", pkt)
	when "....S." # discovered on http://danielmiessler.com/study/synpackets/
			# nmap SYN packets dont have any of the fragmentation flags set
			# such packets appear in SYN & other nmap scans like:
			# Ping -sP, Version Detection -sV, UDP scans -sU, 
			# IP protocol -sO, ACK -sA, Window -sW, RPC -sR
			# NMAP conveniently sends a SYN franken-packet
			# (no frag flags set) at the start of most scans
		if (pkt.ip_header.ip_frag == 0)
			alert("Nmap scan", pkt)
		end
	else # check for *other* scans
		if (tcpFlags.include? "SF") 	   # we have SYN & FIN - an atypical combo
	   		alert("Nmap scan", pkt)		   # probably a scan?
		elsif (/nmap/i.match(pkt.payload)) # we have the nmap signature in the payload
			alert("Nmap scan", pkt)
		end

	end
end

$sawLoginKeyWords = false

def checkForLeaks(pkt)
    case pkt.tcp_header.tcp_dst
   	when 143
   	#We have an IMAP request, check for LOGIN keyword
   		matches = /LOGIN (.*) (.*)\r*\n*/i.match(pkt.payload)
   		alert("IMAP login data leaked", pkt) if (matches != nil)
   	when 110 
   	#We have a POP request, check for USER and PASS keywords. they go separately
   		usermatch = /USER (.*)\r*\n*/i.match(pkt.payload)
   		passmatch = /PASS (.*)\r*\n*/i.match(pkt.payload)
   		alert("POP login leaked", pkt) if (usermatch != nil)
   		alert("POP password leaked", pkt) if (passmatch != nil)
   	when 21 
   	#We have an FTP request, check for USER and PASS keywords. they go separately
   		usermatch = /USER (.*)\r*\n*/i.match(pkt.payload)
   		passmatch = /PASS (.*)\r*\n*/i.match(pkt.payload)
   		alert("FTP login leaked", pkt) if (usermatch != nil)
   		alert("FTP password leaked", pkt) if (passmatch != nil)
   	when 23 
   	# We have a TELNET request. Will always leak logins in clear text
   		alert("Login will leak! (TELNET was used)", pkt)
	when 25 
	# this is SMTP. keyword is AUTH LOGIN here
		alert("SMTP login leaked", pkt) if (/AUTH LOGIN/i.match(pkt.payload)) 
	else 
		# ... and credit card numbers
		if (/POST|GET|PUT/i =~ pkt.payload)
			# this regex with the aid of http://www.regular-expressions.info/creditcard.html
			# captures more formats than the sans suggested one but requires normalization for dashes
			creditCardRegEx = /(?:4[0-9]{12}(?:[0-9]{3})?|5[1-5][0-9]{14}|6(?:011|5[0-9][0-9])[0-9]{12}|3[47][0-9]{13}|3(?:0[0-5]|[68][0-9])[0-9]{11}|(?:2131|1800|35\d{3})\d{11})/
            # alt regex from http://www.sans.org/security-resources/idfaq/snort-detect-credit-card-numbers.php :
            # /(?:4\d{3}(\s|-)?\d{4}(\s|-)?\d{4}(\s|-)?\d{4})|(?:5\d{3}(\s|-)?\d{4}(\s|-)?\d{4}(\s|-)?\d{4})|(?:6011(\s|-)?\d{4}(\s|-)?\d{4}(\s|-)?\d{4})|(?:3\d{3}(\s|-)?\d{6}(\s|-)?\d{5})/
   			normalizedPayload = pkt.payload.gsub!(/-*\,*/, "") #removing dashes and commas from the payload
	   		alert("Leaked credit card number", pkt) if (creditCardRegEx.match(normalizedPayload))
   		end

   		# check for password leaking over HTTP
   		alert("Logins might leak! POST to an unencrypted (HTTP) page", pkt) if (/post.*http[^s]/i.match(pkt.payload))
   	end # case statement end
end

def checkForXSS(pkt)
		# ideas from https://www.owasp.org/index.php/XSS_Filter_Evasion_Cheat_Sheet
		# this to check if an attack vector has been converted to hexadecimal in the HTML format e.g. &#x0A 
		# (there could be a trailing ; or not and we could have trailing zeroes, too)
		attackVectors = ["alert", "javascript", "window.location", "document.referrer", "document.location"]
		attackVectors.map! { |evil| evil.each_byte.map { |b| sprintf("&#x[0]*%2X[;]*",b) }.join }
		alert("XSS hexahide attack", pkt)	if (attackVectors.any? { |evil| /#{evil}/i.match(pkt.payload) })
		# JS in sciprt tags # i at the end to ignore case.. 
		test1 = /<script(.*src.*>|.*>.*(alert|window.location|document.referrer|document.location)).*/i
		# JS embeded in img tags
		test2 = /<img[ ]*(src=["`']*javascript:|onmouseover=["`']*)(alert|window.location|document.referrer|document.location)/i
		# these can be used to fool filtering by 'breaking up' tags like javascript:, but browsers will ignore them.
		# allegedly wasnt able to fool chrome with this while testing but the owasp article mentions it
		test3 = /<(img|script)[ ]*src=["`']*.*(\t|&#x0A;|&#x09;|&#x0D;)/i 
		alert("XSS attack", pkt) if (test1.match(pkt.payload) or test2.match(pkt.payload) or test3.match(pkt.payload))  
end


if ARGV.length == 1
	iface = ARGV[0]
else iface = 'en1'
end

cap = Capture.new(:start => true, :iface => iface, :promisc => true)
packets = cap.stream

packets.each do |p|
	pkt = Packet.parse p

	if pkt.is_tcp? #check if we have a tcp packet because we look at some tcp flags in scan detection & leaks will happen over tcp/ip
		checkForScans(pkt)
		checkForXSS(pkt)
		checkForLeaks(pkt)
	end


end
