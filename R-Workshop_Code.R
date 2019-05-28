## Grundsätzliche Funktionen

# <- Dies ist ein Kommentar!

1

1 + 1

2 + 5

# Variablen: vector
# Werte Variablen zuweisen: <- (oder =)

a <- 9

a

print(a)

b <- 2

b

print(b)


# Variablen verwenden
# Übersichten über die Rechenarten findet ihr überall im Internet. 
a + b
a - b
a * b
a / b
a^b
sqrt(a)

c <- a + b

c

# Variablen mit mehreren Werten

zahlen <- c(1,5,10)

zahlen + a
zahlen * a
zahlen / a

1:5

zahlen <- 1:5

# Einzelwerte aus Variablen/vectoren mit mehreren Werten sind über den Index abrufbar:

zahlen[1]
zahlen[2:3]

zahlen[6] # gibt es nicht! 


# und lassen sich ebenso behandeln wie einzelne Werte:
zahlen[1] + 1
zahlen[1] + a

# Werte vergleichen
a == b # ist a gleich b?
9 == 2 

a != b # ist a ungleich b?
9 != 2

a > b # ist a größer als b?
a >= b # ist a größer gleich b?
9 > 2
9 >= 2

a < b # ist a kleiner als b?
a <= b # ist a kleiner gleich b?
9 < 2
9 <= 2

# Matrix
mat_zahlen <- matrix(nrow = 4, ncol = 5) # nrow = number of rows / Zeilenanzahl, ncol = number of columns = Spaltenanzahl
mat_zahlen[,1:5] <- c(1:4) # Fülle Spalten 1 bis 5 mit dem Vector aus 1 bis 4
mat_zahlen[,1] # Zeige Spalte 1
mat_zahlen[1,] # Zeige Zeile 1
mat_zahlen # Zeige die ganze Matrix

# data.frame
df_zahlen <- data.frame("Eins" = 1:4, "Zwei" = 1:4, "Drei" = 1:4) 
# Erstellte den data.frame mit den Spalten 'Eins', 'Zwei' und 'Drei', in denen jeweils der Vector 1 bis 4 gespeichert wird.

df_zahlen[,1] # Zeige erste Spalte
df_zahlen$Eins # Zeige Spalte namens 'Eins'
df_zahlen[1,] # Zeige die erste Zeile

df_zahlen # Teige den ganzen data.frame



####################################################
# Datentypen

#Erstellen eines data.frame
df_datentypen <- data.frame("character" = 1:4, "factor" = 1:4, "numeric" = 1:4,  "integer" = 1:4,  "logical" = 1:4)

#ginge auch so: 
df_datentypen <- as.data.frame(matrix(ncol = 5, nrow = 4))
# hier wird eine leere Matrix in einen data.frame (df) konvertiert
# und die Spaltennamen müssen noch ein mal extra hinzugefügt werden:
colnames(df_datentypen) <- c("character", "factor", "numeric", "integer", "logical")

# Speichert beispiele in verschiedene vectoren
vec_chr <- as.character(c("Hallo", "Blumen sind schön", "Manchmal jedenfalls", "Kühe aber auch"))
vec_factor <- as.factor(c("a", "a", "b", "b"))
vec_num <- as.numeric(c(1, 2, 2.5, 4))
vec_int <- as.integer(c(1,2,3,4))
vec_logi <- as.logical(TRUE, FALSE, TRUE, FALSE)

# speichert die vectoren in die Spalten des df
df_datentypen$character <- vec_chr
df_datentypen$factor <- vec_factor
df_datentypen$numeric <- vec_num
df_datentypen$integer <- vec_int
df_datentypen$ logical <- vec_logi

# die Funktion str() zeigt die eigenschaften eines Objektes
str(df_datentypen)
str(df_datentypen$factor)

str(vec_factor)

# class() gibt die Klasse des entsprechenden Objektes aus
class(vec_chr)
class(vec_logi)






####################################################
# Einstieg


## Pakete installieren
install.packages("archdata")
library(archdata)

data(BACups)

?BACups

str(BACups)


# Deskriptive Statistik

mean(BACups$RD)       # arithmetisches Mittel
median(BACups$RD)     # Median (Mittelwert)
range(BACups$RD)      # Bandbreite der Werte
min(BACups$RD)        # Kleinster Wert
max(BACups$RD)        # Größter Wert

table(BACups$Phase)   # Frequenztabelle (Häufigkeitstabelle)

# Mittelwert nach Phasen getrennt:

# Auslesen der eindeutigen Werte aus der Spalte 'Phase'
Phases <- unique(BACups$Phase)
Phases

# Speichern der Indizes für beide Phasen in eigenen vectors
ind_phase_a <- which(BACups$Phase == Phases[1])
ind_phase_b <- which(BACups$Phase == Phases[2])

# Mittelwert für beide Phasen
mean(BACups$RD[ind_phase_a])
mean(BACups$RD[ind_phase_b])

# Ein weiterer Weg ans Ziel: 
aggregate(formula = RD ~ Phase, data = BACups, FUN = mean)


# Boxplot
boxplot(BACups$RD)

# Boxplot nach Phasen getrennt
boxplot(RD ~ Phase,
        data = BACups,
        main = "A Boxplot of Rim-Diameters per Phase",
        xlab = "Phase")


plot(x = BACups$RD, y = BACups$ND)
grid()

model_cups <- lm(formula = ND ~ RD, data = BACups)
abline(model_cups, col = "red")

# Ist es signifikant?

cor.test(BACups$RD, BACups$ND)

# p < 0,05, also ist das wohl eine signifikante Korrelation!

model_cups <- lm(formula = RD ~ Phase, data = BACups)
anova(model_cups)


####################################################
# Einstieg

beazley <- read.csv(file = "data/prep/beazley_clean_v2.csv", 
                    sep = ";", 
                    header = TRUE)
head(beazley)

table(beazley$Technique)

barplot(table(beazley$Technique),
        main = "Beazley-Archive: Schwarz- und Rotfigurige Keramik",
        ylab = "Anzahl",
        xlab = "Technik",
        col = c("gray16", "orangered3"),
        ylim = c(0,40000)
)


