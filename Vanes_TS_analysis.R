# 27/01/2022
# Lucy Vanes
# Analysis code for:
# "White matter disruptions related to inattention and 
# autism spectrum symptoms in tuberous sclerosis complex"



##### WORK IN PROGRESS #######

#===============================================================================
library(lattice)
library(jtools)
library(ggplot2)

setwd("C:/Users/vanes/Dropbox/KCL_BMEIS/Tuberous Sclerosis/Analysis")

dat <- read.csv("TS2000_Phase_3_data.csv", header=T)

dat$id <- factor(dat$id)
dat$group <- factor(dat$group)
dat$use_dwi <- factor(dat$use_dwi)
dat$sex <- factor(dat$sex)

aggregate(id ~ group + use_dwi, dat, length)

# t-tests
#==============
t.test(WASI_FSIQ ~ group, dat[dat$use_dwi==1,], var.equal=T)
t.test(SRS2_SC_Tscore ~ group, dat[dat$use_dwi==1,], var.equal=T)
t.test(SRS2_RRB_Tscore ~ group, dat[dat$use_dwi==1,], var.equal=T)
t.test(Conners_DSM4_Inattention_Tscore ~ group, dat[dat$use_dwi==1,], var.equal=T)
t.test(Conners_DSM4_HypImp_Tscore ~ group, dat[dat$use_dwi==1,], var.equal=T) # no difference

#=======================================================================
#                   Interrogate MRI results
#=======================================================================

fixels <- read.csv("sig_cluster_means_new.csv", header=T,fileEncoding="UTF-8-BOM")
fixels$id <- factor(fixels$id)

dat <- merge(dat, fixels, by="id")


# FDC clusters
#==============
# R SLF-I
ggplot(dat, aes(y=FDC_R_SLF, x=group)) + 
  geom_boxplot() +
  xlab("Group") + ylab("Mean FDC")
t.test(FDC_R_SLF ~ group, dat)

# R ILF
ggplot(dat, aes(y=FDC_R_ILF, x=group)) + 
  geom_boxplot() +
  xlab("Group") + ylab("Mean FDC")
t.test(FDC_R_ILF ~ group, dat)

# L ILF
ggplot(dat, aes(y=FDC_L_ILF, x=group)) + 
  geom_boxplot() +
  xlab("Group") + ylab("Mean FDC")
t.test(FDC_L_ILF ~ group, dat)


# FD cluster
#=============

ggplot(dat, aes(y=FD_cluster_meanFD, x=group)) + 
  geom_boxplot() +
  xlab("Group") + ylab("Mean FD")

ggplot(dat, aes(y=FD_cluster_meanFDC, x=group)) + 
  geom_boxplot() +
  xlab("Group") + ylab("Mean FDC")

ggplot(dat, aes(y=FD_cluster_meanFC, x=group)) + 
  geom_boxplot() +
  xlab("Group") + ylab("Mean (log) FC")

# log FC cluster
#==================
ggplot(dat, aes(y=FC_cluster_meanFC, x=group)) + 
  geom_boxplot() +
  xlab("Group") + ylab("Mean (log) FC")

ggplot(dat, aes(y=FC_cluster_meanFDC, x=group)) + 
  geom_boxplot() +
  xlab("Group") + ylab("Mean FDC")

ggplot(dat, aes(y=FC_cluster_meanFD, x=group)) + 
  geom_boxplot() +
  xlab("Group") + ylab("Mean FD")


#========================================================
#      Brain-behaviour relationships
#========================================================

vars <- c("WASI_FSIQ", "SRS2_SC_Tscore","SRS2_RRB_Tscore", "Conners_DSM4_Inattention_Tscore")

# association between each behavioural variable and each cluster
#==================================================================
for (v in vars){
  print(v)
  print("===========================", quote=F)
  print("##        FDC           ##")
  print(summary(lm(as.formula(paste(v, "~  FDC_R_SLF+ age + sex + Scanner_id")), dat[dat$group=="TS",])))
  print(summary(lm(as.formula(paste(v, "~  FDC_R_ILF+ age + sex + Scanner_id")), dat[dat$group=="TS",])))
  print(summary(lm(as.formula(paste(v, "~  FDC_L_ILF+ age + sex + Scanner_id")), dat[dat$group=="TS",])))

    print("##        FD           ##")
  print(summary(lm(as.formula(paste(v, "~  FD_cluster_meanFD + age + sex + Scanner_id")), dat[dat$group=="TS",])))

  print("##        Log FC           ##")
  print(summary(lm(as.formula(paste(v, "~  FC_cluster_meanFC + age + sex + Scanner_id")), dat[dat$group=="TS",])))

}

# FD/log-FC in individual FDC tracts:
#========================================
for (v in vars){
  print(v)
  print("===========================", quote=F)
  print("##        FD           ##")
  print(summary(lm(as.formula(paste(v, "~  FD_R_ILF+ age + sex + Scanner_id")), dat[dat$group=="TS",])))
  print(summary(lm(as.formula(paste(v, "~  FD_L_ILF+ age + sex + Scanner_id")), dat[dat$group=="TS",])))
  print(summary(lm(as.formula(paste(v, "~  FD_R_SLF+ age + sex + Scanner_id")), dat[dat$group=="TS",])))
}

for (v in vars){
  print(v)
  print("===========================", quote=F)
  print("##        FC           ##")
  print(summary(lm(as.formula(paste(v, "~  FC_R_ILF+ age + sex + Scanner_id")), dat[dat$group=="TS",])))
  print(summary(lm(as.formula(paste(v, "~  FC_L_ILF+ age + sex + Scanner_id")), dat[dat$group=="TS",])))
  print(summary(lm(as.formula(paste(v, "~  FC_R_SLF+ age + sex + Scanner_id")), dat[dat$group=="TS",])))
}

# IQ: all n.s.
#==============

# SRS: significant effects for:
#=========================================
# - FDC: mean FDC, mean FD
# - FD: /
# - FC: /
fit1 <- lm(SRS2_SC_Tscore ~ FDC_cluster_meanFDC+ age + sex + Scanner_id, dat[dat$group=="TS",])
summary(fit1)
effect_plot(fit1, pred=FDC_cluster_meanFDC, plot.points=T, interval=T, 
            partial.residuals=T, y.label="SRS total (partial residuals)")

fit1 <- lm(SRS2_SC_Tscore ~ FDC_R_SLF + age + sex + Scanner_id, dat[dat$group=="TS",])
summary(fit1)
effect_plot(fit1, pred=FDC_R_SLF, plot.points=T, interval=T, 
            partial.residuals=T, y.label="SRS SCI (partial residuals)")

fit1 <- lm(SRS2_RRB_Tscore ~ FDC_R_SLF + age + sex + Scanner_id, dat[dat$group=="TS",])
summary(fit1)
effect_plot(fit1, pred=FDC_R_SLF, plot.points=T, interval=T, 
            partial.residuals=T, y.label="SRS RRB (partial residuals)")

# FD in R SLF
fit1 <- lm(SRS2_SC_Tscore ~ FD_R_SLF + age + sex + Scanner_id, dat[dat$group=="TS",])
summary(fit1)
effect_plot(fit1, pred=FD_R_SLF, plot.points=T, interval=T, 
            partial.residuals=T, y.label="SRS SCI (partial residuals)")
# FC in R SLF
fit1 <- lm(SRS2_RRB_Tscore ~ FD_R_SLF + age + sex + Scanner_id, dat[dat$group=="TS",])
summary(fit1)
effect_plot(fit1, pred=FD_R_SLF, plot.points=T, interval=T, 
            partial.residuals=T, y.label="SRS RRB (partial residuals)")






# Conners inattention: significant effect for:
#===================================================
# FDC: mean FDC, mean FD
# - FD: /
# - FC: /
fit4 <- lm(Conners_DSM4_Inattention_Tscore ~ FDC_cluster_meanFDC + age + sex + Scanner_id, dat[dat$group=="TS",])
summary(fit4)
effect_plot(fit4, pred=FDC_cluster_meanFDC, plot.points=T, interval=T, 
            partial.residuals=T, y.label="Inattention (partial residuals)")

fit4 <- lm(Conners_DSM4_Inattention_Tscore ~ FDC_R_ILF + age + sex + Scanner_id, dat[dat$group=="TS",])
summary(fit4)
effect_plot(fit4, pred=FDC_R_ILF, plot.points=T, interval=T, 
            partial.residuals=T, y.label="Inattention (partial residuals)")

fit4 <- lm(Conners_DSM4_Inattention_Tscore ~ FD_R_ILF + age + sex + Scanner_id, dat[dat$group=="TS",])
summary(fit4)
effect_plot(fit4, pred=FD_R_ILF, plot.points=T, interval=T, 
            partial.residuals=T, y.label="Inattention (partial residuals)")




# Effect of tubers
#==============================
# FDC in FDC cluster

fit_tot <- lm(FDC_R_SLF ~ Comb_tubtot + age + sex + Scanner_id, dat[dat$group=="TS",])
summary(fit_tot)

fit_tot <- lm(FDC_R_ILF ~ Comb_tubtot + age + sex + Scanner_id, dat[dat$group=="TS",])
summary(fit_tot)

fit_tot <- lm(FDC_L_ILF ~ Comb_tubtot + age + sex + Scanner_id, dat[dat$group=="TS",])
summary(fit_tot)

#======================
# FD in FD cluster

fit_tot <- lm(FD_cluster_meanFD ~ Comb_tubtot + age + sex + Scanner_id, dat[dat$group=="TS",])
summary(fit_tot)
effect_plot(fit_tot, pred=Comb_tubtot, plot.points=T, interval=T, partial.residuals=T, x.label="Total number of tubers", y.label="FD")


#======================
# FC in FC cluster

fit_tot <- lm(FC_cluster_meanFC ~ Comb_tubtot + age + sex + Scanner_id, dat[dat$group=="TS",])
summary(fit_tot)


#==============================
# Effect of age of seizure onset
#==============================
# FDC in FDC cluster

fit_szr <- lm(FDC_R_SLF ~ age_seizure_onset + age + sex + Scanner_id, dat[dat$group=="TS",])
summary(fit_szr)
effect_plot(fit_szr, pred=age_seizure_onset, plot.points=T, interval=T, partial.residuals=T, x.label="Age at onset of seizures (months)", y.label="FDC")


fit_szr <- lm(FDC_R_ILF ~ age_seizure_onset + age + sex + Scanner_id, dat[dat$group=="TS",])
summary(fit_szr)

fit_szr <- lm(FDC_L_ILF ~ age_seizure_onset + age + sex + Scanner_id, dat[dat$group=="TS",])
summary(fit_szr)

#======================
# FD in FD cluster

fit_szr <- lm(FD_cluster_meanFD ~ age_seizure_onset + age + sex + Scanner_id, dat[dat$group=="TS",])
summary(fit_szr)


#======================
# FC in FC cluster

fit_szr <- lm(FC_cluster_meanFC ~ age_seizure_onset + age + sex + Scanner_id, dat[dat$group=="TS",])
summary(fit_szr)



#====================================
# History of infantile spasms
#====================================
dat$history_IS <- factor(dat$history_IS)

fit_is <- lm(FDC_R_SLF ~ history_IS + age + sex + Scanner_id, dat[dat$group=="TS",])
summary(fit_is)

fit_is <- lm(FDC_R_ILF ~ history_IS + age + sex + Scanner_id, dat[dat$group=="TS",])
summary(fit_is)

fit_is <- lm(FDC_L_ILF ~ history_IS + age + sex + Scanner_id, dat[dat$group=="TS",])
summary(fit_is)

fit_is <- lm(FD_cluster_meanFD ~ history_IS + age + sex + Scanner_id, dat[dat$group=="TS",])
summary(fit_is)

fit_is <- lm(FC_cluster_meanFC ~ history_IS + age + sex + Scanner_id, dat[dat$group=="TS",])
summary(fit_is)

#====================================
# Infantile spasm severity- Year 1
#====================================

fit_is <- lm(FDC_R_SLF ~ IS_y2 + age + sex + Scanner_id, dat[dat$group=="TS",])
summary(fit_is)

fit_is <- lm(FDC_R_ILF ~ IS_y2 + age + sex + Scanner_id, dat[dat$group=="TS",])
summary(fit_is)

fit_is <- lm(FDC_L_ILF ~ IS_y2 + age + sex + Scanner_id, dat[dat$group=="TS",])
summary(fit_is)

fit_is <- lm(FD_cluster_meanFD ~ IS_y2 + age + sex + Scanner_id, dat[dat$group=="TS",])
summary(fit_is)

fit_is <- lm(FC_cluster_meanFC ~ IS_y2 + age + sex + Scanner_id, dat[dat$group=="TS",])
summary(fit_is)

#====================================
# non-spasm seizure severity- Year 1
#====================================

fit_is <- lm(FDC_R_SLF ~ seizure_y2 + age + sex + Scanner_id, dat[dat$group=="TS",])
summary(fit_is)

fit_is <- lm(FDC_R_ILF ~ seizure_y2 + age + sex + Scanner_id, dat[dat$group=="TS",])
summary(fit_is)

fit_is <- lm(FDC_L_ILF ~ seizure_y2 + age + sex + Scanner_id, dat[dat$group=="TS",])
summary(fit_is)

fit_is <- lm(FD_cluster_meanFD ~ seizure_y2 + age + sex + Scanner_id, dat[dat$group=="TS",])
summary(fit_is)

fit_is <- lm(FC_cluster_meanFC ~ seizure_y2 + age + sex + Scanner_id, dat[dat$group=="TS",])
summary(fit_is)
