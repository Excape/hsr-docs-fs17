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
- Wird es in die DB eingefügt `persist()`, ist es *managed* und somit im Persistence-Context
- Wird die Verbindung geschlossen (`close()`) oder removed, sind die Objekte wieder *unmanaged*
