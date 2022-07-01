const express = require("express");
const app = express();
const port = 3000;

// užkrauname mysql biblioteką
const mysql = require("mysql");

// prisijungimaas prie mysql
const db = mysql.createConnection({
  host: "localhost",
  user: "root", 
  password: "root", 
  database: "fe_autonuoma", // db pavadinimas
});

// vykdomas prisijungimas su DB
db.connect((err) => {
  if (err) {
    throw err;
  }
  console.log("Prisijungta prie DB");
});

// automobilių sąrašas
app.get("/api/v1/automobiliai", (req, res) => {
  let sql =
    "SELECT " +
    "a.id, " +
    "a.numeris, " +
    "mr.pavadinimas AS marke, " +
    "md.pavadinimas AS modelis, " +
    "at.pavadinimas AS tipas, " +
    "a.aprasymas, " +
    "a.pastabos " +
    "FROM automobilis AS a " +
    "JOIN modelis AS md ON md.id = a.modelio_id " +
    "JOIN marke AS mr ON mr.id = md.markes_id " +
    "JOIN automobilioTipas AS at ON at.id = md.automobilio_tipo_id " +
    "WHERE a.nebenaudojamas <> 1;";
  db.query(sql, (err, db_rezultatas) => {
    if (err) {
      throw err;
    }

    // išsiunčia duomenis
    res.send(db_rezultatas);
  });
});

// konkretaus automobilio informacija
app.get("/api/v1/automobiliai/:auto_id", (req, res) => {
  let sql =
    "SELECT " +
    "a.id, " +
    "a.numeris, " +
    "mr.pavadinimas AS marke, " +
    "md.pavadinimas AS modelis, " +
    "at.pavadinimas AS tipas, " +
    "a.aprasymas, " +
    "a.pastabos " +
    "FROM automobilis AS a " +
    "JOIN modelis AS md ON md.id = a.modelio_id " +
    "JOIN marke AS mr ON mr.id = md.markes_id " +
    "JOIN automobilioTipas AS at ON at.id = md.automobilio_tipo_id " +
    "WHERE " +
    "a.nebenaudojamas <> 1 " +
    "AND a.id = ?" +
    ";";

  db.query(sql, [req.params.auto_id], (err, db_rezultatas) => {
    if (err) {
      throw err;
    }

    // išsiunčia duomenis
    res.send(db_rezultatas);
  });
});

// konkretaus automobilio informacija
app.get("/api/v1/automobiliai/:auto_id/uzsakymai", (req, res) => {
  let sql = `
        SELECT 
            u.id,
            a.id AS automobilio_id,
            CONCAT(mr.pavadinimas, " ", md.pavadinimas) AS automobilis,
            a.numeris,
            u.data_nuo,
            u.data_iki,
            u.suma,
            ub.pavadinimas AS busena,
            u.pastabos,
            k.id AS kliento_id,
            CONCAT(k.vardas, " ", k.pavarde) AS klientas
        FROM uzsakymas AS u
        LEFT JOIN automobilis AS a ON a.id = u.automobilio_id

        JOIN modelis AS md ON md.id = a.modelio_id
        JOIN marke AS mr ON mr.id = md.markes_id

        JOIN klientas AS k ON k.id = u.kliento_id
        JOIN uzsakymuBusena AS ub ON ub.id = u.busenos_id

        WHERE a.id = ?
        ORDER BY u.data_nuo DESC;`;

  db.query(sql, [req.params.auto_id], (err, db_rezultatas) => {
    if (err) {
      throw err;
    }

    // išsiunčia duomenis
    res.send(db_rezultatas);
  });
});

// klientų sąrašas select elementui
app.get("/api/v1/klientai/select", (req, res) => {
  let sql = `
        SELECT 
            k.id,
            CONCAT(k.vardas, " ", k.pavarde) AS klientas
        FROM klientas AS k
        ORDER BY k.pavarde, k.vardas;`;

  db.query(sql, [req.params.auto_id], (err, db_rezultatas) => {
    if (err) {
      throw err;
    }

    // išsiunčia duomenis
    res.send(db_rezultatas);
  });
});

// automobilių būsenų sąrašas select elementui
app.get("/api/v1/uzsakymuBusenos/select", (req, res) => {
  let sql = `SELECT ub.id, ub.pavadinimas
    FROM uzsakymuBusena AS ub;`;

  db.query(sql, [req.params.auto_id], (err, db_rezultatas) => {
    if (err) {
      throw err;
    }

    // išsiunčia duomenis
    res.send(db_rezultatas);
  });
});

app.post("/api/v1/uzsakyti", (req, res) => {

    console.log(req.body);
    console.log(req.params);
    res.send("success");
    
    // To Do
    // gauti POST informaciją
    // įterpti užsakymo duomenis į DB
    // patikrinti ar užsakymo periodas galimas
    // patikrinti ir kitą informaciją

});

app.get("/automobiliai", (req, res) => {
  res.sendFile(__dirname + "/automobiliai.html");
});

app.get("/", (req, res) => {
  res.send("Hello World!");
});

app.listen(port, () => {
  console.log(`Example app listening on port ${port}`);
});
