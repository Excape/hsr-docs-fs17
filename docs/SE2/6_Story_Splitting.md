# Story Splitting

## Grosse Projekte aufteilen
- Wenn Projekt zu gross wird, gestaffelt Teile des Ganzen liefern
- Aufteilung nach Kundendomäne: Zuerst nur eine Teildomäne des Kunden realisieren
- Aufteilung nach Prozessen: Ein Prozess kann meist gut in UCs übertragen werden. Diese können nacheinander ausgeliefert werden
    - Kernfunktionalität zuerts implementieren, CRUD erst später, da diese gut gefaked werden können
- Aufteilung nach Rollen: Rollen werden priorisiert und nach dieser Reihenfolge auch die UCs
- Aufteilung nach Domain Modell: Gruppieren und priorisieren
- Geografisch aufteilen: Zuerst in kleinem Rahmen austeilen, dann für stetig grösseren

## Grosse Arbeitspakete aufteilen
- Zuerst primitive Version implementieren, dann Schritt für Schritt "vergolden"
- In einem Sprint ist ca. 60%-70% der Arbeitszeit produktiv
- Daher ideale Grösse: 50%-70% pro Arbeitspaket, damit eine Person in einem Sprint sicher fertig wird
- Epics sind ungefähr UCs, die aufgeteilt werden in User Stories (= Arbeitspakete)
- User Stories sind ursprünglich von der Form "as a .. I want to ...", aber das ist kundenorientiert
    - In der Implementierung braucht es anwendungsorientierte User Stories (=Arbeitspakete)
