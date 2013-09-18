set1.pcap
=======
1. 276 packets present
2. FTP
3. The password was sent to the server in clear text.
4. SCP
5. *67.23.79.113*
6. user: *stokerj*  
    pass: *w00tfu!*
7. 3 files were transferred
8. *code.rtf*, *secret.pdf*, *abc.jpg*
9. 

set2.pcap
=======
10. 74566
11. 5
12. wireshark: 
      searched for user/username/pass/password/login and their different variations,
      but that proved tedious (javascript in webpages contained those often).
      because of this I decided to filter for unsecured protocols (http, pop3, ftp, telnet) 
      and then inspected individual client/server conversations and  
      searched for the above strings/looked at Follow TCP Stream
      Lastly used dsniff to see if I've missed any logins...
13. seems like 200.60.17.1:23 is a cisco router, so there is no associated domain.
      plus a reverse DNS look up ended up yielding no results, so it's safe to assume
      this was a router device (username is conspicuously cisco and telnet is used
      for logging into some cisco routers a quick google search shows)
      
| # | User       | Password     | Source    			       | Destination      | Protocol
| 1 | cisco      | chris10          | 10.156.15.241:13247   | 200.60.17.1:23 | telnet
| 2 | cisco      | chelita           | 10.156.15.241:13247   | 200.60.17.1:23 | telnet
| 3 | cisco      | chayank        | 10.156.15.241:13247   | 200.60.17.1:23 | telnet
| 4 | cisco      | cereza           | 10.156.15.241:13247   | 200.60.17.1:23 | telnet
| 5 | cisco      | buburuza       | 10.156.15.241:13247  | 200.60.17.1:23 | telnet
| 6 | e129286 | 4.Ekkama     | 10.122.15.146:54630  | 144.122.144.179:110 arikanda.general.services.metu.edu.tr | pop3 * invalid login
| 7 | brewer  | 1qazxsw209simona12 |  10.124.15.238:49767 | 62.173.185.22:110 www.imartini.it | pop3 
| 8 | mbergeson@hjnews.com | mb123on | 10.117.15.217:49795 | 67.128.149.178:110 mail.newswest.com | pop3
14. at least two: logins 7 and 8 were granted access, 5 may or may not have been granted access
15. I looked for a response from the destination after the password packet was sent. 
      POP3: I deemed the response "OK! Logged In" to mean a successful login...
      Telnet: Logins 1-4 yielded a "% Login invalid" response. #5 did not elicit a response from the server,
      which might mean that it was successful or that the destination disappeared.
17. Besides the obvious legal repercussions that might follow stealing passwords
      and gaining unauthorized access to someone else's machine, the fact that
      someone dared send login info in clear text at defcon suggests that this might
      have been intentional and possibly a lure and a trap ;)
18. Use a secure alternative to telnet (like VPN) and POP3 (such as POP3S).
      Simply use secure protocols and work over an encrypted connection (HTTPS, TLS, SSL, SSH for example).
19. The list was obtained from Wireshark under Statistics > Address Resolution...
Host IP | Host
74.125.239.7 | talkgadget.l.google.com
74.125.239.4 | talkgadget.l.google.com
74.125.239.6 | talkgadget.l.google.com
74.125.239.0 | talkgadget.l.google.com
74.125.239.3 | talkgadget.l.google.com
74.125.239.1 | talkgadget.l.google.com
74.125.239.8 | talkgadget.l.google.com
74.125.239.14 | talkgadget.l.google.com
74.125.239.5 | talkgadget.l.google.com
74.125.239.2 | talkgadget.l.google.com
74.125.239.9 | talkgadget.l.google.com
183.111.25.156 | dbscthumb.phinf.naver.net.static.gscdn.net
175.158.10.166 | dbscthumb.phinf.naver.net.static.gscdn.net
175.158.10.169 | dbscthumb.phinf.naver.net.static.gscdn.net
98.136.223.87 | android-register-push.mobile.a01.yahoodns.net
66.196.116.134 | android-register-push.mobile.a01.yahoodns.net
74.125.129.188 | mobile-gtalk.l.google.com
23.7.192.107 | e5533.c.akamaiedge.net
180.70.134.40 | blog.daum.net
180.70.93.11 | blog.daum.net
144.122.144.179 | imap.metu.edu.tr
69.25.207.21 | 2.android.pool.ntp.org
129.174.93.11 | 2.android.pool.ntp.org
204.2.134.164 | 2.android.pool.ntp.org
75.128.168.8 | 2.android.pool.ntp.org
23.5.245.163 | e6845.ce.akamaiedge.net
67.215.253.139 | c.statcounter.com
67.215.253.140 | c.statcounter.com
216.59.38.124 | c.statcounter.com
216.59.38.123 | c.statcounter.com
74.125.28.95 | googleapis.l.google.com
74.125.129.108 | gmail-imap.l.google.com
74.125.129.109 | gmail-imap.l.google.com
199.59.148.20 | api.twitter.com
199.59.148.87 | api.twitter.com
199.59.149.232 | api.twitter.com
110.45.215.251 | img.search.daum-img.net
165.254.99.19 | a1294.w20.akamai.net
165.254.99.72 | a1294.w20.akamai.net
165.254.99.66 | a1294.w20.akamai.net
61.111.62.73 | editor.daum.net
211.110.65.17 | editor.daum.net
69.171.234.25 | star.c10r.facebook.com
199.27.77.133 | github.map.fastly.net
174.35.2.47 | s1.daumcdn.net.cdngc.net
174.35.2.131 | s1.daumcdn.net.cdngc.net
184.51.102.59 | a1294.w20.akamai.net
184.51.102.25 | a1294.w20.akamai.net
74.125.239.15 | ssl.gstatic.com
50.57.83.157 | mobidia.com
184.85.109.15 | e3191.c.akamaiedge.net.0.1.cn.akamaiedge.net
199.16.156.83 | syndication.twimg.com
199.16.156.21 | syndication.twimg.com
75.101.139.65 | www.mymotocast.com
75.101.130.186 | www.mymotocast.com
23.22.130.189 | www.mymotocast.com
50.16.141.187 | www.mymotocast.com
72.167.183.25 | officialswag.com
74.125.239.21 | googlemail.l.google.com
74.125.239.22 | googlemail.l.google.com
17.149.36.162 | 24.courier-push-apple.com.akadns.net
17.149.36.76 | 24.courier-push-apple.com.akadns.net
17.149.32.13 | 24.courier-push-apple.com.akadns.net
17.149.32.75 | 24.courier-push-apple.com.akadns.net
17.149.32.38 | 24.courier-push-apple.com.akadns.net
17.149.36.152 | 24.courier-push-apple.com.akadns.net
17.149.32.22 | 24.courier-push-apple.com.akadns.net
17.149.32.70 | 24.courier-push-apple.com.akadns.net
17.149.34.61 | 10.courier-sandbox-push-apple.com.akadns.net
17.149.34.63 | 10.courier-sandbox-push-apple.com.akadns.net
17.149.34.59 | 10.courier-sandbox-push-apple.com.akadns.net
17.149.34.57 | 10.courier-sandbox-push-apple.com.akadns.net
17.149.34.62 | 10.courier-sandbox-push-apple.com.akadns.net
17.172.232.113 | 9.courier-push-apple.com.akadns.net
17.172.232.132 | 9.courier-push-apple.com.akadns.net
17.172.232.201 | 9.courier-push-apple.com.akadns.net
17.172.232.142 | 9.courier-push-apple.com.akadns.net
17.172.232.161 | 9.courier-push-apple.com.akadns.net
17.172.232.170 | 9.courier-push-apple.com.akadns.net
17.172.232.166 | 9.courier-push-apple.com.akadns.net
17.172.232.149 | 9.courier-push-apple.com.akadns.net
184.25.222.161 | e4593.g.akamaiedge.net
69.147.92.223 | any-mg-hg.mail.am0.yahoodns.net
98.139.90.228 | any-mg-hg.mail.am0.yahoodns.net
98.137.151.93 | any-mg-hg.mail.am0.yahoodns.net
98.139.91.128 | any-mg-hg.mail.am0.yahoodns.net
109.168.119.166 | mail.cutaway.it
184.51.102.24 | a467.g.akamai.net
66.70.68.186 | rel.webcollage.net
74.125.239.10 | googlehosted.l.googleusercontent.com
74.125.239.11 | googlehosted.l.googleusercontent.com
74.125.239.12 | googlehosted.l.googleusercontent.com
98.136.164.61 | imap-ssl.mail.us.am0.yahoodns.net
98.138.24.49 | imap-ssl.mail.us.am0.yahoodns.net
98.136.218.38 | imap-ssl.mail.us.am0.yahoodns.net
98.138.215.4 | imap-ssl.mail.us.am0.yahoodns.net
98.138.24.48 | imap-ssl.mail.us.am0.yahoodns.net
98.138.31.75 | imap-ssl.mail.us.am0.yahoodns.net
98.139.212.64 | imap-ssl.mail.us.am0.yahoodns.net
98.139.172.225 | imap-ssl.mail.us.am0.yahoodns.net
74.217.75.8 | ads.flurry.com
69.171.235.48 | orcart.t.facebook.com
17.149.160.49 | apple.com
17.178.96.59 | apple.com
17.172.224.47 | apple.com
173.194.112.159 | id.l.google.com
173.194.112.151 | id.l.google.com
173.194.112.152 | id.l.google.com
198.47.115.222 | assetvalue.us
157.56.108.82 | bn1.skype.msnmessenger.msn.com.akadns.net
17.151.237.39 | p20-keyvalueservice.icloud.com.akadns.net
184.51.102.56 | a1420.g.akamai.net
72.21.215.165 | s3-1-w.amazonaws.com
72.21.211.188 | s3-1-w.amazonaws.com
184.51.102.51 | a336.g2.akamai.net
184.28.16.64 | a1877.w7.akamai.net
184.28.16.43 | a1877.w7.akamai.net
184.28.16.50 | a1586.w7.akamai.net
184.28.16.57 | a1586.w7.akamai.net
184.86.114.46 | e4478.b.akamaiedge.net
134.170.24.125 | BN1MSGR2011208.gateway.messenger.live.com
50.63.23.53 | shop.seemecnc.com
31.13.74.23 | scontent-b.xx.fbcdn.net
72.30.38.152 | calgate01.a02.yahoodns.net
98.138.73.131 | calgate01.a02.yahoodns.net
74.125.239.27 | dart.l.doubleclick.net
74.125.239.28 | dart.l.doubleclick.net
174.35.3.40 | m1.daumcdn.net.cdngc.net
174.35.3.19 | m1.daumcdn.net.cdngc.net
180.70.134.46 | go.g.daum.net
180.70.134.47 | go.g.daum.net
199.59.148.10 | twitter.com
199.59.149.198 | twitter.com
199.59.150.7 | twitter.com
50.63.49.1 | images.seemecnc.com
74.125.239.26 | pagead46.l.doubleclick.net
74.125.239.25 | pagead46.l.doubleclick.net
74.125.239.13 | pagead46.l.doubleclick.net
199.59.150.39 | twitter.com
69.94.102.13 | netjeff.com
173.255.243.189 | seclists.org
54.225.189.211 | flipboard.com
54.243.94.28 | pinterest.com
74.125.239.19 | www.google.com
74.125.239.17 | www.google.com
74.125.239.18 | www.google.com
74.125.239.20 | www.google.com
74.125.239.16 | www.google.com
198.143.187.51 | static.nrelate.anycastcdn.net
64.120.19.11 | static.nrelate.anycastcdn.net
173.234.185.147 | static.nrelate.anycastcdn.net
23.19.43.83 | static.nrelate.anycastcdn.net
173.252.110.27 | facebook.com
174.35.3.11 | g1.panthercdn.com
174.35.3.51 | g1.panthercdn.com
173.201.19.8 | seal.gd.where.secureserver.net
66.170.45.227 | seemecnc.org
50.17.218.118 | dropc.am
184.51.102.43 | a20.g.akamai.net
184.51.102.10 | a20.g.akamai.net
63.148.88.65 | imail.tenable.com
184.51.102.26 | a1015.g.akamai.net
184.85.108.55 | e2978.a.akamaiedge.net
69.46.82.69 | reprap.org
23.23.235.32 | themanual.com
173.241.250.7 | r.openx.net.akadns.net
98.138.253.109 | yahoo.com
98.139.183.24 | yahoo.com
206.190.36.45 | yahoo.com
184.25.222.85 | e4517.g.akamaiedge.net
165.254.30.169 | segs.btrll.com
50.63.202.13 | loboswag.com
68.67.151.166 | ib.adnxs.com
68.67.151.77 | ib.adnxs.com
68.67.151.147 | ib.adnxs.com
68.67.151.102 | ib.adnxs.com
68.67.151.161 | ib.adnxs.com
68.67.151.176 | ib.adnxs.com
68.67.151.47 | ib.adnxs.com
68.67.151.238 | ib.adnxs.com
173.194.79.125 | talk.l.google.com
138.108.6.20 | secure-us.imrworldwide.com
184.51.102.74 | a38.g.akamai.net
72.21.91.203 | cs170.wac.edgecastcdn.net
63.245.216.132 | addons.dynect.mozilla.net
184.51.102.66 | a1711.g.akamai.net
184.51.102.67 | a1711.g.akamai.net
199.7.52.72 | ocsp.verisign.net
184.28.16.10 | a1589.g1.akamai.net
184.25.220.74 | e4000.g.akamaiedge.net
98.138.49.42 | ds-any-world.ngd.ysm.yahoodns.net
98.138.49.43 | ds-any-world.ngd.ysm.yahoodns.net
216.39.55.12 | ds-any-world.ngd.ysm.yahoodns.net
216.39.55.13 | ds-any-world.ngd.ysm.yahoodns.net
184.28.16.27 | a1638.b.akamai.net
24.38.44.225 | www.worldnow.com
63.215.202.54 | tps.vclk.akadns.net
74.125.34.28 | ghs-svc-https-c28.ghs-ssl.googlehosted.com
23.7.195.53 | e6238.a.akamaiedge.net
50.97.214.162 | tags3.snv.bluekai.com
184.28.16.19 | a1796.g1.akamai.net
184.28.16.24 | a1796.g1.akamai.net
54.230.118.48 | d1ibts9hn2apvm.cloudfront.net
54.230.118.51 | d1ibts9hn2apvm.cloudfront.net
54.230.118.94 | d1ibts9hn2apvm.cloudfront.net
54.230.118.242 | d1ibts9hn2apvm.cloudfront.net
54.239.132.40 | d1ibts9hn2apvm.cloudfront.net
54.230.119.96 | d1ibts9hn2apvm.cloudfront.net
54.230.116.166 | d1ibts9hn2apvm.cloudfront.net
54.230.116.48 | d1ibts9hn2apvm.cloudfront.net
199.127.204.124 | pl.ha1.yumenetworks.com
199.127.204.121 | pl.ha1.yumenetworks.com
199.127.204.122 | pl.ha1.yumenetworks.com
199.127.204.123 | pl.ha1.yumenetworks.com
184.51.102.90 | a1949.g.akamai.net
184.51.102.18 | a1949.g.akamai.net
207.47.45.10 | mail.zscaler.com
93.184.216.139 | cs107.wac.edgecastcdn.net
23.38.207.139 | e3821.dspe1.akamaiedge.net
184.25.118.239 | e5168.g.akamaiedge.net
61.111.62.65 | track.tiara.g.daum.net
61.111.62.175 | track.tiara.g.daum.net
209.128.96.248 | event.nextissue.com
64.70.58.115 | www.investopedia.com
54.243.33.202 | dl.dropboxusercontent.com
173.194.8.238 | r9.sn-a5m7lner.c.youtube.com
68.71.212.183 | sports.espn.wip.go.com
205.210.186.236 | inw-ad-lb4.rfihub.com
205.210.186.241 | inw-317.inw-rtb1.rfihub.net
184.25.118.66 | e4995.g.akamaiedge.net
4.28.136.36 | dnl-01.geo.kaspersky.com
69.194.34.73 | www.gravity.com.akadns.net
184.51.102.42 | a1697.g.akamai.net
184.51.102.73 | a1697.g.akamai.net
68.71.216.166 | feeds.espn.wip.go.com
216.10.120.7 | basewww.wlb.burstnet.akadns.net
17.158.10.46 | p03-keyvalueservice.icloud.com.akadns.net
17.158.10.25 | p03-keyvalueservice.icloud.com.akadns.net
132.245.156.22 | gruprd8011.outlook.com
184.31.147.153 | e6338.g.akamaiedge.net
31.13.74.7 | scontent-a.xx.fbcdn.net
74.3.161.45 | api.nrelate.com
23.67.247.17 | a1990.dspmm1.akamai.net
23.67.247.10 | a1990.dspmm1.akamai.net
23.67.247.66 | a1861.dspmm1.akamai.net
23.67.247.218 | a1861.dspmm1.akamai.net
173.241.250.99 | ox30ssl-bid.d.xx.openx.com.akadns.net
184.85.102.233 | e1665.b.akamaiedge.net
184.51.102.41 | a749.dsw4.akamai.net
184.106.34.117 | draftstreet.com
23.38.194.110 | e566.dspe1.akamaiedge.net
184.51.102.9 | a1891.g.akamai.net
184.51.102.58 | a1891.g.akamai.net
64.93.77.200 | knoworthy.com
74.125.224.244 | www.google.com
74.125.224.243 | www.google.com
74.125.224.241 | www.google.com
74.125.224.240 | www.google.com
74.125.224.242 | www.google.com
66.235.139.153 | espn.112.2o7.net
66.235.132.121 | espn.112.2o7.net
66.235.132.152 | espn.112.2o7.net
66.235.138.19 | espn.112.2o7.net
66.235.139.110 | espn.112.2o7.net
66.235.138.2 | espn.112.2o7.net
66.235.132.118 | espn.112.2o7.net
66.235.138.18 | espn.112.2o7.net
66.235.139.152 | espn.112.2o7.net
66.235.133.14 | espn.112.2o7.net
66.235.133.62 | espn.112.2o7.net
66.235.139.180 | espn.112.2o7.net
66.235.138.59 | espn.112.2o7.net
66.235.133.11 | espn.112.2o7.net
66.235.133.33 | espn.112.2o7.net
66.235.139.121 | espn.112.2o7.net
66.235.138.44 | espn.112.2o7.net
66.235.139.166 | espn.112.2o7.net
66.235.132.232 | espn.112.2o7.net
66.235.139.118 | espn.112.2o7.net
65.254.248.177 | www.simplethriftyliving.com
184.154.208.133 | smartlifeweekly.com
93.184.216.169 | gs1.wac.v4cdn.net
184.28.16.16 | a1507.w7.akamai.net
184.28.16.51 | a1507.w7.akamai.net
70.40.207.68 | the3dprinterexperience.com
2.19.141.15 | e3191.dscc.akamaiedge.net
17.149.36.198 | 1.courier-push-apple.com.akadns.net
17.149.36.213 | 1.courier-push-apple.com.akadns.net
17.149.36.169 | 1.courier-push-apple.com.akadns.net
17.149.32.21 | 1.courier-push-apple.com.akadns.net
17.149.36.108 | 1.courier-push-apple.com.akadns.net
17.149.32.10 | 1.courier-push-apple.com.akadns.net
17.149.37.20 | 1.courier-push-apple.com.akadns.net
17.149.32.15 | 1.courier-push-apple.com.akadns.net
184.28.16.58 | a26.d.akamai.net
184.28.16.42 | a26.d.akamai.net
184.51.102.27 | a1531.dsw4.akamai.net
184.51.102.50 | a1531.dsw4.akamai.net
184.51.102.64 | a1531.dsw4.akamai.net
23.67.247.18 | a1005.dspw42.akamai.net
23.67.247.74 | a1007.dspw43.akamai.net
23.67.247.67 | a1007.dspw43.akamai.net
69.194.244.11 | r.turn.com.akadns.net
69.194.244.20 | d.audienceiq.com.turn.com.akadns.net
184.51.102.89 | a1961.g.akamai.net
68.67.151.106 | lax1.ib.adnxs.com
68.67.151.135 | lax1.ib.adnxs.com
68.67.151.232 | lax1.ib.adnxs.com
68.67.151.158 | lax1.ib.adnxs.com
68.67.151.137 | lax1.ib.adnxs.com
68.67.151.155 | lax1.ib.adnxs.com
68.67.151.152 | lax1.ib.adnxs.com
184.31.146.127 | e6059.g.akamaiedge.net
67.202.66.200 | ic.tynt.com
67.202.66.179 | de.tynt.com
115.71.236.30 | apollo89.com
50.16.209.140 | ping.chartbeat.net
184.73.175.201 | ping.chartbeat.net
54.243.145.253 | ping.chartbeat.net
184.51.102.19 | a1168.dsw4.akamai.net
184.51.102.72 | a1168.dsw4.akamai.net
184.51.102.88 | a1168.dsw4.akamai.net
184.51.102.83 | a1168.dsw4.akamai.net
23.67.247.9 | a1791.dspmm1.akamai.net
23.67.247.210 | a1791.dspmm1.akamai.net
54.208.24.65 | d.appsdt.com
54.208.24.49 | d.appsdt.com
119.235.235.91 | gw.line.naver.jp
119.235.235.110 | gw.line.naver.jp
54.225.214.31 | api.shopkeepapp.com
54.235.66.48 | api.shopkeepapp.com
72.21.92.81 | cs61.adn.edgecastcdn.net
213.71.30.150 | www.ospserver.net
204.154.94.81 | www.evernote.com
20. Most popular protocols obtained by selecting all the packets (*Edit > Mark All Displayed Packets*)
      and then selecting *Statistics > Protocol Hierarchy Statistics...*:
      | # | Protocol | % by packets | % by bytes |
      | 1 | FTP-DATA  | 11.45% | 19% |
      | 2 | HTTP | 8.78% | 13.25% |
      | 3 | SSL | 7.39% | 8.01% |
      Wireshark reported a dummy protocol called DATA which technically should appear 3rd in the ranking.
      However, filtering the packets for DATA actually only shows mostly TCP/UDP/HTTP packets carrying
      raw data, so this is clearly just an abstract "protocol" that serves to provide extra statistics. 
22. 10.0.0.24 to 10.142.15.123/10.142.15.123 over FTP
'pretty-face-biometrics-smartcard-tokens_125.pdf' (436288 bytes)
'/Upload Here/text/Corporate/SANS_White_Papers/authentication/single-sign-password-synchronization_140.pdf'
'/Upload Here/text/Corporate/SANS_White_Papers/authentication/smart-cards-secure-they_131.pdf' (219694 bytes)
'/Upload Here/text/Corporate/SANS_White_Papers/authentication/technical-aspect-implementing-upgrading-sap-security-46_119.pdf' (284076 bytes)
'/Upload Here/text/Corporate/SANS_White_Papers/authentication/two-factor-authentication-choose-one_33093.pdf' (1343577 bytes)
'overview-s-key-usage-openbsd_100.pdf' (136688 bytes)
'overview-authentication-methods-protocols_118.pdf' (272907 bytes)
'/Upload Here/text/Corporate/SANS_White_Papers/authentication/web-single-sign-on-meets-business-reality_130.pdf' (372286 bytes)
'/Upload Here/text/Corporate/SANS_White_Papers/backup/centralized-backups_513.pdf' (106581 bytes)
'/Upload Here/text/Corporate/SANS_White_Papers/backup/electronic-data-retention-policy_514.pdf' (103635 bytes)
'/Upload Here/text/Corporate/SANS_White_Papers/backup/fibre-channel-storage-area-networks-analysis-security-perspective_32913.pdf' (6769999 bytes)
'os-application-fingerprinting-techniques_32923.pdf' (964667 bytes)
'/Upload Here/text/Corporate/SANS_White_Papers/backup/online-backup-worth-risk_33363.pdf' (696532 bytes)
'/Upload Here/text/Corporate/SANS_White_Papers/backup/security-considerations-enterprise-level-backups_515.pdf' (97032 bytes)
'/Upload Here/text/Corporate/SANS_White_Papers/backup/veritas-volume-manager-storage-area-network_1598.pdf' (1268756 bytes)