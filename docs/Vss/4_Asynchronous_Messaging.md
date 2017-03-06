# Asynchronous Messaging

## Ziel
- Lose Kopplung zum Austausch von Nachrichten auf unterschiedlichen Plattformen in unterschiedlichen Formaten
- Skalierbarkeit, Fehlertoleranz, Erweiterbarkeit
- Viele Design-Entscheidungen, z.B. QoS Eigenschaften

## Einführung Messaging
- Eine Message besteht aus Message Descriptor und Message Data
- Der Queue Manager ist verantwortlich für das Versenden und Empfangen von Nachrichten
- Bei Asynchronous RPC antwortet der Server zwei Mal
    - Das erste Mal als Bestätigung der Ausführung (Accept Request)
    - Das zweite Mal mit dem Resultat

## Messaging Middleware
- z.B. IBM MQ, Microsoft MQ, ActiveMQ (Apache)

## Java Message Service (JMS) API
- Grundlegende MOM API
    - `Put`: Append a message to the queue
    - `Get`: Block until queue ist not empty, then remove first message
    - `Poll`: Remove first entry if queue is not empty, never block
    - `Notify`: Install a handler to be notified when a message is put into the queue
- [Message Reliability Levels](https://www.ibm.com/support/knowledgecenter/SSAW57_7.0.0/com.ibm.websphere.nd.doc/info/ae/ae/cjj9000_.html)
- Eine JMS Message besteht aus Header, Properties und Body
    - Properties sind Erweiterungen des Standard-headers und optional

### Beispiel Queue Sender (Message Producer)
```java
Connection connection = connectionFactory.createConnection();
connection.start();
Session session = connection.createSession(mp.transacted,
    Session.AUTO_ACKNOWLEDGE);
Destination destination = session.createQueue("testQueue");
MessageProducer producer = session.createProducer(destination);
producer.setDeliveryMode(DeliveryMode.PERSISTENT);
TextMessage message = session.createTextMessage("hello");
producer.send(message);
producer.close();
session.close();
connection.close();
```

### Beispiel Queue Receiver (Message Consumer)
```java
Connection connection = connectionFactory.createConnection();
connection.start();
Session session = connection.createSession(mc.transacted,
    Session.AUTO_ACKNOWLEDGE);
Destination destination = session.createQueue("testQueue");
MessageConsumer consumer = session.createConsumer(destination);
TextMessage text=(TextMessage) consumer.receive();
consumer.close(); 
session.close();
connection.close();

```

## Enterprise Integration Patterns

### Point-to-Point Messaging Pattern
- Simpelste Form, ein Sender schickt einem Receiver über einen beliebigen Channel eine Message
- Meist wird eine *Message Expiration* gesetzt. Ist diese abgelaufen, wenn der Receiver die Message erhält, wird sie verworfen oder an einen "Dead Letter Channel" geschickt
- *Command Message Pattern*: Message, die dem Receiver mitteilt, etwas auszuführen
- *Document Message Pattern*: Reine Daten-Übertragung
 
## Public-Subscribe Pattern
- Der Publisher (Sender) schickt die Messages an einen *Publish-Subscribe-Channel*
- Der Channel schickt eine Kopie der Message an einen Output Channel
- Jeder Output-Channel hat genau 1 Subscriber
- Jeder Subscriber erhält die Nachricht 1 Mal

- *Topic-based*: Subscriber melden sich an verschiedenen "topics" an (logische Channels) und erhalten nur die Nachrichten, die zu diesen Topics geschickt werden
- *Content-based*: Der Subscriber definiert Eigenschaften der Messages, die er bekommen möchte. Er erhält dann nur die Nachrichten, die dem entspechen

- Meistens gibt es zwischen Publisher und Subscriber einen Message Broker, der die Messages entgegennimmt und Subscribers verwaltet

### Receiving Message Endpoint Pattern
- *Competing Customers*: Mehrere Receiver verarbeiten messages gleichzeitig
- *Selective Customer*: Der Receiver entscheided beim Ankommen der Message anhand von Kriterien, ob die Message verarbeitet werden soll
## RabbitMQ
- Routing: Messages werden Anhand von Eigenschaften an den entsprechenden Receiver zugestellt
- RPC: Beim Request gibt der Client eine Callback Queue an (`reply_to`) und eine eindeutige ID. So wird beim Callback die Response dem Request zugeordnet
