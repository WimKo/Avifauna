
require(XML)
require(data.table)

Avifauna=list()

URL="http://www.noorderkempen.be/avifauna/forms/vogelopzoek.asp?page=1&sort=1&soort=&gebied=&zone=&van=01/01/1900&tot=01/01/2017&waarn=&selek="

for (i in 1:2966) {
  URL=paste("http://www.noorderkempen.be/avifauna/forms/vogelopzoek.asp?page=",
            i,
            "&sort=1&soort=&gebied=&zone=&van=01/01/1900&tot=01/01/2017&waarn=&selek=", sep="")

  Avifauna[[i]]=readHTMLTable(URL)[[8]]
  print(i)
}

Avifauna=rbindlist(Avifauna)

path=paste(getwd(), "/1. Data/Cleaned Data/Avifauna.RData", sep="")
save(Avifauna, file=path)