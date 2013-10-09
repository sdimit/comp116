Assignment 2: Incident Alarm with PacketFu
=======
by Stefan Dimitrov

Usage:
------
  `sudo ruby alarm.rb [ifacename]`
  
  defaults to an interface named 'en1' unless ifacename is provided

Features: 
---------
 * POP, IMAP, FTP, SMTP login leak detection
 * warns when nonsecure protocols are being used: TELNET, POST/GET over HTTP
 * scans for several common XSS attacks
 * warns about potential leakage of credit card numbers over HTTP (i.e. via website)
 * able to detect a variety of stealth Nmap scans in adition to more traditional ones
