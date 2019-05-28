####################################################
# Daten bearbeiten


beazley <- read.csv(file = "data/raw/beazley_sample_10000.csv", 
                    sep = ",", 
                    header = TRUE)


str(beazley)

summary(beazley)     # Zusammenfassung alles Spalten
unique(beazley)      # gibt die individuellen Werte von x zurück
is.na(beazley)       # prüft alle Elemente in x auf NAs
any(is.na(beazley))  # ist irgendein Element von x == TRUE?
any(is.na(beazley$Shape.Name))  #
str(beazley)         # atomic vector-Klassen, überblick über Elemente

# Speichert nur die angegebenen Spalten und 'löscht' den Rest:
beazley <- beazley[,c(2, 3, 4, 6, 7, 8)]

# Löscht alle Zeilen, in denen nichts im Datierungsfeld steht.
beazley <- beazley[-which(beazley$Date == ""),]

head(unique(beazley$Date))

# Speichert Date als character-vector!
beazley$Date <- as.character(beazley$Date)

# kopiert mittels strsplit() alle Date-Werte in eine Liste in der neuen Spalte 'Date_new'
beazley$Date_new <- strsplit(beazley$Date, " ")
# Anlegen von zwei neuen, leeren Spalten:
beazley$DAT_min <- NA
beazley$DAT_max <- NA

# for ist ein Loop. lies: Für jedes i in 1:Zeilenanzahl 
# vom df beazley führe den Code in {} aus
for (i in 1:nrow(beazley)) {
  if (beazley$Date_new[i][[1]][1] == "to") {
    # wenn element 1 der Liste aus Zeile i das Wort "to" enthält
    # wird diese Meldung ausgegeben:
    print(paste("Vase-No. ", 
                beazley$Vase.Number[i], 
                " is undated. (", 
                beazley$Date[i], ")", sep = ""))
  } else {
    # wenn nicht, dann passiert dies:
    # Speichert Listenelement 1 aus Zeile i 
    # in Spalte DAT_min aus Zeile i
    beazley$DAT_min[i] <- beazley$Date_new[i][[1]][1]
    # Speichert Listenelement 3 aus Zeile i 
    # in Spalte DAT_max aus Zeile i
    beazley$DAT_max[i] <- beazley$Date_new[i][[1]][3]
  }
}

# löscht alle Zeilen, die keine richtige Datierung haben
beazley <- beazley[-which(is.na(beazley$DAT_min)),]

# entfernt die beiden nicht mehr benötigten Spalten
beazley$Date_new <- NULL
beazley$Date <- NULL

# konvertiert die neue Datierung in numerisches Format
beazley$DAT_min <- as.numeric(beazley$DAT_min)
beazley$DAT_max <- as.numeric(beazley$DAT_max)

# zu viele verschiedene Namen!
unique(beazley$Shape.Name)

# neuer df für die Übersetzung der Shape.Name-Variablen
names <- as.data.frame(matrix(ncol = 2, nrow = length(unique(beazley$Shape.Name))))
names$V1 <- as.character(unique(beazley$Shape.Name))
# trennt den Inhalt wieder an Leerzeichen
names$V2  <- strsplit(names$V1, " ")
names$V3 <- NA

# neuer Loop um die benutzbaren Namen zu extrahieren:
for (i in 1:nrow(names)) {
  names$V3[i] <- names$V2[i][[1]][1]
}

# Kommata löschen
names$V3 <- gsub(names$V3, pattern = ",", replacement = "")
# Fragezeichen löschen
names$V3 <- gsub(names$V3, pattern = "(?)", replacement = "", fixed = TRUE)

names$V3 <- gsub(names$V3, pattern = "PANATHENAIC", replacement = "AMPHORA")
names$V3 <- gsub(names$V3, pattern = "PSEUDO", replacement = "AMPHORA")
names$V3 <- gsub(names$V3, pattern = "UNKNOWN", replacement = "NA")

# Zeigt die einzelnen Namen
unique(names$V3)

# Löscht Spalte 2, die wir nicht mehr brauchen
names$V2 <- NULL
# eine neue Spalte namens 'Shape'
beazley$Shape <- NA

# Fügt die passende, neue Gefäßform in den dataframe ein:
for (i in 1:nrow(names)) {
  beazley$Shape[which(beazley$Shape.Name == names$V1[i])] <- names$V3[i]
}

# die alten Namen können entfernt werden
beazley$Shape.Name <- NULL





#####################

# Provenienz umformatieren

# (noch nicht super.)



places <- as.data.frame(matrix(ncol = 2, nrow = length(unique(beazley$Provenance))))
places$V1 <- as.character(unique(beazley$Provenance))
places$V2  <- strsplit(places$V1, " ")


places$V3 <- NA
places$V4 <- NA
places$V5 <- NA

for (i in 1:nrow(places)) {
  places$V3[i] <- places$V2[i][[1]][1]
  places$V4[i] <- places$V2[i][[1]][2]
  places$V5[i] <- places$V2[i][[1]][3]
}

for (i in 3:5) {
  places[,i] <- gsub(places[,i], pattern = ",", replacement = "")
  places[,i] <- gsub(places[,i], pattern = "(?)", replacement = "", fixed = TRUE)
}

places$V2 <- NULL

unique(places$V3)
places$V3[which(is.na(places$V3))] <- "UNKNOWN"

for (i in 1:nrow(places)) {
  if (places$V3[i] == "ATHENS" || places$V3[i] == "ATTICA" ) {
    places$V5[i] <- places$V4[i]
    places$V4[i] <- places$V3[i]
    places$V3[i] <- "GREECE"
  }
}

unique(places$V4)

beazley$Provenance_full <- beazley$Provenance
beazley$Provenance_city <- NA
beazley$Provenance <- as.character(beazley$Provenance)

for (i in 1:nrow(places)) {
  beazley$Provenance[which(beazley$Provenance_full == places$V1[i])] <- places$V3[i]
  beazley$Provenance_city[which(beazley$Provenance_full == places$V1[i])] <- places$V4[i]
}

unique(beazley$Provenance)

## Daten speichern.
write.table(df, 
            file = "data/prep/beazley_clean_v3.csv", 
            sep = ";", 
            col.names = TRUE, 
            row.names = FALSE)


