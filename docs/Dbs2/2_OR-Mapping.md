# OR Mapping
Ziel: Gap zwischen Objektmodell der Applikation und (meist) relationales Modell der Datenbanken überwinden

## Java Persistence API (JPA)
- JPA ist ein Layer zwischen JDBC und dem Programm
- JPA ist nur eine Definition, implementiert von Providern
- Hier wird die EclipseLink-Implementierung verwendet (Hibernate wäre ein anderer Provider)

### Entities
- Entities sind POJO's mit ID-Feld für PK mit default-Konstruktor
- Dürfen nicht final sein (wegen z.B. lazy-loading)
- Abbildung in DB über Annotations oder sepparates XML-File
- Annotation `@Entity` für Klasse, `@Id` für PK-Feld

#### Beispiel
```java
@Entity
public class BankCustomer {
    @Id
    private long id;
    
    public long getId() {
        return id;
    }
    private String name;
    public String getName() {
        return name;
    }
    public void setName(String name) {
        this.name = name;
    }
}
```

### persistence.xml
```xml
<persistence xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance"
    xsi:schemaLocation="http://java.sun.com/xml/ns/persistence
        http://java.sun.com/xml/ns/persistence/persistence_2_0.xsd"
    version="2.0" xmlns="http://java.sun.com/xml/ns/persistence">
<persistence-unit name="Bank" transaction-type="RESOURCE_LOCAL">
    <provider>org.eclipse.persistence.jpa.PersistenceProvider</provider>
    <exclude-unlisted-classes>false</exclude-unlisted-classes>
        <properties>
            <property name="javax.persistence.jdbc.driver"
                value="org.postgresql.Driver"/>
            <property name="javax.persistence.jdbc.url"
                value="jdbc:postgresql:jpatest"/>
            <property name="javax.persistence.jdbc.user" value="test"/>
            <property name="javax.persistence.jdbc.password" value="test"/>
            <property name="eclipselink.target-database" value="PostgreSQL"/>
        </properties>
    </persistence-unit>
</persistence>
```

### Entities CRUD
```java
// SELECT
EntityManagerFactory factory =
    Persistence.createEntityManagerFactory("Bank");
EntityManager em = factory.createEntityManager();
Query query = em.createQuery("SELECT a FROM BankAccount a");
List<BankAccount> list = query.getResultList();
for (BankAccount account : list) {
    System.out.println(account);
}
em.close(); // besser mit try-with-ressources

// INSERT
em.getTransaction().begin();
BankCustomer customer = new BankCustomer();
customer.setName("Bill");
em.persist(customer); // INSERT and SELECT, customer hat jetzt seine ID
em.getTransaction().commit();
em.close();

// UPDATE
em.getTransaction().begin();
BankAccount account = em.find(BankAccount.class, 1L);
account.incBalance(100);
em.getTransaction().commit();

// DELETE
// nicht effizient, Java-Object wird erst durch GC aufgeräumt
em.getTransaction().begin();
BankAccount account = em.find(BankAccount.class, 1L);
em.remove(account);
em.getTransaction().commit();
```

### Table Mapping
```java
@Entity
@Table(name = "account")
public class BankAccount {
    @Id
    @Column(name = "accountid")
    private long id;
    
    private double balance; // 1:1 Mapping
    
    @Column(name = "description")
    private String explanation;
    
    @Column(name=“ssn“, unique=true, nullable=true)
    private long ssn;
    
    @Column(name=“l_name“, length=200)
    private String lastName;
    
    //Zusatzinfo, wird als TIMESTAMP abgelegt
    @Temporal(TemporalType.TIMESTAMP) 
    private Calendar creationDate;
    
    @Transient // wird nicht gemapped
    private String tempComments;
    // getter und setter
}
```
- Weitere Attribute: `scale`, `precision`

### Relationen
```java
// 1:1 Mapping
@Entity
@Table(name = "bankcustomer")
public class BankCustomer {
    @OneToOne(optional = true)
    @JoinColumn(name = "addressref")
    private Address address;
    // ...
}

// Bidirectional 1:1 mapping, Datenbank bleibt gleich
@Entity
public class Address {
    @OneToOne(mappedBy = "address")
    private BankCustomer customer;
    // ...
}

// N:1 Mapping
class BankAccount {
    @ManyToOne(optional = false)
    @JoinColumn(name = "customerref")
    private BankCustomer customer;
    //...
}

// Bidirectional N:1 
class BankCustomer {
    @OneToMany(mappedBy = "customer")
    private Collection<BankAccount> accounts; // = ...
    // ...
}
// N:M maping
class BankManager {
    @ManyToMany
    @JoinTable(name = "customer_manager",
        joinColumns = {@JoinColumn(name = "managerref")},
        inverseJoinColumns = {@JoinColumn(name = "customerref")})
    private Collection<BankCustomer> customers; // = ...
}
```
- Bei bidirektionalen Beziehungen müssen beide Seiten manuell gesetzt werden (im Gegensatz zu z.B. EF)
    - Im Beispiel muss beim Hinzufügen eines `BankAccount` dieser der Liste in der `BankCustomer` hinzugefügt werden
- Lazy-Loading ist per default aktiviert für 1:n und n:m
    - Bsp: Wenn `BankCustomer` geladen werden, wird die `BankAccounts`-Liste lazy mit `customer.getAccounts()` geladen
- Eager-Loading standard bei 1:1 und n:1
- Explizit angeben mit z.B. `@ManyToMany(fetch = FetchType.EAGER)`

### Persistence-Context
- Ein Objekt ist neu erstellt erstmal *unmanaged*
- Wird es in die DB eingefügt mit `persist()`, ist es *managed* und somit im Persistence-Context (Objekt hat eine Id)
- Wird die Verbindung geschlossen (`close()`) oder removed, sind die Objekte wieder *unmanaged*
- Persistence-Kontext verwaltet einen Cache - Bei mehrmaliger Abfrage der gleichen Objekte werden sie aus dem Cache geladen
    - Wichtig, sonst könnte es mehrere Java-Instanzen für ein DB-Objekt geben 
        - So gibt es in einem Kontext für ein DB-Objekt genau eine Java Instanz  (Identity Map Pattern)
- Geänderte Werte im Persistence-Kontext werden beim Transaction-Commit auf der DB gespeichert (Unit of Work Pattern)

```java
EntityManager em = emf.createEntityManager();
BankCustomer c1 = em.find(BankCustomer.class, 1L);
BankCustomer c2 = em.find(BankCustomer.class, 1L);
assert(c1 == c2); // gleicher PC
EntityManager em1 = emf.createEntityManager();
c2 = em1.find(BankCustomer.class, 1L);
assert(c1 != c2); // unterschiedlicher PC
```

### Entity Identität
- Annotation `@Id`
- `@GeneratedValue` - generierte ID mit 4 Möglichkeiten

#### Typ Identity
```java
@Id
@GeneratedValue(strategy = GenerationType.IDENTITY)
private long accountId;
```
- Wird abgebildet in `SERIAL`

### Typ Sequence
```java
Id
@GeneratedValue(strategy = GenerationType.SEQUENCE,
    generator = "BankCustGen")
@SequenceGenerator(name = "BankCustGen",
    sequenceName = "CustomerIdSeq",
    allocationSize=1)
private long customerId;
```

#### Typ Table
!!! note
    todo
    
### Transitive Persistenz
- Von Persistente Objekte erreichbaren Objekte sollten auch persistent sein

### Inkonsistente Bidirektionalität
- In JPA werden bidirektionale Relationen nicht in beide Richtungen automatisch gesetzt
- Muss von Hand gemacht werden

### Transaktionen
```java
EntityManager em = factory.createEntityManager();
em.getTransaction().begin();
// ...
// do something... make changes
// ...
em.getTransaction().commit(); // or rollback()
```
- Isolation Level ist per default Read-Commited
    - Nur Daten lesen, die eine andere Transaktion commited hat

### Optimistic Concurrency
- Beim Commit einer Transaktion wird nach Konflikten geprüft
- Wenn Konflikt entstand, wird ein Rollback gemacht

#### Versions-Feld
- Mit jedem Update Feld hochzählen
- Beim Schreiben prüfen, ob das Feld gleich ist wie der Wert, der vorher gelesen wurde
- Wenn Feld anders, hat jemand in der Zwischenzeit den Record verändert -> Rollback

``` sql
UPDATE User SET ..., version = version + 1
WHERE id = ? AND version = readVersion
```
- JPA wirft bei Verletzung eine `ConcurrencyLockException`

### Entity Locking
- `em.lock()`
- OPTIMISTIC_FORCE_INCREMENT: Beim lock direkt direkt das Versions-Feld erhöhen, damit andere keine Commits mehr darauf machen kann, der vorher gelesen hat

### Detached Entities
- Oft möchte man DB-Objekte "detachen" (Db-Context schliessen), verändern, und dann wieder in die DB schreiben
- Mit `entityManger.merge(object)` wird ein wieder in den Persistenz-Kontext geladen, dass wieder commited werden kann

### Inheritance Mapping
#### Single Table Mapping (Table per Hierarchy)
```java
@Entity
@Inheritance(strategy = InheritanceType.SINGLE_TABLE)
@DiscriminatorColumn(name = "type")
public abstract class BankCustomer {
    @Id private String name;
}

@Entity
@DiscriminatorValue("Retail")
public class RetailBankCustomer extends BankCustomer {
    private int fees;
}
@Entity
@DiscriminatorValue("Private")
public class PrivateBankCustomer extends BankCustomer {
    private String eliteOffer;
}
```
- Das Feld "type" ist hier diskriminator und wird in der DB verwendet, um die verschiedenen `BankCustomer` zu unterscheiden

#### Joined Table Mapping

#### Table per Class Mapping

### Abfragen mit JPQL
- Sprache analog zu SQL...
- , aber operiert auf Entity Model, nicht DB-Model!
- Es können z.B. "Navigation Attributes" verwendet werden
- "Prepared Statements" mit Named Parameters

```java
Query query = em.createQuery(
    "SELECT c FROM BankCustomer c WHERE c.name LIKE :customerName"
);
query.setParameter("customerName", name);
query.setMaxResults(1000);
List<BankCustomer> list = query.getResultList();
```

#### Named Queries

#### Criteria API
