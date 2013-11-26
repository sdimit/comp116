George Aquila & Stefan Dimitrov
Comp 116 - Ming Chow
Assignment 5: Forensics

Part 1.
---------------------------------------------------------------------------------------------------------------------------

The Identical .jpg Images
1. Upon examining the 3 given .jpg files, we primarily used the program "steghide" to check for embedded information.
2. Upon using extract on the images, we attempted first a simple search with a blank password for each. This was done using "steghide extract -sf a.jpg"
3. This yielded another image named "prado.jpg" that was embedded within the first image A. 
4. Further steps could not be taken because of the necessity for an encrypted key to reveal any other embedded files, but the other two images seemed not to indicate any embedded files.

Part 2.
---------------------------------------------------------------------------------------------------------------------------

We used autopsy on top of the sleuth kit in order to explore at the filesystems on the image.
We used photorec to recover deleted files from the unallocated space on the image. Amongst those we found evidence and pcap captures. 
strings and grep were occasionally used as well.

The Seized SD Card
1.      What is/are the disk format(s) of the SD card?
-There were two partitions inside of the image: one was FAT16 and the other one EXT4

2.      Is there a phone carrier involved?
- Yes/No.  

The device was possibly a raspberry pi, so that diminishes the chances that a phone carrier would be involved. In /root/.bash_history we found lines from a tutorial for installing Kali Linux on raspberry pi: http://progdave.wikidot.com/how-to-install-raspi-config-on-kali-on-a-raspberry-pi

On the other hand we could recover fragments from a file called smartcard_list.txt that contains “a match between an ATR and a card type”. SIM cards for a variety of phone carriers from around the world can be found in this file.

In addition to this, in one of the pcaps found amongst the deleted files, we found a security related blog, a post on which discussed a “deal” from AT&T about a netbook with a sad dataplan. T-mobile + Android was praised as the better option.

3.      What operating system, including version number, is being used? Please elaborate how you determined this information.
-We looked at the file /etc/os-release and found the line Kali GNU/Linux 1.0 which shows this must be a Kali Linux Distro. Also look at the answer to 2. 

4.      What other applications are installed? Please elaborate how you determined this information.
-Wireshark, Creepy (for extracting geo location data from online service), Xhydra, Metasploit, Uniscan, BEEF (Browser Exploitation Framework Project), Arachni, SANE Umax, OpenSSL, Rapid7, Treetop, Libwhisker, TCL/TK.
Found in /usr/share/applications/ and also located by searching through files yielded by Photorec using “sudo photorec SDcard.dd”

5.      Is there a root password? If so, what is it?
-“toor” obtained from the hash found in the shadow file, which was cracked using john.
        	-Also we found out that this is the default password for Kali Linux. root:$6$9Wim61h8$1BiweJjKZItqv62W5rmS/UCXQR/FGP97btwnJBk0XbeSb43PQseth8SGaxR7bhnDL/iwb2cxpHs80MRRBbulQ/:15855:0:99999:7:::

6.      Are there any additional user accounts on the system?
-It looks there are no other accounts: /home/ does not contain any (home) directories, also the shadow file contains a hash for root only.

7.      List some of the incriminating evidence that you found. Please elaborate where and how you uncovered the evidence.
- A variety of photos of the victim were found in /root/Pictures/ tour dates and song lyrics were found in text files inside of /root/Documents/.
- A ticket was found amongst a recovered pdf file. 
- From bash_history it seems that the user deleted several files and tried to empty out the contents of several folders.
- There is at least one encrypted file which looks suspicious - refer to 9.
- Theres a link to a celine dion album on spotify found in /root/shortcut.lnk

8.      Did the suspect move or try to delete any files before his arrest? Please list the name(s) of the file(s) and any indications of their contents that you can find.
       	- in /root/ the files: new1.jpg, new2.jpg, new3.jpg, receipt.pdf, dropbox.zip
- /etc/ssh/ssh_host_*
- these directories under /root/: Documents, Downloads, Music, Pictures, Public, Templates,Videos
-These attempts were discovered by looking at bash_history which revealed a history of rm commands that were clearly used to attempt to cover his tracks.

9.      Are there any encrypted files? If so, list the contents and a brief description of how you obtained the contents.
-Yes, the file /root/Dropbox.zip seems to be encrypted since running ‘file’ on it reports its filetype as data where it should be zip. This suggests that the file is a TrueCrypt image, considering the presense of TrueCrypt on the machine. 
-Moreover, looking at /root/.TrueCrypt reveals the filepipe .show-request-queue which contains an photo of celine dion. This is most likely the file that the user tried to encrypt, as TrueCrypt’s source code suggests. 

10.     Did the suspect at one point went to see this celebrity? If so, note the date and location where the suspect met the    celebrity? Please elaborate how you determined this information.
-Evidence recovered included a ticket that the suspect purchased on July 12th, 2012 AD. The ticket was to a concert of the victim at The Colosseum at Caesar’s Palace in Las Vegas Nevada on Saturday, July 28th, 2012 at 7:30 PM. Suspect is identified as one “Ming Chow”, most likely a pseudonym.

11.     Is there anything peculiar with the files on the system?
-Yes. Many files’ access, modified, and created times have clearly been tampered with and set to epoch time, whereas other files’ datastamps bear present time.

12.     Who is the celebrity that the suspect has been stalking?
-The celebrity victim is Celine Dion. 
-LOL /root/Documents/setlist contains lyrics
-spotify:album:41IwxoZoITRNmQheABRtwc in shortcut.lnk in /root
-Also various pictures of Celine were recovered amongst the suspect’s files… :D


Appendix:
Some evidence and notes.

(we used 2 tokens)

defcon@ubuntu:~/Desktop/john/run$ ./john crack
Loaded 1 password hash (crypt, generic crypt(3) [?/64])
Press 'q' or Ctrl-C to abort, almost any other key for status
toor             (root)
1g 0:00:00:00 100% 1/3 2.325g/s 223.2p/s 223.2c/s 223.2C/s root..Root0
Use the "--show" option to display all of the cracked passwords reliably
Session complete

OS NAME

/etc/os-release

PRETTY_NAME="Kali GNU/Linux 1.0"
NAME="Kali GNU/Linux"
ID=kali
VERSION="1.0"
VERSION_ID="1.0"
ID_LIKE=debian
ANSI_COLOR="1;31"
HOME_URL="http://www.kali.org/"
SUPPORT_URL="http://forums.kali.org/"
BUG_REPORT_URL="http://bugs.kali.org/"

ROOT PASSWORD

/etc/shadow

root:$6$9Wim61h8$1BiweJjKZItqv62W5rmS/UCXQR/FGP97btwnJBk0XbeSb43PQseth8SGaxR7bhnDL/iwb2cxpHs80MRRBbulQ/:15855:0:99999:7:::

PCAP FIles
An Html fragment with some mobile phones carriers involved
  <div style="clear:both;"></div>I saw an ad on TV about AT&T practically giving away Acer netbooks. Here's the <a href="http://www.wireless.att.com/cell-phone-service/cell-phone-details/?q_sku=sku3870224">link of note</a>.<br /><br />So, it's $199 for a netbook, as long as you sign a two-year contract for a DataConnect plan... and that's <a href="http://www.wireless.att.com/cell-phone-service/cell-phone-plans/data-connect-plans.jsp">where they get you</a>, as they say. $40/month, plus $199, makes this a $1159 computing device over two years. Oh, and the $40/month plan is capped at 200 mb/month. Uhhhhh yeah.<br /><br />This seems to suck significantly more than I expected.<br /><br />Back to Plan A, being an Android phone on T-Mobile and a tethered POS laptop. Now to figure out if their data plans are unlimited. (I've been having creeping problems with my BlackBerry 8310, which is why I'm looking at this now.)<div style="clear:both; padding-bottom:0.25em"></div><p class="blogger-labels">Labels: <a rel='tag' href="http://www.planb-security.net/labels/capped%20data%20plans.html">capped data plans</a>, <a rel='tag' href="http://www.planb-security.net/labels/consumer%20electronics.html">consumer electronics</a>, <a rel='tag' href="http://www.planb-security.net/labels/laptop.html">laptop</a></p>
