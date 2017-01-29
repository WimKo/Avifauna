require(data.table)

load(paste(getwd(), "/1. Data/Cleaned Data/Waarnemingen.RData", sep=""))
load(paste(getwd(), "/1. Data/Cleaned Data/Avifauna.RData", sep=""))

Avifauna$Datum=as.Date(Avifauna$Datum, "%d/%m/%Y")

Waarnemingen=as.data.frame(Waarnemingen)
Waarnemingen=data.table(Waarnemingen)
Avifauna=data.table(Avifauna)

Status=unique(Waarnemingen[,list(Naam=Naam, Soortstatus=Soortstatus)])


Waarnemingen=Waarnemingen[, list(Datum=Datum, Naam=Naam, Aantal=Aantal)]
Avifauna=Avifauna[, list(Datum=Datum, Naam=Soort, Aantal=Aantal)]


Waarnemingen=rbind(Waarnemingen, Avifauna)
Waarnemingen[, Jaar:=year(Datum)]


Waarnemingen=Waarnemingen[!grep("Hybride", Waarnemingen$Naam),]
Waarnemingen=Waarnemingen[!grep("onbekend", Waarnemingen$Naam),]
Waarnemingen=Waarnemingen[!grep(" X ", Waarnemingen$Naam),]

Waarnemingen[, Status:=Status[match(Waarnemingen$Naam, Status$Naam), Soortstatus]]
Waarnemingen=unique(Waarnemingen)

Table=dcast(data=Waarnemingen[Jaar>=2002 & Status=="Native",], Naam~Jaar, fun.aggregate=length, value.var="Datum")
Table=data.frame(Table)
Table[, 17]=rowSums(Table[, -1])

Table=Table[order(Table$V17),]
rownames(Table)=1:nrow(Table)
write.csv2(Table, "Table.csv")
