Cílem projektu je vytvoření aplikace, která vyhledá v databázi DNA sekvencí takové sekvence, které jsou 
podobné vstupní DNA sekvenci. Je třeba implementovat podobnost pomocí tzv. globálního i lokálního 
zarovnání.

VSTUP
DNA sekvence (řetězec).

VÝSTUP
Množina databázových sekvencí podobných vstupní sekvenci setříděných podle podobnosti. Navíc je třeba 
vizualizovat nukleotidy, na kterých se vstup shoduje s DNA (zarovnání).

INFORMACE/POTŘEBNÉ ZNALOSTI
Molekula DNA (deoxyribonukleová kyselina) je tvořena 4 typy nukleotidů – adenin (A), guanin (G), cytosin (C), 
thymin (T). DNA lze tedy chápat na úrovni její sekvence jako řetězec nad abecedou o velikosti 4 písmen (ACGT). 
Lze tedy aplikovat podobnostní algoritmy navržené primárně pro podobnost klasických řetězců založených na 
zarovnání. Jednou ze základních metod v této oblasti je algoritmus pro výpočet editační vzdálenosti. Editační 
vzdálenost dvou řetězců je definována jako minimální počet editačních operací nutných pro konverzi jednoho 
řetězce do druhého. Editační operace zahrnuje přidání písmene do jednoho z řetězců, odebrání písmene 
z jednoho z řetězců nebo modifikace (záměna) písmene. Lze tedy podobnost DNA sekvencí ztotožnit s klasickou 
editační vzdáleností. Takové vzdálenosti říkáme globální zarovnání. Lze si ovšem představit, že 2 DNA sekvence 
si můžou být významně podobné na některém ze svých podřetězců, ale globálně příliš podobné být nemusí. 
Tento případ může být nicméně zajímavý z biologického hlediska, a proto lze uvažovat podobnost sekvencí jako 
editační vzdálenost takovýchto lokálních úseků. Takové vzdálenosti říkáme lokální zarovnání.
Jak lokální, tak globální zarovnání jsou založeny na dynamickém programování s O(n^2) složitostí. Implementaci 

těchto algoritmů v bioinformatice jsou známy jako Needleman-Wunschův (globální) algoritmus a SmithWatermanův
(lokální) algoritmus. Tyto algoritmy jsou uváděny často v souvislosti s proteinovými sekvencemi, 
ale jsou takřka beze změny aplikovatelné i na oblast vyhledávání v databázích nukleotidových sekvencí
