####################################################
# Einfache Plots

boxplot(BACups)  # automatisch erstellter Boxplot ohne jede Beschriftung

# Mit Titel und notches, ohne das diskrete Merkmal in Spalte 6:
boxplot(BACups[,-6], 
        main = "Measurements on Early and Late Bronze Age ceramic cups from Italy\n analyzed by Lukesh and Howe (1978)",
        xlab = "Variable",
        ylab = "Measurements", notch = TRUE)
grid()

#### Getrennt nach Phasen:

# Daten umformatieren:
library(reshape2)
BACups_melt <- melt(BACups, by = Phase)
head(BACups_melt)

# neuer Boxplot: 
boxplot(value ~ Phase * variable, data = BACups_melt, 
        col = c("chartreuse3", "darkblue"), las = 2)

# (zum Nachlesen: <https://www.statmethods.net/graphs/boxplot.html>)

### Einfache Plots mit ggplot!

library(ggplot2)

ggplot(BACups_melt, aes(x = variable, y = value, fill = Phase)) +
  geom_boxplot() + theme(legend.position="top")


ggplot(BACups_melt, aes(x = variable, y = value, fill = Phase)) +
  geom_boxplot(notch = TRUE, alpha = 0.5) + 
  theme(legend.position="bottom", panel.background = element_blank(),
        panel.grid.major = element_line(linetype = "dotted", colour = "black"),
        panel.grid.minor = element_line(linetype = "dotted", colour = "gray54")) +
  scale_fill_manual(values = c("chartreuse3", "darkblue")) +
  labs(title = "Measurements on Early and Late Bronze Age ceramic cups from Italy",
       subtitle = "analyzed by Lukesh and Howe (1978)",
       caption = "Source: 'archdata' on CRAN") + 
  ylab("Measurements in cm") +
  scale_x_discrete(labels = c("RD" = "Rim", "ND" = "Neck", 
                              "SD" = "Shoulder", "H" = "total\nHeight", 
                              "NH" = "Height\n(Neck"),
                   name = "")


## Als Violinplot
dodge <- position_dodge(width = 0.4)
ggplot(BACups_melt, aes(x = Phase, y = value, fill = Phase)) +
  geom_violin(alpha = 0.5, position = dodge)  + 
  geom_boxplot(width=0.1, position = dodge) +
  facet_wrap(~variable) +
  theme(legend.justification=c(1,0), legend.position=c(.95,0.1))


## Einfache Plots (base r) : Barplots

barplot(table(beazley$Shape))

tbl_shape <- table(beazley$Shape)
tbl_shape <- tbl_shape[which(tbl_shape > 1000)]
barplot(tbl_shape)


barplot(sort(tbl_shape, decreasing = TRUE), 
        main = "Beazley-Archive: Gefäßformen", cex.names = 0.8,
        ylab = "Anzahl", xlab = "Form", ylim = c(0,20000),
        col = rainbow(n = length(tbl)), las = 2)


## Barplots mit ggplot!
ggplot(data = beazley, aes(x = Shape, fill = Technique)) +
  geom_bar(stat = "count")


# xlim bestimmt, welche Werte in der x-Achse dargestellt werden
ggplot(data = beazley, aes(x = Shape, fill = Technique)) +
  geom_bar(stat = "count", position = "dodge") +
  xlim(names(sort(table(beazley$Shape), decreasing=TRUE)[1:10]))

# weitere verbesserungen
ggplot(data = beazley, aes(x = Shape, fill = Technique)) +
  geom_bar(stat = "count", position = "dodge") +
  xlim(names(sort(table(beazley$Shape), decreasing=TRUE)[1:10])) +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        panel.background = element_blank(),
        panel.grid.major = element_blank(),
        panel.grid.minor = element_blank(),
        panel.grid.major.y = element_line(linetype = "dashed", color = "gray16"),
        legend.justification=c(1,0), legend.position=c(.95,0.7),
        legend.box.background = element_rect(colour = "black")) +
  labs(title = "Beazley Archive Pottery Database: Black- and Red-Figure Pottery Shapes",
       subtitle = "the 10 most common shapes",
       caption = "Source: https://www.beazley.ox.ac.uk/pottery/") +
  ylab("Number of entries / vases") +
  scale_fill_manual(values = c("gray30", "tomato3"))
  
