\name{perfly}
\alias{perfly}
\title{
Makes DLife data tidy
}
\description{
The function takes the "per census" output from DLife and transforms it into a "per fly" layout. Each row is the outcome of a single fly
}
\usage{
perfly(RawData)
}
\arguments{
  \item{RawData}{
RawData is the data from the "RawData" tab of the DLife generated xlsx
}
}

\value{
perfly
}
\author{
Tahlia Fulton
}
\examples{
##---- Should be DIRECTLY executable !! ----
##-- ==>  Define data, use random,
##--	or do  help(data=index)  for the standard data sets.

## The function is currently defined as
function (RawData)
{
    usethis::use_package("dplyr")
    usethis::use_package("splitstackshape")
    Data <- dplyr::rename(RawData, Event = IntDeaths, Censor = Censored,
        Vial = Collective)
    Data <- dplyr::select(Data, AgeH, Vial, UniqueName, Event,
        Censor)
    DeathData <- dplyr::filter(Data, Event > 0)
    DeathData <- splitstackshape::expandRows(DeathData, "Event")
    DeathData <- dplyr::mutate(DeathData, Event = 2)
    DeathData <- dplyr::mutate(DeathData, Censor = 0)
    CensorData <- dplyr::filter(Data, Censor > 0)
    CensorData <- splitstackshape::expandRows(CensorData, "Censor")
    CensorData <- dplyr::mutate(CensorData, Censor = 1)
    CensorData <- dplyr::mutate(CensorData, Event = 0)
    CensorData <- dplyr::select(CensorData, AgeH, Vial, UniqueName,
        Censor, Event)
    PerFly <- rbind(CensorData, DeathData)
    PerFly <- splitstackshape::cSplit(PerFly, "UniqueName", sep = "/",
        fixed = FALSE)
    PerFly$Event <- gsub("0", "1", PerFly$Event)
    PerFly$Event <- as.numeric(PerFly$Event)
    PerFly$AgeH <- format(round(PerFly$AgeH, 2), nsmall = 2)
    PerFly$AgeH <- as.double(PerFly$AgeH)
    return(PerFly)
  }
}
% Add one or more standard keywords, see file 'KEYWORDS' in the
% R documentation directory (show via RShowDoc("KEYWORDS")):
% \keyword{ ~kwd1 }
% \keyword{ ~kwd2 }
% Use only one keyword per line.
% For non-standard keywords, use \concept instead of \keyword:
% \concept{ ~cpt1 }
% \concept{ ~cpt2 }
% Use only one concept per line.
