
####################################################
# Einstieg


## Pakete installieren und laden

#installieren:
install.packages("archdata")

#laden: 
library(archdata)


# Daten aus Datenpaketen einlesen:
data(BACups)

# Hilfe:
?"BACups"

str(BACups)

head(BACups)


# Daten aus eigenen Tabellen einlesen:

beazley <- read.csv(file = "data/prep/beazley_clean.csv",            # Funktion und Dateiname
                    sep = ";",                                       # seperator, der in der csv eingestellt ist
                    header = TRUE,                                   # Gibt es Spaltenköpfe?
                    colClasses = c("character", "factor", "factor",  # colClasses legt fest, als welcher
                                   "factor", "integer", "integer",   # Datentyp eine Spalte eingelesen wird
                                   "factor"))                        # (ist nicht erforderlich, R kann das erraten)


# Weitere Funktionen zum nachlesen: <https://www.datacamp.com/community/tutorials/r-data-import-tutorial>


# Deskriptive Statistik

# Zusammenfassung der Spalten:
summary(BACups)

summary(beazley)


mean(BACups$RD)       # arithmetisches Mittel
median(BACups$RD)     # Median (Mittelwert)
# für den mode / Modus gibt es keine Funktion!
range(BACups$RD)      # Kleinster und größter Wert in einer Liste
min(BACups$RD)        # Kleinster Wert
max(BACups$RD)        # Größter Wert

table(BACups$Phase)   # Frequenztabelle (Häufigkeitstabelle)
table(beazley$Technique, beazley$Shape)   # Frequenztabelle (Häufigkeitstabelle)

# Mittelwert nach Phasen getrennt:


############ Exkurs: Funktionen selbst schreiben

# Häufigkeitstabelle des gewünschten Vektors anlegen:
tbl <- table(BACups$RD)

# Was ist der höchste Wert in der Tabelle? (Höchstgezählter Wert)
tbl_wmax <- which.max(tbl)

# Welchem Wert aus tbl entspricht das?
tbl_max <- tbl[tbl_wmax]

# wie heißt der Wert? 
names(tbl_max)

# Das alles lässt sich auch in einer Zeile machen:
table(BACups$RD)[which.max(table(BACups$RD))]

get.mode <- function(vector) {
  tbl <- table(vector)
  tbl_wmax <- which.max(tbl)
  tbl_max <- tbl[tbl_wmax]
  tbl_namemax <- names(tbl_max)
  return(tbl_namemax)
}

get.mode(BACups$RD)
get.mode(beazley$Shape)

# Andere Herangehensweise: 
get.mode.other <- function(vector) {
  uniqv <- unique(vector)
  uniqv[which.max(tabulate(match(vector, uniqv)))]
}
# Quelle: https://www.tutorialspoint.com/r/r_mean_median_mode.htm

############ Deskriptive Statistik nach Variablen getrennt

# Auslesen der eindeutigen Werte aus der Spalte 'Phase'
BA_Phases <- unique(BACups$Phase)
BA_Phases

# Speichern der Indizes für beide Phasen in eigenen vectors
ind_BA_phase_a <- which(BACups$Phase == BA_Phases[1])
ind_BA_phase_b <- which(BACups$Phase == BA_Phases[2])

# Mittelwert für beide Phasen
mean(BACups$RD[ind_BA_phase_a])
mean(BACups$RD[ind_BA_phase_b])

# Ein weiterer Weg ans Ziel: 
aggregate(formula = RD ~ Phase, data = BACups, FUN = mean)




