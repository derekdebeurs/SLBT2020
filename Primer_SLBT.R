## R code for the paperA network perspective on suicidal behavior: understanding suicidality using a complex dynamic systems approach

## Derek de Beurs, Claudi Bockting, Ad Kerkhof, Floor Scheepers, Rory C O'Connor, Brenda Penninx, Ingrid van de Leemput

## install packages
list.of.packages <- c("bootnet", "qgraph", "RCurl", "mlVAR" )
new.packages <- list.of.packages[!(list.of.packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) install.packages(new.packages)

## figure 3

library(qgraph)  ## One always needs to load the packages into a new R session
example <- matrix ( c(0,4,3,
                      4,0,0, 
                      3,0,0), nrow=3, 
                    ncol=3)

colnames(example) <- c("Cog","Ent", "SI")
qgraph(example, layout = "circle", vsize = 15)

## figure 4

library(RCurl)
library(qgraph)
x <- getURL("https://raw.githubusercontent.com/derekdebeurs/SLBT2020/master/data_slbt.csv")
data <- read.csv(text = x)
data <- data[,-1]
Network1 <-estimateNetwork(data, default = "EBICglasso")
plot(Network1, layout = 'spring', cut = 0)

## Figure 5

library(bootnet)
boot1a <- bootnet(Network1, default ="EBICglasso", nBoots = 1000, nCores = 8)
plot(boot1a, labels = FALSE, order = "sample")

## figure 7

centralityPlot(Network1, orderBy = "Strength")

z <- getURL("https://raw.githubusercontent.com/derekdebeurs/SLBT2020/master/IMV.csv")
data_IMV <- read.csv(text = z)
data_IMV <- data_IMV[,-1]


Network2 <- bootnet_mgm(data_IMV, type = c( rep("g", 5), rep("c",1)),
                        level = c(rep(1, 5), rep(2,1)), tuning = 0.5, 
                        verbose = TRUE, criterion =
              c( "CV"), nFolds = 10, order = 2, rule =
              c("AND"), binarySign= TRUE)


## Figure 9

library("mlVAR")

S <- getURL("https://raw.githubusercontent.com/derekdebeurs/SLBT2020/master/BringmannData.csv")
data <- read.csv(text = S, sep = ",")
vars<-c("cheerful","pleasant","worry","fearful","sad","relaxed")
idvar<-"id"
beepvar<-"beep"
dayvar<-"day"
res<-mlVAR(data, vars, idvar, dayvar, beepvar,lags=1,temporal="correlated",contemporaneous="correlated")

## figure 15

K <- getURL("https://raw.githubusercontent.com/derekdebeurs/SLBT2020/master/ESMdata.txt")
data_EMA <- read.csv(text = K, sep = "")
ts.plot(data_EMA$mood_down,col="mediumseagreen",lwd=2, ylab= "Mood_down")



