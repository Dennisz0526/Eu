# 🛗 Elevator Survival Game (NETERMINAT)

Un joc de strategie și supraviețuire dezvoltat în **Godot Engine 4** (GDScript), în care ești blocat într-un lift dintr-o clădire plină de vecini bizari. Scopul tău? Să urci cât mai multe etaje gestionându-ți cu atenție resursele, statusurile și deciziile sub presiune.

---

## 🎮 Mecanici de Joc (Gameplay)

Jocul se bazează pe alegeri textuale și managementul a 4 resurse principale, plafonate între `0` și `100`:
*   **HP (Viață):** Dacă scade la 0, ai pierdut.
*   **Cash (Bani):** Moneda de schimb pentru a cumpăra obiecte salvatoare.
*   **Swag (Reputație):** Folosit ca monedă sau influență în fața anumitor NPC-uri.
*   **IQ (Inteligență):** Te ajută să treci cu bine de pericole sau să rezolvi situații tensionate.

### 🎭 Sistemul de NPC-uri (Vecini)
La fiecare etaj nou, ușile liftului se deschid și un personaj generat procedural (folosind un istoric inteligent anti-repetiție) interacționează cu tine:
*   **Karen:** Îți cere imperios să cobori. O poți înfrunta dacă ai destul *Swag* (care se va consuma) sau poți risca la noroc. Dacă eșuezi, ea blochează ușa cu piciorul și te trimite și mai jos!
*   **Vânzătorul (Merchant):** Îți vinde obiecte utile (*Cărți, Pastile, Ochelari de soare* sau *Acadele*). Este un comerciant cinstit: dacă statusul tău este deja maxim (100), îți va refuza banii politicos.
*   **Curierul (Courier):** Are nevoie de ajutor să schimbe etajele (fără să poată coborî sub etajul 0). Îți oferă pachete cu recompense random.
*   **Femeia de serviciu (Janitor):** Te avertizează că podeaua e umedă. Ai nevoie de un anumit nivel de *IQ* (Need) ca să o ajuți fără să aluneci și să pierzi HP.
*   **Fantoma (Ghost):** Îți testează tăria de caracter. Dacă ai *IQ* mare, o privești în ochi și câștigi *Swag*, altfel riști să te sperii și să te lovești la cap.
*   **Copilul (Kid):** Vrea să apese toate butoanele! Îi poți consuma din *IQ* ca să îl calmezi, îi poți da o **Acadea** cumpărată de la Vânzător pentru a urca un etaj, sau îl lași să își facă capriciul și te va trimite înapoi între 1 și 3 etaje.

### 🎲 Sistemul Stat Checks & RNG (Hibrid)
Jocul folosește o mecanică echilibrată de risc:
*   **Need / Cost:** Dacă ai statusurile necesare, ai **100% șanse de succes**. Unele opțiuni doar verifică nivelul (*Need*), altele îl consumă drept monedă de schimb (*Cost*).
*   **Plasa de siguranță (RNG):** Dacă nu ai punctele necesare, butonul NU se blochează! Jocul îți oferă o șansă bazată pe noroc (ex: 50% șanse de reușită), oferind momente tensionate de „totul sau nimic”.

---
