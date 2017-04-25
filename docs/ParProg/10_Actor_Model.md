# Actor Model

- Objekte sind in diesem Paradigma "aktiv"
- Aktive Objekte haben ein nebenläufiges Innenleben
- Alle aktiven Objekte (=Actors) laufen nebenläufig
- Kommunikation über Nachrichtenaustausch
    - Erlaubt auch einfache Verteilung
- Kein shared memory zwischen den Objekten


## Akka
- JVM-Implementierung vom Actor Model
- In einem Actor werden Nachrichten immer sequentiell abgearbeitet - keine Synchronisation nötig
- Nachrichten sind beliebige Objekte
    - Java kennt nur "untyped" Actors, messages sind immer Typ `object`
- `ActorRef` ist eine Adresse eines Actors
    - Referenz bleibt dieselbe, auch wenn der Actor crashed und neu erstellt wird

### Actor Hierarchies
- Wenn ein Actor weitere Actors erstellt, ist er "parent" davon und zuständig
- Broadcast-Messsages über ActorSelectors
