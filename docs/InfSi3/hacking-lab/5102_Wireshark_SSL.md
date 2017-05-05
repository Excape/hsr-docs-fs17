## 5102 Wireshark Decode SSL Traffic
- CNC Server dient als Proxy des Opfers
- Opfer schickt messages an CNC mit base64-encodeten messages, im Dump username + password
- Opfer geht auf yahoo.com
- Das Login wird vom Proxy höchst wahrscheinlich durchgeleitet
- Die folgenden Requests nach dem Login gehen aber nicht mehr über HTTPS, der Browser des Opfers schickt jeweils das Session-Cookie mit, das nun der Angreifer problemlos auslesen und selbst benutzen kann
