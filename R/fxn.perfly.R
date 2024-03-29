perfly <- function(RawData) {
  Data <- dplyr::rename(RawData, Event = IntDeaths, Censor = Censored, Vial = Collective)
  Data <- dplyr::select(Data, AgeH, Vial, UniqueName, Event, Censor)

  DeathData <- dplyr::filter(Data, Event > 0)
  DeathData <- splitstackshape::expandRows(DeathData, "Event")
  DeathData <- dplyr::mutate(DeathData, Event = 2)
  DeathData <- dplyr::mutate(DeathData, Censor = 0)

  CensorData <- dplyr::filter(Data, Censor > 0)
  CensorData <- splitstackshape::expandRows(CensorData, "Censor")
  CensorData <- dplyr::mutate(CensorData, Censor = 1)
  CensorData <- dplyr::mutate(CensorData, Event = 0)
  CensorData <- dplyr::select(CensorData, AgeH, Vial, UniqueName, Censor, Event)

  PerFly <- rbind(CensorData, DeathData)
  PerFly <- splitstackshape::cSplit(PerFly, "UniqueName", sep = "/", fixed = FALSE, type.convert = F)

  PerFly$Event <- sub('0', '1', PerFly$Event)
  PerFly$Event <- as.numeric(PerFly$Event)

  PerFly$AgeH <- format(round(PerFly$AgeH, 2), nsmall = 2)
  PerFly$AgeH <- as.double(PerFly$AgeH)

  return(PerFly)

   }
