-- -----------------------------------------
-- Sukuriame DB struktūrą
-- -----------------------------------------

-- ištrinama duomenų bazė, jei egzistuoja
DROP DATABASE IF EXISTS fe_autonuoma;

-- sukuriama nauja duomenų bazė
CREATE DATABASE IF NOT EXISTS fe_autonuoma CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;

-- Pasirenkama DB
USE fe_autonuoma;

-- lentele rajonas
DROP TABLE IF EXISTS rajonas;

CREATE TABLE rajonas (
	id SMALLINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
	salies_kodas CHAR(2) NOT NULL,
    pavadinimas VARCHAR(50) NOT NULL
);

-- lentelė salis
DROP TABLE IF EXISTS salis;

CREATE TABLE salis (
	kodas CHAR(2) PRIMARY KEY,
    pavadinimas VARCHAR(50) NOT NULL
);

-- pridedamas išorinis raktas į rajonas lentelę
ALTER TABLE rajonas
ADD FOREIGN KEY (salies_kodas) REFERENCES salis(kodas);

-- lentelė miestas
DROP TABLE IF EXISTS miestas;

CREATE TABLE miestas (
	id SMALLINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
	rajono_id SMALLINT UNSIGNED NOT NULL,
    pavadinimas VARCHAR(50) NOT NULL,
    FOREIGN KEY (rajono_id) REFERENCES rajonas(id)
);

-- lentelė klientas
DROP TABLE IF EXISTS klientas;

CREATE TABLE klientas (
	id SMALLINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
	miesto_id SMALLINT UNSIGNED NOT NULL,
    vardas VARCHAR(50) NOT NULL,
    pavarde VARCHAR(50) NOT NULL,
    asmens_kodas VARCHAR(20) NOT NULL,
    el_pastas VARCHAR(50),
    adresas VARCHAR(100) NOT NULL,
    FOREIGN KEY (miesto_id) REFERENCES miestas(id)
);

-- lentelė kliento telefonas
DROP TABLE IF EXISTS telefonas;

CREATE TABLE telefonas (
	id SMALLINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
	kliento_id SMALLINT UNSIGNED NOT NULL,
    numeris VARCHAR(20) NOT NULL,
    FOREIGN KEY (kliento_id) REFERENCES klientas(id)
);

-- lentelė darbuotojų pareigoms
DROP TABLE IF EXISTS pareiga;

CREATE TABLE pareiga (
	id TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    pavadinimas VARCHAR(50) NOT NULL
);

-- lentelė darbuotojas
DROP TABLE IF EXISTS darbuotojas;

CREATE TABLE darbuotojas (
	id SMALLINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
	miesto_id SMALLINT UNSIGNED NOT NULL,
	pareigos_id TINYINT UNSIGNED NOT NULL,
    vardas VARCHAR(50) NOT NULL,
    pavarde VARCHAR(50) NOT NULL,
    asmens_kodas VARCHAR(20) NOT NULL,
    el_pastas VARCHAR(50),
    slaptazodis VARCHAR(100) NOT NULL,
    adresas VARCHAR(100),
    telefonas VARCHAR(20) NOT NULL,
    gimimo_data DATE NOT NULL,
    nedirba TINYINT UNSIGNED NOT NULL DEFAULT 0,
    FOREIGN KEY (miesto_id) REFERENCES miestas(id),
    FOREIGN KEY (pareigos_id) REFERENCES pareiga(id)
);


-- lentelė atsiliepimai apie klientus
DROP TABLE IF EXISTS atsiliepimas;

CREATE TABLE atsiliepimas (
	id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
	kliento_id SMALLINT UNSIGNED NOT NULL,
	darbuotojo_id SMALLINT UNSIGNED NOT NULL,
    tekstas TEXT NOT NULL,
    data_laikas DATETIME NOT NULL DEFAULT current_timestamp(),
    FOREIGN KEY (kliento_id) REFERENCES klientas(id),
    FOREIGN KEY (darbuotojo_id) REFERENCES darbuotojas(id)
);


-- lentelė atuomobilių tipams
DROP TABLE IF EXISTS automobilioTipas;

CREATE TABLE automobilioTipas (
	id TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    pavadinimas VARCHAR(50) NOT NULL
);

-- lentelė atuomobilių markėms
DROP TABLE IF EXISTS marke;

CREATE TABLE marke (
	id SMALLINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    pavadinimas VARCHAR(50) NOT NULL
);

-- lentelė atuomobilių modeliams
DROP TABLE IF EXISTS modelis;

CREATE TABLE modelis (
	id SMALLINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
	markes_id SMALLINT UNSIGNED NOT NULL,
    automobilio_tipo_id TINYINT UNSIGNED NOT NULL,
    pavadinimas VARCHAR(50) NOT NULL,
    FOREIGN KEY (markes_id) REFERENCES marke(id),
	FOREIGN KEY (automobilio_tipo_id) REFERENCES automobilioTipas(id)
);

-- lentelė atuomobiliams
DROP TABLE IF EXISTS automobilis;

CREATE TABLE automobilis (
	id SMALLINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
	modelio_id SMALLINT UNSIGNED NOT NULL,
    numeris VARCHAR(20) NOT NULL,
    aprasymas TEXT,
    pastabos TEXT,
    nebenaudojamas TINYINT UNSIGNED NOT NULL DEFAULT 0,
    FOREIGN KEY (modelio_id) REFERENCES modelis(id)
);

-- lentelė atuomobilių kainoms
DROP TABLE IF EXISTS kaina;

CREATE TABLE kaina (
	automobilio_id SMALLINT UNSIGNED,
    trukme TINYINT UNSIGNED NOT NULL,
    kaina DECIMAL(8, 2) NOT NULL,
    PRIMARY KEY (automobilio_id, trukme),    
    FOREIGN KEY (automobilio_id) REFERENCES automobilis(id)
);

-- lentelė užsakymų būsenoms
DROP TABLE IF EXISTS uzsakymuBusena;

CREATE TABLE uzsakymuBusena (
	id TINYINT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
    pavadinimas VARCHAR(50) NOT NULL
);

-- lentelė užsakymams
DROP TABLE IF EXISTS uzsakymas;

CREATE TABLE uzsakymas (
	id INT UNSIGNED AUTO_INCREMENT PRIMARY KEY,
	kliento_id SMALLINT UNSIGNED NOT NULL,
	automobilio_id SMALLINT UNSIGNED NOT NULL,
	busenos_id TINYINT UNSIGNED NOT NULL,
    data_nuo DATE NOT NULL,
    data_iki DATE NOT NULL,
    suma DECIMAL(8, 2),
    pastabos TEXT,
    FOREIGN KEY (kliento_id) REFERENCES klientas(id),
    FOREIGN KEY (automobilio_id) REFERENCES automobilis(id),
    FOREIGN KEY (busenos_id) REFERENCES uzsakymuBusena(id)
);

-- lentelė užsakymams
DROP TABLE IF EXISTS uzsakymoDarbuotojas;

CREATE TABLE uzsakymoDarbuotojas (
	uzsakymo_id INT UNSIGNED NOT NULL,
	darbuotojo_id SMALLINT UNSIGNED NOT NULL,
    data_nuo DATETIME NOT NULL DEFAULT current_timestamp(),
    CONSTRAINT PK_uzsakymoDarbuotojas PRIMARY KEY (uzsakymo_id, darbuotojo_id),
    CONSTRAINT FK_uzsakymoDarbuotojas_uzsakymo_id FOREIGN KEY (uzsakymo_id) REFERENCES uzsakymas(id),
    CONSTRAINT FK_uzsakymoDarbuotojas_darbuotojo_id FOREIGN KEY (darbuotojo_id) REFERENCES darbuotojas(id)
);

-- -----------------------------------------
-- užpildome duomenis
-- -----------------------------------------
-- Pasirenkama DB
USE fe_autonuoma;

-- supildome šalių sąrašą
INSERT INTO salis VALUES
("lt", "Lietuva");

INSERT INTO salis VALUES
("lv", "Latvija"),
("pl", "Lenkija"),
("ee", "Estija");

-- visas šalių sąrašas
SELECT * FROM salis;

-- supildome rajonų sąrašą
INSERT INTO rajonas VALUES
(5, "lt", "Vilniaus raj.");

INSERT INTO rajonas VALUES
(NULL, "lt", "Vilniaus raj."); -- įterptas naujas rajonas su id = 6

-- atjungti nesaugių užklausų apsaugą
SET SQL_SAFE_UPDATES = 0;

DELETE FROM rajonas;

ALTER TABLE rajonas
AUTO_INCREMENT = 1;

INSERT INTO rajonas VALUES
(NULL, "lt", "Vilniaus raj.");  -- įterptas naujas rajonas su id = 1

INSERT INTO rajonas (salies_kodas, pavadinimas) VALUES
("lt", "Kauno raj."),
("lt", "Klaipėdos raj."),
("lt", "Šiaulių raj."); 

/*
INSERT INTO rajonas VALUES
(NULL, "UK", "Londono raj.");  -- tokio rajono neleidžia įterpti nes nėra atitinkamo kodo šalių lentelėje
*/

-- visas rajonų sąrašas
SELECT * FROM rajonas;


-- supildome miestų sąrašą
INSERT INTO miestas (rajono_id, pavadinimas) VALUES
(3, "Klaipėda"),
(3, "Gargždai"),
(3, "Slengiai"),
(1, "Vilnius"),
(1, "Grigiškės");


-- visas miestų sąrašas
SELECT * FROM miestas;

SELECT * FROM miestas
WHERE rajono_id = 3;


-- sudėtingesnė užklausa
SELECT 
	miestas.id, 
    miestas.pavadinimas, 
    rajonas.pavadinimas as Rajonas, 
    salis.kodas as "Šalies kodas", 
    salis.pavadinimas as Šalis
FROM miestas
JOIN rajonas ON miestas.rajono_id = rajonas.id
JOIN salis ON salis.kodas = rajonas.salies_kodas
WHERE miestas.pavadinimas LIKE "G%"
ORDER BY miestas.pavadinimas DESC;

-- supildome pareigų sąrašą
INSERT INTO pareiga (pavadinimas) VALUES
("Direktorius"),
("Vadybininkas"),
("Ekonomistas"),
("Buhalteris"),
("Mechanikas"),
("Vairuotojas"),
("IT administratorius"),
("Administratorius"),
("Sekretorė");


-- visas pareigų sąrašas
SELECT * FROM pareiga;

SELECT pavadinimas, id 
FROM pareiga
ORDER BY pavadinimas;

SELECT id 
FROM pareiga
WHERE pavadinimas = "Direktorius";


SELECT pavadinimas, id 
FROM pareiga
WHERE id IN (2, 5, 8)
ORDER BY pavadinimas;

-- supildome darbuotojų sąrašą

-- paruošiamoji informacija

SELECT * FROM miestas;
SELECT * FROM pareiga;

/*
Vardai:

Benas
Markas
Lukas
Matas
Nojus
Jokūbas
Herkus
Kajus
Dominykas
Adomas	

Amelija	
Lėja
Emilija	
Luknė
Liepa
Sofija
Gabija
Patricija
Kamilė
Iglė


Pavardės:
Gricius 
Stonkutė 
Paulauskaitė 
Baranauskas 
Petrulytė 
Valaitytė 
Baranauskas 
Petrauskaitė 
Sinkevič 
Kazlauskaitė 
Žukauskas 
Balčiūnaitė 
Žiūkas 
Stankevičius 
Balčiūnaitė 
Balčiūnas 
Paulauskaitė 
Pocius 
Balčius 
Bareikytė 
Rimkutė 
Kazlauskaitė 
Butkus 
Stankevičiūtė 
Cicėnaitė 
Jankauskaitė 
Semaško 
Stankevičius 
Balčiūnas
Jankauskaitė 
Balčiūnas 
Paulauskas 
Pocius 
Butkus 
Petrauskaitė 
Mackevič 
Morkūnas 
Petrauskaitė 
Morkūnaitė 
Sinkevičius 
Morkūnaitė 
Šinkūnas 
Stankevičiūtė 
Stonkus 
Tamulevičius 
Stankevičiūtė 
Kazlauskas 
Vasiliauskas 
Stankevičiūtė
Savickas 
Stankevič 
Šimkutė 
Butkus 
Stankevič 
Ivanova 
Pocius 
Ivanova 
Venckutė 
Deksnytė 
Ivanova

Gimimo datos:
1962-05-02
1962-08-15
1962-08-18
1963-07-09
1966-11-17
1967-09-25
1970-11-13
1973-09-03
1977-12-07
1982-02-24
1984-08-20
1984-10-17
1989-05-18
1989-11-23
1992-06-27
1992-08-07
1994-06-06
1995-05-02
1999-03-19
1999-09-09

Asmens kodo pabaigai
8013
5242
5125
1674
9973
7599
9091
9653
4426
8906
4622
9875
1549
6576
3126
6643
1244
5763
1464
5762

Telefono numeriai:
62399225
60562064
67061241
62944695
62154654
62343927
62107829
62551938
63083396
68369726
66979193
68948312
63559085
65717781
68189702
67400539
67106486
65962098
61713308
60508744 


Slaptažodžiai:
0183b99422e7d79aca37e81469cd4c2524f1b0b1657be62e8159a4a93d15c550
c34234787b1886ec21f95b9b546c032ea6550172ca3cf17b8bb74cc1deb46d28
60d38b3167abc0f432152a21f5b1040b284f5c80a11312337330e5e76540bf78
a092bdf141f808266ee053fa2affaeaf957c3c9fe3d2e717e66ffe35d62e91d4
73b059ceff4544cc5a069339192376d737dd9265d6d921b639df55ee708d9f5e
cd3a85180373624ba269488b9411b6abd9577dbfa7b90540754a3994b83fc358
468d43f4a7ce877aaaae8f35e61fcbd446e4ca216db048eb89c0d9c646e0b5a4
f87f2547edd7b2279baec71e763ffa1b0492709095d3426a170a46c08e2a4eaf
f69ea35256d0e4535544743d9fafdab0b243a55dde7d7108f3e3d8d232c4b683
29e379bf0e1f531cb759ae7636fd3e9af169fb28db681dba2698ddee7e3adb8a
4be6148df71b793792b0d49c36e784c8eb1bd0ddd68e6e18f6e3e68be0108b21
00fecc6f536283657caefe75250ab7d10a18ee714a7883ea5ce0a7a66deb4175
ff5415225e4f336effbf7c2f212b5a902e49b959dfa6f61bbb1c52421d6e2fec
767cb20fecc6e9e6855a3d5847712f41d67896f117815cb240d25605f61098ab
2c6e2f3f29f6b205b765b9e0163f52f0eb40ab9a4fa7669591c5270eddd85719
008c97452e025193f52dab57f1ee9c67c429f8f5f040b1218070582954cfa3dc
7f754aeef671f81bb969374665ae1b0fada967adcbf20ab2382d08d1649b59cc
9d865d7fd3ec1a53c2cfcea847cd5a2449574c8dac255da18da05f38295033a3
81c86f741e95e72d685d41a81cc95614ad0a3f1ecd635fd9e3b65c433a984dc4
5fa077e2eb4aa64a3b1b35d8be100a64c08e80d4d9a297223da80bae2e19cb15

*/

-- pildome darbuotojus
INSERT INTO darbuotojas (miesto_id, pareigos_id, vardas, pavarde, asmens_kodas, el_pastas, slaptazodis, adresas, telefonas, gimimo_data) VALUES
(1, 1, "Benas", "Gricius", "3196205028013", "benas.gricius@imone.lt", "0183b99422e7d79aca37e81469cd4c2524f1b0b1657be62e8159a4a93d15c550", "Liepų g. 14-3", "+37062399225", "1962-05-02"),
(1, 5, "Markas", "Stonkus", "3196208155242", "markas.stonkus@imone.lt", "c34234787b1886ec21f95b9b546c032ea6550172ca3cf17b8bb74cc1deb46d28", "Taikos pr. 16-8", "+37060562064", "1962-08-15"),
(1, 8, "Gabija", "Paulauskaitė", "4196208185125", "gabija.paulauskaite@imone.lt", "60d38b3167abc0f432152a21f5b1040b284f5c80a11312337330e5e76540bf78", "Taikos pr. 105-14", "+37067061241", "1962-08-18"),
(2, 6, "Kajus", "Baranauskas", "3196709257599", "kajus.baranauskas@imone.lt", "a092bdf141f808266ee053fa2affaeaf957c3c9fe3d2e717e66ffe35d62e91d4", "Klaipėdos g. 16", "+37062944695", "1967-09-25"),
(1, 9, "Emilija", "Petrulytė", "4196611179973", "emilija.petrulyte@imone.lt", "73b059ceff4544cc5a069339192376d737dd9265d6d921b639df55ee708d9f5e", "H. Manto g. 15-3", "+37062154654", "1966-11-17"),
(1, 5, "Dominykas", "Valaitis", "3197712074426", "dominykas.valaitis@imone.lt", "cd3a85180373624ba269488b9411b6abd9577dbfa7b90540754a3994b83fc358", NULL, "+37062343927", "1977-12-07"),
(3, 4, "Amelija", "Baranauskė", "4198202248906", "amelija.baranauske@imone.lt", "468d43f4a7ce877aaaae8f35e61fcbd446e4ca216db048eb89c0d9c646e0b5a4", "Upės g. 102", "+37062107829", "1982-02-24"),
(1, 2, "Patricija", "Petrauskaitė", "4196307091674", "patricija.petrauskaite@imone.lt", "f87f2547edd7b2279baec71e763ffa1b0492709095d3426a170a46c08e2a4eaf", "Minijos g. 106", "+37062551938", "1963-07-09"),
(1, 2, "Kamilė", "Sinkevič", "4197309039653", "kamile.sinkevic@imone.lt", "f69ea35256d0e4535544743d9fafdab0b243a55dde7d7108f3e3d8d232c4b683", "Šilutės pl, 17-3", "+37063083396", "1973-09-03"),
(1, 8, "Iglė", "Kazlauskaitė", "4197011139091", "igle.kazlauskaite@imone.lt", "29e379bf0e1f531cb759ae7636fd3e9af169fb28db681dba2698ddee7e3adb8a", "Taikos pr. 106-35", "+37068369726", "1970-11-13");

SELECT * FROM darbuotojas;

SELECT * FROM darbuotojas
WHERE vardas = "Markas" AND pavarde = "Stonkus";

SELECT * FROM darbuotojas
WHERE 
	vardas LIKE "%gabija%" 
    OR pavarde LIKE "%gabija%"
    OR asmens_kodas LIKE "%gabija%";

UPDATE darbuotojas SET nedirba=1
WHERE id=2;
 
UPDATE darbuotojas SET nedirba=1
WHERE id=3;
 


-- supildome klientus

SELECT * from miestas;

INSERT INTO klientas (miesto_id, vardas, pavarde, asmens_kodas, el_pastas, adresas) VALUES
(1, "Herkus", "Stankevičius", "196205028013", "herkus123@gmail.com", "Taikos pr. 14-5"),
(1, "Iglė", "Cicėnaitė", "198911235242", "igleee@gmail.com", "Taikos pr. 103-14"),
(1, "Gabija", "Jankauskaitė", "199909095125", "gabijajan@gmail.com", "Liepų g. 106A"),
(1, "Kajus", "Semaško", "198410171674", "kaaajus@yahoo.com", "H. Manto g. 15-60"),
(2, "Dominykas", "Stankevičius", "198905189973", "dominykas.stankevicius@gmail.com", "Ežero g. 60"),
(1, "Jokūbas", "Morkūnas", "199206277599", "jokubas1992@gmail.com", "Taikos pr. 30"),
(4, "Amelija", "Sinkevičienė", "199208079091", "amelija2000@gmail.com", "Elektrėnų g. 25"),
(3, "Lėja", "Balčiūnienė", "197309039653", "lejabal@yahoo.com", "Kalvos g. 14-3"),
(4, "Benas", "Jankauskas", "197712074426", "benasjankauskas200@gmail.com", "Geležinio vilko g. 105A"),
(4, "Markas", "Balčiūnas", "199406068906", "markasbalciunas@gmail.com", "Vytauto g. 15-60"),
(2, "Emilija", "Paulauskienė", "199505024622", "emilijaaa@hotmail.com", "Klaipėdos g. 14"),
(1, "Luknė", "Pocienė", "196307091549", "lukne.pociene@gmail.com", "Šilutės pl. 6-102"),
(1, "Liepa", "Butkuvienė", "196611179875", "liepa.cicenaite@yahoo.com", "Minijos g. 14-50"),
(1, "Sofija", "Morkūnienė", "196709256576", "s.morkuniene@gmail.com", "Šilutės pl. 30-5"),
(4, "Patricija", "Petrauskaitė", "197011133126", "ppetrauskaite@gmail.com", "Konarskio g. 15-20"),
(4, "Kamilė", "Morkūnaitė", "196208156643", "kamile.vilnius@gmail.com", "Laisvės g. 16-30"),
(1, "Kajus", "Šinkūnas", "198202241244", "kajus1982@yahoo.com", "Šilutės pl. 102-16"),
(1, "Matas", "Stankevičius", "198408205763", "matas.stankevicius@yahoo.com", "Minijos g. 105-30"),
(1, "Dominykas", "Stankevičius", "196208181464", "d.stankevicius@hotmail.com", "Tilžės g. 60-5"),
(4, "Adomas", "Paulauskas", "199903195762", "adomas.paulauskas@hotmail.com", "Geležinio vilko g. 50-53");

SELECT * FROM klientas;


-- Užpildome klientų tel. numerius
INSERT INTO telefonas (kliento_id, numeris) VALUES
(1, "+37062027863"),
(2, "+37061074936"),
(3, "+37068392840"),
(4, "+37067885772"),
(3, "+37060764872"),
(5, "+37060351729"),
(7, "+37065694758"),
(8, "+37069267778"),
(8, "+37060861269"),
(10, "+37065765477"),
(11, "+37061724458"),
(12, "+37066088881"),
(4, "+37064853929"),
(13, "+37062493925"),
(14, "+37068774617"),
(15, "+37063083221"),
(17, "+37069008121"),
(18, "+37060652568"),
(19, "+37065621248"),
(15, "+37069174751"),
(20, "+37064428761"),
(14, "+37062273784"); 

SELECT * FROM telefonas;

-- sudėtingesnės užklausos
SELECT * FROM klientas
LEFT JOIN telefonas ON telefonas.kliento_id = klientas.id;

SELECT klientas.* FROM klientas
LEFT JOIN telefonas ON telefonas.kliento_id = klientas.id
WHERE telefonas.id IS NULL;



-- Atsiliepimai apie klientus
INSERT INTO atsiliepimas (kliento_id, darbuotojo_id, tekstas) VALUES
(2, 8, "Labai mandagus klientas"),
(8, 9, "Labai daug kabinėjasi"),
(3, 9, "Nepavyksta gauti mokėjimo"),
(4, 9, "Neatsiliepia į skambutį"),
(5, 8, "Nepavuksta susisiekti"),
(5, 8, "Apgadino automobilį"),
(5, 8, "Geriau šiam klientui nenuomoti"),
(9, 9, "Labai geras klientas"),
(15, 1, "VIP klientas");

SELECT * FROM atsiliepimas;


-- Automobilių tipai
INSERT INTO automobilioTipas (pavadinimas) VALUES
("Lengvasis"),
("SUV");

-- Automobilių markės
INSERT INTO marke (pavadinimas) VALUES
("Audi"),
("Toyota"),
("Mazda"),
("Ford"),
("Opel");

SELECT * FROM marke;

-- Automobilių modeliai
INSERT INTO modelis (markes_id, automobilio_tipo_id, pavadinimas) VALUES
(1, 1, "A3"),
(1, 1, "A4"),
(1, 2, "Q7"),
(2, 1, "Yaris"),
(2, 1, "Corolla"),
(2, 2, "RAV4"),
(3, 1, "3"),
(4, 1, "Mondeo"),
(4, 1, "KA"),
(5, 1, "Insignia");

SELECT * FROM modelis;

-- Automobiliai
INSERT INTO automobilis (modelio_id, numeris) VALUES
(4, "IMN001"),
(4, "IMN002"),
(4, "IMN003"),
(3, "IMN004"),
(10, "IMN005");

SELECT * FROM automobilis;

UPDATE automobilis SET nebenaudojamas=1
WHERE id = 2;

UPDATE automobilis SET nebenaudojamas=1
WHERE id = 5;

INSERT INTO automobilis (modelio_id, numeris) VALUES
(1, "IMN002");

SELECT * FROM automobilis
WHERE numeris = "IMN002";

SELECT * FROM modelis;

-- sudėtingesnė užklausa
SELECT * FROM automobilis
JOIN modelis ON modelis.id = automobilis.modelio_id
WHERE automobilis.nebenaudojamas = 0
GROUP BY modelis.id;


-- keičiamas sutomobilio informaciją
UPDATE automobilis SET
aprasymas = "Automatinė pavadrų dėžė. Dyzelinas. Odinis salonas. Žalia spalva."
WHERE id = 1;


UPDATE automobilis SET
pastabos = "Neveikia galinis valytuvas."
WHERE id = 4;

--  auto kainos
INSERT INTO kaina VALUES
(1, 1, 50.00),
(1, 7, 40.00),
(1, 30, 30.00),
(2, 1, 50.00),
(2, 7, 40.00),
(2, 30, 30.00),
(3, 1, 50.00),
(3, 7, 40.00),
(3, 30, 30.00),
(4, 1, 80.00),
(4, 7, 70.00),
(5, 1, 60.00),
(5, 7, 40.00),
(5, 30, 30.00),
(6, 1, 49.99),
(6, 7, 39.99),
(6, 30, 29.99);

SELECT * from kaina;

/*
-- neleis įterpti nes pirminis raktas jau egzistuoja
INSERT INTO kaina VALUES
(6, 7, 34.99);
*/


UPDATE kaina SET kaina = 34.99
WHERE automobilio_id = 6 AND trukme = 7;

/*
-- jei nežinau ką reikia pasirinkti ar insert ar update

UPDATE kaina SET kaina = 39.99
WHERE automobilio_id = 6 AND trukme = 5;

INSERT INTO kaina VALUES
(6, 5, 39.99);
*/

INSERT INTO kaina VALUES
(6, 5, 38.99)
ON DUPLICATE KEY UPDATE
kaina = 38.99;



-- užsakymų būsenos
INSERT INTO uzsakymuBusena (pavadinimas) VALUES
("Naujas"),
("Vykdomas"),
("Įvykdytas"),
("Atšauktas");

SELECT * from uzsakymuBusena;


-- užsakymai
INSERT INTO uzsakymas(kliento_id, automobilio_id, busenos_id, data_nuo, data_iki) VALUES
(1, 3, 3, "2022-01-06", "2022-01-08"),
(2, 2, 4, "2022-01-08", "2022-01-10"),
(3, 2, 3, "2022-02-14", "2022-02-20"),
(1, 5, 3, "2022-01-09", "2022-01-30"),
(4, 1, 3, "2022-01-19", "2022-01-25"),
(5, 2, 3, "2022-01-20", "2022-01-30"),
(6, 4, 3, "2022-01-26", "2022-01-27"),
(3, 2, 3, "2022-02-05", "2022-02-05"),
(7, 1, 4, "2022-03-07", "2022-03-07"),
(8, 2, 3, "2022-02-10", "2022-02-10"),
(6, 3, 3, "2022-02-15", "2022-02-19"),
(10, 2, 3, "2022-02-20", "2022-02-25"),
(10, 6, 4, "2022-02-15", "2022-02-15"),
(11, 2, 3, "2022-03-04", "2022-03-04"),
(12, 3, 3, "2022-03-01", "2022-03-02"),
(13, 4, 4, "2022-03-15", "2022-03-16"),
(5, 3, 3, "2022-03-20", "2022-03-20"),
(6, 4, 2, "2022-06-10", "2022-06-20"),
(14, 6, 2, "2022-04-01", "2022-04-03"),
(15, 5, 4, "2022-05-01", "2022-05-06"),
(16, 1, 1, "2022-07-10", "2022-07-11"),
(17, 1, 2, "2022-06-13", "2022-06-15"),
(19, 3, 2, "2022-06-01", "2022-06-30"),
(8, 6, 1, "2022-07-20", "2022-07-20"),
(10, 4, 1, "2022-06-30", "2022-07-05"),
(20, 5, 1, "2022-06-30", "2022-07-01");

SELECT * FROM uzsakymas;

SELECT * FROM darbuotojas;

--  užsakymų darbuotojai

INSERT INTO uzsakymoDarbuotojas VALUES
(1, 8, "2022-01-01 15:00:00"),
(2, 8, "2022-01-02 9:00:00"),
(3, 9, "2022-01-02 17:15:00"),
(4, 8, "2022-01-03 17:15:00"),
(5, 8, "2022-01-05 15:00:00"),
(6, 8, "2022-01-10 17:00:00"),
(7, 8, "2022-02-02 15:00:00"),
(8, 9, "2022-02-0 17:15:00"),
(9, 9, "2022-02-16 9:00:00"),
(10, 9, "2022-02-18 17:15:00"),
(11, 8, "2022-02-20 15:00:00"),
(12, 8, "2022-02-20 15:00:00"),
(13, 8, "2022-03-02 17:15:00"),
(14, 9, "2022-03-03 9:00:00"),
(15, 8, "2022-03-05 15:00:00"),
(16, 8, "2022-03-05 15:00:00"),
(17, 9, "2022-03-06 17:00:00"),
(18, 8, "2022-03-10 17:00:00"),
(19, 8, "2022-03-16 15:00:00"),
(20, 9, "2022-03-20 17:00:00"),
(21, 8, "2022-03-30 15:00:00");

INSERT INTO uzsakymoDarbuotojas (uzsakymo_id, darbuotojo_id) VALUES
(22, 8),
(23, 8),
(24, 8),
(25, 8),
(26, 8),
(25, 9),
(26, 9);

SELECT * FROM uzsakymoDarbuotojas;


-- ------------------------
-- Duomenų bazės užklausos
-- ------------------------

-- Pasirenkama DB
USE fe_autonuoma;


-- Populiariausias automobilis

SELECT * FROM uzsakymuBusena;

SELECT 
	a.id,
    a.modelio_id,
    a.numeris,
    COUNT(u.id) AS uzsakymu_kiekis
FROM automobilis AS a
LEFT JOIN uzsakymas AS u ON u.automobilio_id = a.id
WHERE a.nebenaudojamas <> 1 AND u.busenos_id <> 4
GROUP BY a.id
ORDER BY count(u.id) DESC
LIMIT 1
;


SELECT 
	a.id,
	mr.pavadinimas AS marke, 
    md.pavadinimas AS modelis,
    atp.pavadinimas AS tipas,
    a.numeris,
    a.aprasymas,
    COUNT(u.id) AS uzsakymu_kiekis
FROM automobilis AS a
LEFT JOIN uzsakymas AS u ON u.automobilio_id = a.id
LEFT JOIN modelis AS md ON md.id = a.modelio_id
LEFT JOIN marke AS mr ON mr.id = md.markes_id
LEFT JOIN automobilioTipas AS atp ON atp.id = md.automobilio_tipo_id
WHERE a.nebenaudojamas <> 1 AND u.busenos_id <> 4
GROUP BY a.id
ORDER BY count(u.id) DESC
LIMIT 1
;

/*
{
"id": 3,
"pavadinimas": "Yaris",
"pavadinimas": "Toyota",
"numeris": "IMN003",
"uzsakymu_kiekis": 5
}
*/

-- Daugiausia užsakymų apdorojantis darbuotojas


SELECT
	d.*,
    COUNT(ud.uzsakymo_id) AS uzsakymu_kiekis
FROM darbuotojas AS d
LEFT JOIN uzsakymoDarbuotojas AS ud ON d.id = ud.darbuotojo_id
WHERE d.nedirba <> 1
GROUP BY d.id
ORDER BY COUNT(ud.uzsakymo_id) DESC
LIMIT 1
;

SELECT
	d.id,
	CONCAT(d.vardas, " ", d.pavarde) AS vardas_pavarde,
    d.el_pastas,
	d.telefonas,
    CONCAT(d.adresas, ", ", m.pavadinimas, ", ", r.pavadinimas) AS adresas,
    p.pavadinimas as pareigos,
    COUNT(ud.uzsakymo_id) AS uzsakymu_kiekis
FROM darbuotojas AS d
LEFT JOIN uzsakymoDarbuotojas AS ud ON d.id = ud.darbuotojo_id

LEFT JOIN pareiga AS p ON p.id = d.pareigos_id
LEFT JOIN miestas AS m ON m.id = d.miesto_id
LEFT JOIN rajonas AS r ON r.id = m.rajono_id

WHERE d.nedirba <> 1
GROUP BY d.id
ORDER BY COUNT(ud.uzsakymo_id) DESC
;

-- Daugiausia užsakymų per birželio mėnesį apdorojęs darbuotojas

SELECT
	d.id,
	CONCAT(d.vardas, " ", d.pavarde) AS vardas_pavarde,
    d.el_pastas,
	d.telefonas,
    CONCAT(d.adresas, ", ", m.pavadinimas, ", ", r.pavadinimas) AS adresas,
    p.pavadinimas as pareigos,
    COUNT(ud.uzsakymo_id) AS uzsakymu_kiekis_birzeli
    
FROM darbuotojas AS d
LEFT JOIN uzsakymoDarbuotojas AS ud ON d.id = ud.darbuotojo_id
LEFT JOIN uzsakymas AS u ON u.id = ud.uzsakymo_id

-- pagalbinės, išvedimui skirtos, informacijos surinkimui
LEFT JOIN pareiga AS p ON p.id = d.pareigos_id
LEFT JOIN miestas AS m ON m.id = d.miesto_id
LEFT JOIN rajonas AS r ON r.id = m.rajono_id

WHERE 
	d.nedirba <> 1  -- tik dirbantys darbuotojai
    AND u.busenos_id <> 4  -- neatšaukti užsakymai
    AND (u.data_nuo <= "2022-06-30" AND u.data_iki >= "2022-06-01")  -- užsakymai kai automobilis buvo išnuomotas birželio mėnesį

GROUP BY d.id
ORDER BY COUNT(ud.uzsakymo_id) DESC
;

/*
SELECT
	*
FROM darbuotojas AS d
LEFT JOIN uzsakymoDarbuotojas AS ud ON d.id = ud.darbuotojo_id
LEFT JOIN uzsakymas AS u ON u.id = ud.uzsakymo_id
WHERE 
	d.nedirba <> 1
    AND u.busenos_id <> 4
;
*/

-- Markių ir modelių sąrašas
SELECT 
	marke.pavadinimas AS marke,
    modelis.pavadinimas AS modelis
FROM marke
JOIN modelis ON modelis.markes_id = marke.id;

-- Kiek yra skirtingų modelių konkrečiai markei (markių sąrašas su modelių skaičiumi)

SELECT
	mr.pavadinimas AS marke,
	COUNT(md.id) AS modeliu_skaicius
FROM marke AS mr
LEFT JOIN modelis AS md ON md.markes_id = mr.id
GROUP BY mr.id
ORDER BY COUNT(md.id) DESC, mr.pavadinimas ASC
;

/*
SELECT * FROM modelis;
SELECT * FROM marke;

INSERT INTO marke (pavadinimas) VALUES ("Citroen");
*/

-- Klientų sąrašas su telefonais

SELECT
	k.id,
    CONCAT(k.pavarde, " ", k.vardas) AS 'Pavarde, vardas',
	t.numeris as 'Telefono numeris'
FROM klientas AS k
LEFT JOIN telefonas AS t ON t.kliento_id = k.id
ORDER BY k.pavarde, k.vardas;


SELECT
	CONCAT(k.pavarde, " ", k.vardas) AS 'Pavarde, vardas',
	-- CONCAT('["', GROUP_CONCAT(t.numeris SEPARATOR '", "'), '"]') as 'Telefono numeriai'
	GROUP_CONCAT(t.numeris SEPARATOR ', ') as 'Telefono numeriai'
FROM klientas AS k
LEFT JOIN telefonas AS t ON t.kliento_id = k.id
GROUP BY k.id
ORDER BY CONCAT(k.pavarde, " ", k.vardas);

-- Konkretaus klieto telefonų numeriai
/*
SELECT
	k.id AS id,
	k.vardas AS vardas,
	k.pavarde AS pavarde,
	t.numeris AS telefono_numeris
FROM klientas AS k
LEFT JOIN telefonas AS t ON t.kliento_id = k.id
WHERE k.vardas LIKE 'dominykas';
*/


SELECT * FROM klientas
WHERE vardas LIKE "%domi%";

SELECT
	k.vardas AS vardas,
	k.pavarde AS pavarde,
	t.numeris AS telefono_numeris,
	t.id AS telefono_id
FROM klientas AS k
LEFT JOIN telefonas AS t ON t.kliento_id = k.id
WHERE k.id = 19;

-- Sąrašas - šalis, rajonas, miestas

SELECT 
	salis.kodas,
    salis.pavadinimas AS Šalis,
    rajonas.pavadinimas AS Rajonas,
    miestas.pavadinimas AS Miestas
FROM salis
LEFT JOIN rajonas ON rajonas.salies_kodas = salis.kodas
LEFT JOIN miestas ON miestas.rajono_id = rajonas.id;

-- Automobilių kainos

SELECT
	a.id,
    a.numeris,
    k.trukme,
    k.kaina
FROM automobilis AS a
LEFT JOIN kaina AS k ON a.id = k.automobilio_id;


SELECT
	a.id,
    concat(marke.pavadinimas, " ", modelis.pavadinimas, " (", autt.pavadinimas, ")") AS automobilis,
    a.numeris,
    k.trukme,
    k.kaina
FROM automobilis AS a
LEFT JOIN kaina AS k ON a.id = k.automobilio_id

LEFT JOIN modelis ON modelis.id = a.modelio_id
LEFT JOIN marke ON marke.id = modelis.markes_id
LEFT JOIN automobilioTipas AS autt ON autt.id = modelis.automobilio_tipo_id
;

-- Automobilio mažiausia kaina

--  Pats pigiausias automobilis
SELECT
	mr.pavadinimas AS marke,
	md.pavadinimas AS modelis,
	atp.pavadinimas AS tipas,
	k.trukme AS trukme,
	k.kaina AS kaina
FROM automobilis AS a
LEFT JOIN kaina AS k ON k.automobilio_id = a.id

LEFT JOIN modelis AS md ON md.id = a.modelio_id
LEFT JOIN automobilioTipas AS atp ON md.automobilio_tipo_id = atp.id
LEFT JOIN marke AS mr ON md.markes_id = mr.id

ORDER BY k.kaina
LIMIT 1
;

-- Kiekvieno automobilio mažiausia kaina
SELECT
	a.id,
	mr.pavadinimas AS marke,
	md.pavadinimas AS modelis,
	atp.pavadinimas AS tipas,
	MIN(k.kaina) AS min_kaina
FROM automobilis AS a
LEFT JOIN kaina AS k ON k.automobilio_id = a.id

LEFT JOIN modelis AS md ON md.id = a.modelio_id
LEFT JOIN automobilioTipas AS atp ON md.automobilio_tipo_id = atp.id
LEFT JOIN marke AS mr ON md.markes_id = mr.id

GROUP BY a.id

ORDER BY MIN(k.kaina)
;

-- Klientų kiekis pagal miestą

SELECT 
   m.pavadinimas AS miestas,   
   COUNT(k.id) AS klientu_skaicius
FROM miestas AS m
LEFT JOIN klientas AS k ON k.miesto_id = m.id
GROUP BY m.id;

-- Klientų sąrašas pagal užsakymų skaičiu

SELECT
	k.id,
	k.vardas,
	k.pavarde,
	COUNT(u.id) AS uzsakymu_kiekis
FROM klientas AS k
JOIN uzsakymas AS u ON u.kliento_id = k.id
GROUP BY k.id
ORDER BY COUNT(u.id) DESC
;

-- Užpildyti užsakymų sumas, pagal kainų lentelę, jei suma =  NULL ir uzsakymo id = 5

SELECT 
	u.*,
	k.*,
	datediff(u.data_iki, u.data_nuo) + 1 AS dienu_sk,
    min(k.kaina) AS dienos_kaina,
    min(k.kaina) * (datediff(u.data_iki, u.data_nuo) + 1) AS uzsakymo_kaina
FROM uzsakymas AS u
LEFT JOIN kaina AS k ON k.automobilio_id = u.automobilio_id

WHERE 
    k.trukme <= (datediff(u.data_iki, u.data_nuo) + 1)
    
GROUP BY u.id
;


-- atjungti nesaugių užklausų apsaugą
SET SQL_SAFE_UPDATES = 0;


UPDATE uzsakymas AS u
LEFT JOIN 
(
	SELECT
		u.id AS u_id,
		min(k.kaina) as dienos_kaina,
		min(k.kaina) * (datediff(u.data_iki, u.data_nuo) + 1) AS uzsakymo_kaina
	FROM uzsakymas AS u
	LEFT JOIN kaina AS k ON k.automobilio_id = u.automobilio_id

	WHERE 
		k.trukme <= (datediff(u.data_iki, u.data_nuo) + 1)
		
	GROUP BY u.id
) as kainu_lentele
ON u.id = kainu_lentele.u_id
SET u.suma = kainu_lentele.uzsakymo_kaina
;

SELECT * FROM uzsakymas;

-- visų užsakymų sumą padarome null


UPDATE uzsakymas SET suma = NULL;

-- užsakymas 5 suma padarome 100

UPDATE uzsakymas SET suma = 100 WHERE id = 5;

-- apskaičiuojame sumą užsakymams kurie yra NULL ir būsena <> 4


UPDATE uzsakymas AS u
LEFT JOIN 
(
	SELECT
		u.id AS u_id,
		min(k.kaina) as dienos_kaina,
		min(k.kaina) * (datediff(u.data_iki, u.data_nuo) + 1) AS uzsakymo_kaina
	FROM uzsakymas AS u
	LEFT JOIN kaina AS k ON k.automobilio_id = u.automobilio_id

	WHERE 
		k.trukme <= (datediff(u.data_iki, u.data_nuo) + 1)
		
	GROUP BY u.id
) as kainu_lentele
ON u.id = kainu_lentele.u_id
SET u.suma = kainu_lentele.uzsakymo_kaina
WHERE 
	u.suma IS NULL 
    AND u.busenos_id <> 4
;

-- Klientų sąrašas pagal išleistą sumą

use fe_autonuoma;

SELECT * FROM uzsakymas;
SELECT * FROM uzsakymuBusena;

SELECT
	k.id,
	k.Vardas,
	COUNT(CASE WHEN u.busenos_id = 3 THEN u.id ELSE NULL END) AS ivyktydu_uzsakymu_skaicius,
	SUM(CASE WHEN u.busenos_id = 3 THEN u.suma ELSE 0 END) AS bendra_suma
from klientas AS k
left join uzsakymas AS u on k.id = u.kliento_id
GROUP BY k.id
ORDER BY bendra_suma DESC
;



SELECT
	k.id,
	k.Vardas,
    COUNT(u.id) AS ivyktydu_uzsakymu_skaicius,
    SUM(CASE WHEN u.suma IS NULL THEN 0 ELSE u.suma END) as uzsakymo_suma
from klientas AS k
left join (SELECT * FROM uzsakymas WHERE busenos_id = 3) AS u on k.id = u.kliento_id
group by k.id
order by uzsakymo_suma DESC
;



SELECT 
	id,
    kliento_id,
    count(id) as kiekis,
    sum(suma) as suma
FROM uzsakymas
WHERE busenos_id = 3
GROUP BY kliento_id;
    
    
SELECT
	k.id,
	k.Vardas,
    CASE WHEN u.kiekis IS NULL THEN 0 ELSE u.kiekis END AS kiekis,
    CASE WHEN u.suma IS NULL THEN 0 ELSE u.suma END AS suma
from klientas AS k
left join (
	SELECT 
		id,
		kliento_id,
		count(id) as kiekis,
		sum(suma) as suma
	FROM uzsakymas
	WHERE busenos_id = 3
	GROUP BY kliento_id
) AS u on k.id = u.kliento_id
order by suma DESC
;
    
-- Populiariausias modelis

SELECT
   a.modelio_id,
   marke.pavadinimas AS marke,
   m.pavadinimas AS modelis,
   COUNT(u.id) AS uzsakymu_kiekis
FROM automobilis AS a
LEFT JOIN uzsakymas AS u ON u.automobilio_id = a.id
LEFT JOIN modelis AS m ON m.id = a.modelio_id
LEFT JOIN marke ON marke.id = m.markes_id
WHERE u.busenos_id = 3
GROUP BY a.modelio_id
ORDER BY uzsakymu_kiekis DESC
;

-- Modelių sąrašas pagal pelną

SELECT
	CONCAT(mrk.pavadinimas, ' ', mdl.pavadinimas) AS Modelis,
	SUM(u.suma) AS Pelnas
FROM uzsakymas AS u
JOIN automobilis AS a ON a.id = u.automobilio_id
JOIN modelis AS mdl ON mdl.id = a.modelio_id
JOIN marke AS mrk ON mrk.id = mdl.markes_id
WHERE
	u.busenos_id = 3
GROUP BY mdl.id
ORDER BY Pelnas DESC;






SELECT
	automobilio_id,
	sum(suma) as suma
FROM uzsakymas
WHERE busenos_id = 3
GROUP BY automobilio_id;



SELECT
	CONCAT(mrk.pavadinimas, ' ', mdl.pavadinimas) AS Modelis,
	SUM(u.suma) AS Pelnas
FROM automobilis AS a
JOIN modelis AS mdl ON mdl.id = a.modelio_id
JOIN marke AS mrk ON mrk.id = mdl.markes_id
LEFT JOIN (
	SELECT
		automobilio_id,
		sum(suma) as suma
	FROM uzsakymas
	WHERE busenos_id = 3
	GROUP BY automobilio_id
) AS u ON u.automobilio_id = a.id
GROUP BY mdl.id
ORDER BY Pelnas DESC;

-- Modelių sąrašas pagal pelno vidurkį

SELECT
	CONCAT(mrk.pavadinimas, ' ', mdl.pavadinimas) AS Modelis,
	AVG(u.suma) AS Pelno_vidurkis
FROM uzsakymas AS u
JOIN automobilis AS a ON a.id = u.automobilio_id
JOIN modelis AS mdl ON mdl.id = a.modelio_id
JOIN marke AS mrk ON mrk.id = mdl.markes_id
WHERE
	u.busenos_id = 3
GROUP BY mdl.id
ORDER BY Pelno_vidurkis DESC;


-- Darbuotojų sąrašas su pilna informacija

SELECT
	d.id AS id,
	CONCAT(d.vardas, " ", d.pavarde) AS darbuotojas,
	p.pavadinimas AS pareigos,
	CASE 
		WHEN d.adresas IS NULL THEN CONCAT(m.pavadinimas,', ', r.pavadinimas, ', ', s.pavadinimas)
        ELSE CONCAT(d.adresas,', ', m.pavadinimas,', ', r.pavadinimas, ', ', s.pavadinimas) 
    END AS adresas,
	d.telefonas AS telefonas,
	d.gimimo_data AS gimino_data,
	d.asmens_kodas AS as_k,
    CASE
		WHEN d.nedirba = 1 THEN "Nebedirba"
        ELSE "Dirba"
	END AS dirba
  FROM darbuotojas AS d
  JOIN pareiga AS p ON p.id = d.pareigos_id
  JOIN miestas AS m ON m.id = d.miesto_id
  JOIN rajonas AS r ON r.id = m.rajono_id
  JOIN salis AS s ON s.kodas = r.salies_kodas
  ;

-- Konkretaus vadybininko užsakymų sąrašas


SELECT
	d.id,
	CONCAT(d.vardas, " ", d.pavarde) as darbuotojas,
	pa.pavadinimas as pareigos,
	uzs.id AS uzsakymo_id,
    
	kl.id AS kliento_id,
	CONCAT(kl.vardas, " ", kl.pavarde) AS klientas,
	
    uzs.automobilio_id AS automobilio_id,
    CONCAT(mr.pavadinimas, " ", md.pavadinimas, ", ", auto.numeris) AS automobilis,
    
	ub.pavadinimas AS busena,
    
	uzs.data_nuo,
	uzs.data_iki,
	uzs.suma,
	uzs.pastabos
FROM darbuotojas AS d
LEFT JOIN uzsakymoDarbuotojas AS uzda ON d.id = uzda.darbuotojo_id
LEFT JOIN uzsakymas AS uzs ON uzs.id = uzda.uzsakymo_id

JOIN pareiga AS pa ON pa.id = d.pareigos_id
JOIN klientas AS kl ON kl.id = uzs.kliento_id
JOIN automobilis AS auto ON auto.id = uzs.automobilio_id
JOIN modelis AS md ON md.id = auto.modelio_id
JOIN marke AS mr ON mr.id = md.markes_id
JOIN uzsakymuBusena AS ub ON ub.id = uzs.busenos_id

WHERE 
	d.id = 8
;


-- Vadybininkų sąrašas su informacija nuo kada apdorojo pirmąjį užsakymą


select
	darbuotojas.id,
	darbuotojas.vardas,
	darbuotojas.pavarde,
	pareiga.pavadinimas,
	min(uzsakymoDarbuotojas.data_nuo) as pradzios_data
from darbuotojas
join pareiga on pareiga.id = darbuotojas.pareigos_id
left join uzsakymoDarbuotojas on darbuotojas.id = uzsakymoDarbuotojas.darbuotojo_id
-- Where pareiga.pavadinimas = 'Vadybininkas'
Where pareiga.id  = 2
group by darbuotojas.id
;

-- Toyota Yaris kovo mėnesio užsakymų sąrašas


SELECT 
	a.id,
	CONCAT(mr.pavadinimas, " ", md.pavadinimas) AS automobilis,
	a.numeris,
    CONCAT(k.vardas, " ", k.pavarde) AS klientas,
    u.id as uzsakymas,
    u.data_nuo,
    u.data_iki,
    u.suma,
    ub.pavadinimas as busena
FROM automobilis AS a
LEFT JOIN uzsakymas AS u ON u.automobilio_id = a.id

LEFT JOIN modelis AS md ON md.id = a.modelio_id
LEFT JOIN marke AS mr ON mr.id = md.markes_id
LEFT JOIN uzsakymuBusena AS ub ON ub.id = u.busenos_id
LEFT JOIN klientas AS k ON k.id = u.kliento_id

WHERE 
	u.data_nuo <= '2022-03-31' AND u.data_iki >= '2022-03-01'
	AND a.modelio_id = 4
;

select * from modelis;


-- Konkretaus kliento atsiliepimų sąrašas su pilna info (kas rašė atsiliepimą ir apie ką)


SELECT
	k.id AS kliento_id,
	CONCAT(k.vardas, ' ', k.pavarde) AS klientas,
	a.id AS atsiliepimo_id,
	a.tekstas AS atsiliepimas,
	a.data_laikas AS laikas,
	d.id AS darbuotojo_id,
	CONCAT(d.vardas, ' ', d.pavarde) AS darbuotojas,
    p.pavadinimas AS pareigos
FROM klientas AS k
LEFT JOIN atsiliepimas AS a ON a.kliento_id = k.id
LEFT JOIN darbuotojas AS d ON a.darbuotojo_id = d.id

LEFT JOIN pareiga AS p ON d.pareigos_id = p.id

WHERE k.id = 5
;

-- Klientų sąrašas su atsiliepimų kiekiu


SELECT   
   k.id,
   k.vardas,
   k.pavarde,       
   COUNT(a.id) AS atsiliepimu_skaicius  
FROM klientas AS k
LEFT JOIN  atsiliepimas AS a ON a.kliento_id = k.id
GROUP BY k.id
;

/*
SELECT   
   k.*,
   a.*
FROM klientas AS k
LEFT JOIN atsiliepimas AS a ON a.kliento_id = k.id
;
*/

-- Užsakymų kiekis pagal būsenas


SELECT
	uzbus.id,
	uzbus.pavadinimas AS uzsakymo_busena,
	COUNT(uzs.id) AS uzsakymu_kiekis
FROM uzsakymas AS uzs
RIGHT JOIN uzsakymuBusena AS uzbus ON uzbus.id = uzs.busenos_id
GROUP BY uzbus.id
;

/*
SELECT
	uzbus.id,
	uzbus.pavadinimas AS uzsakymo_busena,
    uzs.*
    
FROM uzsakymas AS uzs
RIGHT JOIN uzsakymuBusena AS uzbus ON uzbus.id = uzs.busenos_id
GROUP BY uzbus.id;
*/


/*
INSERT INTO uzsakymuBusena (pavadinimas) VALUES ("Laikinas");
SELECT * FROM uzsakymuBusena;
*/

-- Laisvi automobiliai nurodytam laikotarpiui


SELECT * FROM uzsakymas;
SELECT * FROM automobilis;
-- 4 1 3



SET @naujo_uzsakymo_data_nuo := '2022-06-03';
SET @naujo_uzsakymo_data_iki := '2022-06-15';

SELECT
	a.id,
	CONCAT(a.numeris, ', ', mrk.pavadinimas, ' ', mdl.pavadinimas) AS Automobilis
FROM automobilis AS a

LEFT JOIN modelis AS mdl ON mdl.id = a.modelio_id
LEFT JOIN marke AS mrk ON mrk.id = mdl.markes_id

WHERE
	a.nebenaudojamas <> 1
	AND
	NOT EXISTS
	(
		SELECT
		*
        FROM
		-- užimti automobiliai nurodytam laikotarpiui:
		(
			SELECT
				u.automobilio_id AS a_id
			FROM uzsakymas AS u
			WHERE
				u.busenos_id <> 4
				AND u.data_nuo <= @naujo_uzsakymo_data_iki 
				AND u.data_iki >= @naujo_uzsakymo_data_nuo
			GROUP BY u.automobilio_id
		) AS uzimtiAutomobiliai
		WHERE a.id = uzimtiAutomobiliai.a_id
    );
    
   /* 
    SELECT
		u.automobilio_id AS a_id
	FROM uzsakymas AS u
	WHERE
		u.busenos_id <> 4
		AND u.data_nuo <= @naujo_uzsakymo_data_iki 
		AND u.data_iki >= @naujo_uzsakymo_data_nuo
	GROUP BY u.automobilio_id;
    */
    
    
    
SELECT
	a.id,
	CONCAT(a.numeris, ', ', mrk.pavadinimas, ' ', mdl.pavadinimas) AS Automobilis
FROM automobilis AS a

JOIN modelis AS mdl ON mdl.id = a.modelio_id
JOIN marke AS mrk ON mrk.id = mdl.markes_id

WHERE
	a.nebenaudojamas <> 1
	AND a.id NOT IN (
		SELECT
			u.automobilio_id AS a_id
		FROM uzsakymas AS u
		WHERE
			u.busenos_id <> 4
			AND u.data_nuo <= @naujo_uzsakymo_data_iki 
			AND u.data_iki >= @naujo_uzsakymo_data_nuo
		GROUP BY u.automobilio_id
    )
;



SELECT
	a.id,
	CONCAT(a.numeris, ', ', mrk.pavadinimas, ' ', mdl.pavadinimas) AS Automobilis
    
FROM automobilis AS a

LEFT JOIN (
	SELECT
		u.automobilio_id AS a_id
	FROM uzsakymas AS u
	WHERE
		u.busenos_id <> 4
		AND u.data_nuo <= @naujo_uzsakymo_data_iki 
		AND u.data_iki >= @naujo_uzsakymo_data_nuo
	GROUP BY u.automobilio_id
) AS uzs ON uzs.a_id = a.id

JOIN modelis AS mdl ON mdl.id = a.modelio_id
JOIN marke AS mrk ON mrk.id = mdl.markes_id

WHERE
	a.nebenaudojamas <> 1
	AND uzs.a_id IS NULL
;


-- Naudojami automobiliai su pastabomis


SELECT
    a.id,
    marke.pavadinimas as marke,
    m.pavadinimas AS modelis,
    a.numeris,
    
    a.pastabos
FROM automobilis AS a

JOIN modelis AS m ON m.id = a.modelio_id
JOIN marke ON marke.id = m.markes_id

WHERE 
	a.nebenaudojamas <> 1
    AND (a.pastabos IS NOT NULL OR a.pastabos <> "")
;


-- Užsakymas ir kaina paskaičiuota pagal užsakymo laikotarpį, ir užsakyto automobilio kainų lantelę



SELECT
	u.*,
	datediff(u.data_iki, u.data_nuo) + 1 as dienu_sk,
	min(k.kaina) as dienos_kaina_apskaiciuota,
	min(k.kaina) * (datediff(u.data_iki, u.data_nuo) + 1) AS uzsakymo_kaina_apskaiciuota
FROM uzsakymas AS u
LEFT JOIN kaina AS k ON k.automobilio_id = u.automobilio_id

WHERE 
	k.trukme <= (datediff(u.data_iki, u.data_nuo) + 1)
	
GROUP BY u.id;



-- Vaizdo sukūrimas
-- Užsakymai su apskaičiuotomis kainomis

CREATE VIEW uzsakymaiApskaiciuoti AS
SELECT
	u.*,
	datediff(u.data_iki, u.data_nuo) + 1 as dienu_sk,
	min(k.kaina) as dienos_kaina_apskaiciuota,
	min(k.kaina) * (datediff(u.data_iki, u.data_nuo) + 1) AS uzsakymo_kaina_apskaiciuota
FROM uzsakymas AS u
LEFT JOIN kaina AS k ON k.automobilio_id = u.automobilio_id

WHERE 
	k.trukme <= (datediff(u.data_iki, u.data_nuo) + 1)
	
GROUP BY u.id;


-- vaizdo naudojimas

SELECT * FROM uzsakymaiApskaiciuoti;



UPDATE uzsakymas AS u
LEFT JOIN 
(
	SELECT
		u.id AS u_id,
		min(k.kaina) as dienos_kaina,
		min(k.kaina) * (datediff(u.data_iki, u.data_nuo) + 1) AS uzsakymo_kaina
	FROM uzsakymas AS u
	LEFT JOIN kaina AS k ON k.automobilio_id = u.automobilio_id

	WHERE 
		k.trukme <= (datediff(u.data_iki, u.data_nuo) + 1)
		
	GROUP BY u.id
) as kainu_lentele
ON u.id = kainu_lentele.u_id
SET u.suma = kainu_lentele.uzsakymo_kaina
;




UPDATE uzsakymas AS u
LEFT JOIN uzsakymaiApskaiciuoti as kainu_lentele
ON u.id = kainu_lentele.id
SET u.suma = kainu_lentele.uzsakymo_kaina_apskaiciuota
;

select * FROM uzsakymas;


-- darbuotojo lentelė su amžiumi

CREATE VIEW darbuotojasAmzius AS
SELECT 
	*,
    timestampdiff(year, gimimo_data, now()) AS amzius
FROM darbuotojas;


SELECT * FROM darbuotojasAmzius
ORDER BY amzius;
