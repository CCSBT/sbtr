#' Plot and compare fits to CPUE
#'
#' @param data_objects data objects
#' @param lev_files the lev files
#' @param scenario_names some names
#' @return a ggplot object
#' @importFrom reshape2 melt
#' @importFrom stats quantile
#' @import ggplot2
#' @import dplyr
#' @export
#'
plot_CPUE_fit_comparison <- function(data_objects, lev_files, scenario_names, year_label = NULL) {
  dpred <- NULL
  dobs <- NULL
  for (j in 1:length(data_objects)) {
    dobj <- data_objects[[j]]
    xx <- dobj[[1]]
    years <- xx$yrs.cpue[1]:xx$yrs.cpue[2]
    nyears <- length(years)
    nobjects <- length(dobj)
    npar <- nchar(xx$scenario_number)
    scenario <- vector(length = nobjects)
    oCPUE <- matrix(NA, nobjects, nyears)
    pCPUE <- matrix(NA, nobjects, nyears)

    for (i in 1:nobjects) {
      xx <- dobj[[i]]
      scenario[i] <- xx$scenario_number
      oCPUE[i, ] <- xx$cpue
      pCPUE[i, ] <- xx$cpue.pred
    }

    lev <- read.table(file = lev_files[j], colClasses = "numeric", sep = " ")
    nlevs <- nrow(lev)
    lev.scens <- vector(length = nobjects)
    for (i in 1:nlevs) {
      lev.scens[i] <- as.numeric(paste(lev[i, 1:npar], sep = "", collapse = ""))
    }
    resamps <- match(lev.scens, scenario)
    # result <- list(scenario = lev.scens, years = years, pCPUE = pCPUE[resamps, ], oCPUE = oCPUE[resamps, ])

    # d <- data.frame(result$pCPUE)
    d <- data.frame(pCPUE[resamps, ])
    names(d) <- years
    d <- melt(d) %>%
      mutate(variable = as.character(variable), Scenario = scenario_names[j])
    dpred <- rbind(dpred, d)

    # d <- data.frame(result$oCPUE)
    d <- data.frame(oCPUE)
    names(d) <- years
    d <- melt(d) %>%
      mutate(variable = as.character(variable), Scenario = scenario_names[j])
    dobs <- rbind(dobs, d)
  }

  ggplot(dpred, aes(x = variable, y = value, colour = Scenario, fill = Scenario, group = Scenario)) +
    stat_summary(fun.min = function(x) quantile(x, 0.05), fun.max = function(x) quantile(x, 0.95), geom = "ribbon", alpha = 0.25, colour = NA) +
    stat_summary(fun = function(x) quantile(x, 0.5), geom = "line", lwd = 1) +
    geom_point(data = dobs, aes(x = variable, y = value, colour = Scenario)) +
    labs(x = year_label, y = "CPUE index", colour = "Scenario", fill = "Scenario") +
    scale_y_continuous(limits = c(0, NA), expand = expansion(mult = c(0, 0.05))) +
    theme_bw() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))
}


#' Plot fits to aerial surveys
#'
#' Plots fits of the CCSBT model sbtmod22.tpl to the survey and index data: Aerial survey, troll survey, commercial spotter index, and CPUE index. Produces a four-panel plot with data and model fits to the data. 25 June 2009.
#'
#' @param data_objects data objects
#' @param lev_files the lev files
#' @param scenario_names some names
#' @return a ggplot object
#' @importFrom reshape2 melt
#' @importFrom stats quantile
#' @import ggplot2
#' @import dplyr
#' @export
#'
plot_aerial_survey_fit_comparison <- function(data_objects, lev_files, scenario_names, year_label = NULL) {
  dpred <- NULL
  dobs <- NULL
  for (j in 1:length(data_objects)) {
    dobj <- data_objects[[j]]
    xx <- dobj[[1]]
    years <- xx$Aerial.Surv[,1]
    nyears <- length(years)
    nobjects <- length(dobj)
    npar <- nchar(xx$scenario_number)
    scenario <- vector(length = nobjects)
    oCPUE <- matrix(NA, nobjects, nyears)
    pCPUE <- matrix(NA, nobjects, nyears)

    # years <- x$Aerial.Surv[,1]
    # cpue.obs <- x$Aerial.Surv[,2]
    # cpue.pred <- x$Aerial.Surv[,3]
    # #cpue.pred[cpue.obs < 0] <- NA     #missing years are indicated in the data by -999
    # cpue.obs[cpue.obs < 0] <- NA     #missing years are indicated in the data by -999

    for (i in 1:nobjects) {
      xx <- dobj[[i]]
      scenario[i] <- xx$scenario_number
      oCPUE[i, ] <- xx$Aerial.Surv[,2]
      pCPUE[i, ] <- xx$Aerial.Surv[,3]
    }

    lev <- read.table(file = lev_files[j], colClasses = "numeric", sep = " ")
    nlevs <- nrow(lev)
    lev.scens <- vector(length = nobjects)
    for (i in 1:nlevs) {
      lev.scens[i] <- as.numeric(paste(lev[i, 1:npar], sep = "", collapse = ""))
    }
    resamps <- match(lev.scens, scenario)
    # result <- list(scenario = lev.scens, years = years, pCPUE = pCPUE[resamps, ], oCPUE = oCPUE[resamps, ])

    # d <- data.frame(result$pCPUE)
    d <- data.frame(pCPUE[resamps, ])
    names(d) <- years
    d <- melt(d) %>%
      mutate(variable = as.character(variable), Scenario = scenario_names[j])
    dpred <- rbind(dpred, d)

    # d <- data.frame(result$oCPUE)
    d <- data.frame(oCPUE)
    names(d) <- years
    d <- melt(d) %>%
      mutate(variable = as.character(variable), Scenario = scenario_names[j])
    dobs <- rbind(dobs, d)
  }

  ggplot(dpred, aes(x = variable, y = value, colour = Scenario, fill = Scenario, group = Scenario)) +
    stat_summary(fun.min = function(x) quantile(x, 0.05), fun.max = function(x) quantile(x, 0.95), geom = "ribbon", alpha = 0.25, colour = NA) +
    stat_summary(fun = function(x) quantile(x, 0.5), geom = "line", lwd = 1) +
    geom_point(data = dobs, aes(x = variable, y = value), colour = 'black') +
    labs(x = year_label, y = "Aerial survey index", colour = "Scenario", fill = "Scenario") +
    scale_y_continuous(limits = c(0, NA), expand = expansion(mult = c(0, 0.05))) +
    theme_bw() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))
}


#' Plot fits to troll surveys
#'
#' @param data_objects data objects
#' @param lev_files the lev files
#' @param scenario_names some names
#' @return a ggplot object
#' @importFrom reshape2 melt
#' @importFrom stats quantile
#' @import ggplot2
#' @import dplyr
#' @export
#'
plot_troll_survey_fit_comparison <- function(data_objects, lev_files, scenario_names, year_label = NULL) {
  dpred <- NULL
  dobs <- NULL
  for (j in 1:length(data_objects)) {
    dobj <- data_objects[[j]]
    xx <- dobj[[1]]
    years <- xx$Troll.Index[,1]
    nyears <- length(years)
    nobjects <- length(dobj)
    npar <- nchar(xx$scenario_number)
    scenario <- vector(length = nobjects)
    oCPUE <- matrix(NA, nobjects, nyears)
    pCPUE <- matrix(NA, nobjects, nyears)

    # cpue.obs1 <- x$Troll.Index[,2]
    # cpue.obs2 <- x$Troll.Index[,3]
    # cpue.obs3 <- x$Troll.Index[,4]
    # cpue.pred <- x$Troll.Index[,5]

    for (i in 1:nobjects) {
      xx <- dobj[[i]]
      scenario[i] <- xx$scenario_number
      oCPUE[i, ] <- xx$Troll.Index[,2]
      pCPUE[i, ] <- xx$Troll.Index[,5]
    }

    lev <- read.table(file = lev_files[j], colClasses = "numeric", sep = " ")
    nlevs <- nrow(lev)
    lev.scens <- vector(length = nobjects)
    for (i in 1:nlevs) {
      lev.scens[i] <- as.numeric(paste(lev[i, 1:npar], sep = "", collapse = ""))
    }
    resamps <- match(lev.scens, scenario)
    # result <- list(scenario = lev.scens, years = years, pCPUE = pCPUE[resamps, ], oCPUE = oCPUE[resamps, ])

    # d <- data.frame(result$pCPUE)
    d <- data.frame(pCPUE[resamps, ])
    names(d) <- years
    d <- melt(d) %>%
      mutate(variable = as.character(variable), Scenario = scenario_names[j])
    dpred <- rbind(dpred, d)

    # d <- data.frame(result$oCPUE)
    d <- data.frame(oCPUE)
    names(d) <- years
    d <- melt(d) %>%
      mutate(variable = as.character(variable), Scenario = scenario_names[j])
    dobs <- rbind(dobs, d)
  }

  ggplot(dpred, aes(x = variable, y = value, colour = Scenario, fill = Scenario, group = Scenario)) +
    stat_summary(fun.min = function(x) quantile(x, 0.05), fun.max = function(x) quantile(x, 0.95), geom = "ribbon", alpha = 0.25, colour = NA) +
    stat_summary(fun = function(x) quantile(x, 0.5), geom = "line", lwd = 1) +
    geom_point(data = dobs, aes(x = variable, y = value), colour = 'black') +
    labs(x = year_label, y = "Troll survey index", colour = "Scenario", fill = "Scenario") +
    scale_y_continuous(limits = c(0, NA), expand = expansion(mult = c(0, 0.05))) +
    theme_bw() +
    theme(axis.text.x = element_text(angle = 45, hjust = 1))
}







#' @title Plot fits to troll surveys
#' @description
#' Plots fits of the CCSBT model sbtmod22.tpl to the survey and index data: Aerial survey, troll survey, commercial spotter index, and CPUE index. Produces a four-panel plot with data and model fits to the data. 25 June 2009.
#' @export
#'
plot_troll_survey_fit <- function(data.object,lab.cex=1.1)
{
  x <- data.object
  years <- x$Troll.Index[,1]
  cpue.obs1 <- x$Troll.Index[,2]
  cpue.obs2 <- x$Troll.Index[,3]
  cpue.obs3 <- x$Troll.Index[,4]
  cpue.pred <- x$Troll.Index[,5]

  cpue.obs1[cpue.obs1 < 0] <- NA     #missing years are indicated in the data by -999
  cpue.obs2[cpue.obs2 < 0] <- NA     #missing years are indicated in the data by -999
  cpue.obs3[cpue.obs3 < 0] <- NA     #missing years are indicated in the data by -999
  cpue.pred[is.na(cpue.obs1) & is.na(cpue.obs2) & is.na(cpue.obs3)] <- NA

  ylim <- c(0,1.1*max(c(cpue.obs1,cpue.obs2,cpue.obs3,cpue.pred),na.rm=T))
  par(xpd=T)  # so that the circles exactly on the x-axis are not obscured
  plot(years, cpue.obs1, type="p",cex=1.3,pch=19,col="black", ylim=ylim, las=1,yaxs="i",xlab="",ylab="")
  par(new=T)
  plot(years, cpue.obs2, type="p",cex=1.3,pch=19,col="grey50", ylim=ylim, las=1,yaxs="i",xlab="",ylab="")
  par(new=T)
  plot(years, cpue.obs3, type="p",cex=1.3,pch=19,col="red", ylim=ylim, las=1,yaxs="i",xlab="",ylab="")
  par(new=T)
  plot(years, cpue.pred, type="l",lwd=2,col="blue",ylim=ylim, las=1,yaxs="i",xlab="",ylab="")
  par(xpd=F)

  mtext(side=1,line=2.8,"Year",cex=lab.cex)
  mtext(side=2,line=3,"Troll index",cex=lab.cex)
}
#fit.troll.survey(labrep.file="sbtmod22_lab.rep",lab.cex=1.1)


# @title Plot fits to aerial surveys
# @description
# Plots fits of the CCSBT model sbtmod22.tpl to the survey and index data: Aerial survey, troll survey, commercial spotter index, and CPUE index. Produces a four-panel plot with data and model fits to the data. 25 June 2009.
#
# plot_aerial_survey_fit <- function(data_objects, lab.cex = 1.1) {
#   dobj <- data_objects[[1]]
#   x <- dobj[[1]]
#
#   years <- x$Aerial.Surv[,1]
#   cpue.obs <- x$Aerial.Surv[,2]
#   cpue.pred <- x$Aerial.Surv[,3]
#   #cpue.pred[cpue.obs < 0] <- NA     #missing years are indicated in the data by -999
#   cpue.obs[cpue.obs < 0] <- NA     #missing years are indicated in the data by -999
#
#   ylim <- c(0,1.1*max(c(cpue.obs,cpue.pred),na.rm=T))
#   plot(years, cpue.obs, type="p",cex=1.3,pch=19,col="black", ylim=ylim, las=1,yaxs="i",xlab="",ylab="")
#   par(new=T)
#   plot(years, cpue.pred, type="l",lwd=2,col="blue",ylim=ylim, las=1,yaxs="i",xlab="",ylab="")
#
#   #mtext(side=1,line=2.8,"Year",cex=lab.cex)
#   mtext(side=2,line=3,"Aerial survey index",cex=lab.cex)
# }
#fit.aerial.survey(labrep.file="sbtmod22_lab.rep")



# @title Plot fits to CPUE
# @description
# Plots fits of the CCSBT model sbtmod22.tpl to the survey and index data: Aerial survey, troll survey, commercial spotter index, and CPUE index. Produces a four-panel plot with data and model fits to the data. 25 June 2009. THIS IS JIM
#
# plot_CPUE_index_fit <- function(data_objects, lab.cex = 1.3) {
#   dobj <- data_objects[[1]]
#   x <- dobj[[1]]
#
#   years <- x$yrs.cpue[1]:x$yrs.cpue[2]
#   cpue.obs <- x$cpue
#   cpue.pred <- x$cpue.pred
#
#   ylim <- c(0,1.1*max(c(cpue.obs,cpue.pred)))
#   plot(years, cpue.obs, type="p",cex=1.3,pch=19,col="black", ylim=ylim, las=1,yaxs="i",xlab="",ylab="")
#   par(new=T)
#   plot(years, cpue.pred, type="l",lwd=2,col="blue",ylim=ylim, las=1,yaxs="i",xlab="",ylab="")
#
#   #mtext(side=1,line=2.8,"Year",cex=lab.cex)
#   mtext(side=2,line=3,"CPUE index",cex=lab.cex)
# }



#' @title Plot fits to all surveys
#' @description
#' Plots fits of the CCSBT model sbtmod22.tpl to the survey and index data: Aerial survey, troll survey, commercial spotter index, and CPUE index. Produces a four-panel plot with data and model fits to the data. 25 June 2009.
#' @export
#'
plot_all_survey_fit <- function(data.object, lab.cex=1.1, case_label = "c1s1l1orig.5_h1m1M1O1C2a1")
{
  par(mfrow=c(3,1),oma=c(3,2,1,0),mar=c(2,3,1,1))
  plot_CPUE_index_fit(data.object=data.object,lab.cex=lab.cex)
  plot_aerial_survey_fit(data.object=data.object,lab.cex=lab.cex)
  plot_troll_survey_fit(data.object=data.object,lab.cex=lab.cex)
  mtext(side=3,line=-0.2,outer=T,case_label,cex=0.6)
}
#pdf(file="figs\\SurveyIndexFits.pdf",width=4,height=8)
#win.graph(width=6,height=11.5)
#fit.all(data.object=x[[1]],lab.cex=1.1,case_label="example")
#dev.off()
