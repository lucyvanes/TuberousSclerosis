# 27/01/2022
# Lucy Vanes
# Analysis code for:
# "White matter disruptions related to inattention and 
# autism spectrum symptoms in tuberous sclerosis complex"




#===============================================================================
library(lattice)
library(jtools)
library(ggplot2)

setwd("C:/Users/vanes/OneDrive/Documents/GitHub/TuberousSclerosis/Data")

dat <- read.csv("TS2000_dwi_psych.csv", header=T)

dat$id <- factor(dat$id)
dat$group <- factor(dat$group)
dat$sex <- factor(dat$sex)

aggregate(id ~ group, dat, length)

# t-tests
#==============
t.test(WASI_FSIQ ~ group, dat, var.equal=T)
t.test(SRS2_SC ~ group, dat, var.equal=T)
t.test(SRS2_RRB ~ group, dat, var.equal=T)
t.test(Conners_DSM4_Inattention ~ group, dat, var.equal=T)
t.test(Conners_DSM4_HypImp ~ group, dat, var.equal=T) # no difference

# Correlations
#================


#=======================================================================
#                   Interrogate MRI results
#=======================================================================

# FDC clusters
#==============
# R SLF-I
ggplot(dat, aes(y=FDC_cluster1_fdc, x=group)) + 
  geom_boxplot() +
  xlab("Group") + ylab("Mean FDC")

# L ILF
ggplot(dat, aes(y=FDC_cluster2_fdc, x=group)) + 
  geom_boxplot() +
  xlab("Group") + ylab("Mean FDC")

# L ILF
ggplot(dat, aes(y=FDC_cluster3_fdc, x=group)) + 
  geom_boxplot() +
  xlab("Group") + ylab("Mean FDC")


# FD cluster
#=============

ggplot(dat, aes(y=FD_cluster1, x=group)) + 
  geom_boxplot() +
  xlab("Group") + ylab("Mean FD")

# log FC cluster
#==================
ggplot(dat, aes(y=FC_cluster1, x=group)) + 
  geom_boxplot() +
  xlab("Group") + ylab("Mean (log) FC")


#========================================================
#      Brain-behaviour relationships
#========================================================

vars <- c("WASI_FSIQ", "SRS2_SC","SRS2_RRB", "Conners_DSM4_Inattention")

# association between each behavioural variable and each cluster
#==================================================================
for (v in vars){
  print(v)
  print("===========================", quote=F)
  print("##        FDC           ##")
  print(summary(lm(as.formula(paste(v, "~  FDC_cluster1_fdc+ age + sex + Scanner_id")), dat[dat$group=="TS",])))
  print(summary(lm(as.formula(paste(v, "~  FDC_cluster2_fdc+ age + sex + Scanner_id")), dat[dat$group=="TS",])))
  print(summary(lm(as.formula(paste(v, "~  FDC_cluster3_fdc+ age + sex + Scanner_id")), dat[dat$group=="TS",])))

    print("##        FD           ##")
  print(summary(lm(as.formula(paste(v, "~  FD_cluster1 + age + sex + Scanner_id")), dat[dat$group=="TS",])))

  print("##        Log FC           ##")
  print(summary(lm(as.formula(paste(v, "~  FC_cluster1 + age + sex + Scanner_id")), dat[dat$group=="TS",])))

}

#===========================
#     Summarise results
#===========================

# IQ --> all n.s.
#==================

# SRS-SCI and SRS-RRB --> significant effect for FDC in R SLF (cluster 1):
#=========================================================================

fit1 <- lm(SRS2_SC ~ FDC_cluster1_fdc + age + sex + Scanner_id, dat[dat$group=="TS",])
summary(fit1)
effect_plot(fit1, pred=FDC_cluster1_fdc, plot.points=T, interval=T, 
            partial.residuals=T, y.label="SRS SCI (partial residuals)")

fit2 <- lm(SRS2_RRB ~ FDC_cluster1_fdc + age + sex + Scanner_id, dat[dat$group=="TS",])
summary(fit2)
effect_plot(fit2, pred=FDC_cluster1_fdc, plot.points=T, interval=T, 
            partial.residuals=T, y.label="SRS RRB (partial residuals)")




# Conners inattention --> significant effect for FDC in R ILF (cluster 3):
#=========================================================================

fit3 <- lm(Conners_DSM4_Inattention ~ FDC_cluster3_fdc + age + sex + Scanner_id, dat[dat$group=="TS",])
summary(fit3)
effect_plot(fit3, pred=FDC_cluster3_fdc, plot.points=T, interval=T, 
            partial.residuals=T, y.label="Inattention (partial residuals)")



#==============================
# Effect of tubers
#==============================
# FDC in FDC cluster

summary(lm(FDC_cluster1_fdc ~ Comb_tubtot + age + sex + Scanner_id, dat[dat$group=="TS",]))
summary(lm(FDC_cluster2_fdc ~ Comb_tubtot + age + sex + Scanner_id, dat[dat$group=="TS",]))
summary(lm(FDC_cluster3_fdc ~ Comb_tubtot + age + sex + Scanner_id, dat[dat$group=="TS",]))
summary(lm(FDC_cluster1_fd ~ Comb_tubtot + age + sex + Scanner_id, dat[dat$group=="TS",]))
summary(lm(FDC_cluster1_fc ~ Comb_tubtot + age + sex + Scanner_id, dat[dat$group=="TS",]))

summary(lm(FD_cluster1 ~ Comb_tubtot + age + sex + Scanner_id, dat[dat$group=="TS",]))

summary(lm(FC_cluster1 ~ Comb_tubtot + age + sex + Scanner_id, dat[dat$group=="TS",]))


