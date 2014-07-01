
##clicks data
x <- 5:8  ## give the week subscripts 
y <- paste0("Week_",x) ## creating the week vector

inputs <- vector("list",4)  #empty list for the loop

##adding the week stamp in each data set
for( i in seq_along(x)) {
  
    inputs[[i]] <- read.delim(paste0("clicks_",x[i],".csv"),header=T, stringsAsFactors=F)
    inputs[[i]] <- cbind(inputs[[i]], week = rep(y[i],nrow(inputs[[i]])))
    
  }
  

results <- do.call("rbind",inputs) ##putting together the results

results$week <- as.character(results$week)
results$one.clicks <- NULL

##reshaping the data to long format for a stack chart

require(reshape2)
mltd_results <- melt(data = results,id.vars = c( "net.name","net.id","site.name","site.id","week"),value.name = 'Traffic')


require(dplyr)

grouped <- group_by(results,week,net.id,net.name)

##aggregate by sites

agg_traffic <- summarise(grouped,
                         pi = sum(pi),
                         uc = sum(uc),
                         qc = sum(qc))

mltd_traffic_net <- melt(agg_traffic,id.vars = c("week","net.id","net.name"),value.name = 'Traffic')


networks <- unique(agg_traffic$net.name[order(agg_traffic$net.name)])



# Survey Part -------------------------------------------------------------

    
## data
survey <- read.delim("survey.csv",header=F,stringsAsFactors=F)
##col names
names(survey) <- c("survey.id", "user","site.id", "net.id", "answer", "timestamp")


##making a variable for the completed surveys

splitting <- function(x) {
  r = regexpr("S8",x)
  result = substr(x,r,r+1)
  result
}
survey <- transform(survey, completed = splitting(answer))
survey$completed <- ifelse(survey$completed == "S8",1,0)



## grouping the survey data by net & counting the completed surveys
 grouped_net <- group_by(survey,net.id)
 agg_surveys_net <- summarise(grouped_net,
                             surveys = n(),
                             compl_sur = sum(completed))

##grouping the survey data by site
 grouped_site <- group_by(survey,net.id,site.id)
 agg_surveys_site <- summarise(grouped_site, 
                              surveys = n(),
                              compl_sur = sum(completed))







