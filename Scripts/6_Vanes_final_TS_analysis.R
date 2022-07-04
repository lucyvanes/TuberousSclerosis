# 27/01/2022
# Lucy Vanes
# Analysis code for:
# "White matter disruptions related to inattention and autism spectrum symptoms in tuberous sclerosis complex"


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

# Behavioural group comparisons (+ sensitivity analyses excluding medicated participants)
#========================================================================================

summary(lm(WASI_FSIQ ~ group + age + sex, dat))
summary(lm(WASI_FSIQ ~ group + age + sex, dat[dat$med==0,]))

summary(lm(SRS2_SC ~ group + age + sex, dat))
summary(lm(SRS2_SC ~ group + age + sex, dat[dat$med==0,]))

summary(lm(SRS2_RRB ~ group + age + sex, dat))
summary(lm(SRS2_RRB ~ group + age + sex, dat[dat$med==0,]))

summary(lm(Conners_DSM4_Inattention ~ group + age + sex, dat))
summary(lm(Conners_DSM4_Inattention ~ group + age + sex, dat[dat$med==0,]))

summary(lm(Conners_DSM4_HypImp ~ group + age + sex, dat)) # no difference
summary(lm(Conners_DSM4_HypImp ~ group + age + sex, dat[dat$med==0,]))


#=======================================================================
#                   Interrogate MRI results
#=======================================================================

# FDC clusters
#==============
# R SLF-I
# png( "Effect1.jpeg",  width = 6, height = 6, units = 'in', res = 300)
ggplot(dat, aes(y=FDC_cluster1_fdc, x=group)) + 
  geom_boxplot() +
  geom_jitter(color="black", size=2, alpha=0.7) +
  xlab("Group") + ylab("Mean FDC") +
  theme(axis.text=element_text(size=30),
        axis.title=element_text(size=30),
        plot.title = element_text(size = 30, face = "bold")) +
  ggtitle("Right SLF-I") 

# dev.off()
summary(lm(FDC_cluster1_fdc ~ group + age + sex, dat[dat$med==0,]))
summary(lm(FDC_cluster1_fdc ~ group + age + sex + TIV, dat))
summary(lm(FDC_cluster1_fdc ~ group + age + sex + abs_motion, dat))

# R ILF
ggplot(dat, aes(y=FDC_cluster2_fdc, x=group)) + 
  geom_boxplot() +
  geom_jitter(color="black", size=2, alpha=0.7) +
  xlab("Group") + ylab("Mean FDC") +
  theme(axis.text=element_text(size=30),
        axis.title=element_text(size=30),
        plot.title = element_text(size = 30, face = "bold")) +
ggtitle("Right ILF") 

summary(lm(FDC_cluster2_fdc ~ group + age + sex, dat[dat$med==0,]))
summary(lm(FDC_cluster2_fdc ~ group + age + sex + TIV, dat))
summary(lm(FDC_cluster2_fdc ~ group + age + sex + abs_motion, dat))


# L ILF
ggplot(dat, aes(y=FDC_cluster3_fdc, x=group)) + 
  geom_boxplot() +
  geom_jitter(color="black", size=2, alpha=0.7) +
  xlab("Group") + ylab("Mean FDC") +
  theme(axis.text=element_text(size=30),
        axis.title=element_text(size=30),
        plot.title = element_text(size = 30, face = "bold")) +
      ggtitle("Left ILF") 
        
summary(lm(FDC_cluster3_fdc ~ group + age + sex, dat[dat$med==0,]))
summary(lm(FDC_cluster3_fdc ~ group + age + sex + TIV, dat))
summary(lm(FDC_cluster3_fdc ~ group + age + sex + abs_motion, dat))


# FD cluster
#=============

ggplot(dat, aes(y=FD_cluster1, x=group)) + 
  geom_boxplot() +
  geom_jitter(color="black", size=2, alpha=0.7) +
  xlab("Group") + ylab("Mean FD") +
  theme(axis.text=element_text(size=30),
        axis.title=element_text(size=30),
        plot.title = element_text(size = 30, face = "bold")) +
  ggtitle("Tapetum") 

summary(lm(FD_cluster1 ~ group + age + sex, dat[dat$med==0,]))
summary(lm(FD_cluster1 ~ group + age + sex + TIV, dat))
summary(lm(FD_cluster1 ~ group + age + sex + abs_motion, dat))

# log FC cluster
#==================
ggplot(dat, aes(y=FC_cluster1, x=group)) + 
  geom_boxplot() +
  geom_jitter(color="black", size=2, alpha=0.7) +
  xlab("Group") + ylab("Mean (log) FC") +
  theme(axis.text=element_text(size=30),
        axis.title=element_text(size=30),
        plot.title = element_text(size = 30, face = "bold")) +
  ggtitle("Right SLF-III") 

  
summary(lm(FC_cluster1 ~ group + age + sex, dat[dat$med==0,]))
summary(lm(FC_cluster1 ~ group + age + sex + TIV, dat))
summary(lm(FC_cluster1 ~ group + age + sex + rel_motion, dat))


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
  print(summary(lm(as.formula(paste(v, "~  FDC_cluster1_fdc+ age + sex + Scanner_id")), dat[dat$group=="TSC",])))
  print(summary(lm(as.formula(paste(v, "~  FDC_cluster2_fdc+ age + sex + Scanner_id")), dat[dat$group=="TSC",])))
  print(summary(lm(as.formula(paste(v, "~  FDC_cluster3_fdc+ age + sex + Scanner_id")), dat[dat$group=="TSC",])))

    print("##        FD           ##")
  print(summary(lm(as.formula(paste(v, "~  FD_cluster1 + age + sex + Scanner_id")), dat[dat$group=="TSC",])))

  print("##        Log FC           ##")
  print(summary(lm(as.formula(paste(v, "~  FC_cluster1 + age + sex + Scanner_id")), dat[dat$group=="TSC",])))
}



# Sensitivity analyses; additionally controlling for TIV /  motion / medication status
#===============================================================================
# Adding TIV
for (v in vars){
  print(v)
  print("===========================", quote=F)
  print("##        FDC           ##")
  print(summary(lm(as.formula(paste(v, "~  FDC_cluster1_fdc+ age + sex + Scanner_id + TIV")), dat[dat$group=="TSC",])))
  print(summary(lm(as.formula(paste(v, "~  FDC_cluster2_fdc+ age + sex + Scanner_id + TIV")), dat[dat$group=="TSC",])))
  print(summary(lm(as.formula(paste(v, "~  FDC_cluster3_fdc+ age + sex + Scanner_id + TIV")), dat[dat$group=="TSC",])))
  
  print("##        FD           ##")
  print(summary(lm(as.formula(paste(v, "~  FD_cluster1 + age + sex + Scanner_id + TIV")), dat[dat$group=="TSC",])))
  
  print("##        Log FC           ##")
  print(summary(lm(as.formula(paste(v, "~  FC_cluster1 + age + sex + Scanner_id + TIV")), dat[dat$group=="TSC",])))
}

# adding motion
for (v in vars){
  print(v)
  print("===========================", quote=F)
  print("##        FDC           ##")
  print(summary(lm(as.formula(paste(v, "~  FDC_cluster1_fdc+ age + sex + Scanner_id + rel_motion")), dat[dat$group=="TSC",])))
  print(summary(lm(as.formula(paste(v, "~  FDC_cluster2_fdc+ age + sex + Scanner_id + rel_motion")), dat[dat$group=="TSC",])))
  print(summary(lm(as.formula(paste(v, "~  FDC_cluster3_fdc+ age + sex + Scanner_id + rel_motion")), dat[dat$group=="TSC",])))
  
  print("##        FD           ##")
  print(summary(lm(as.formula(paste(v, "~  FD_cluster1 + age + sex + Scanner_id + rel_motion")), dat[dat$group=="TSC",])))
  
  print("##        Log FC           ##")
  print(summary(lm(as.formula(paste(v, "~  FC_cluster1 + age + sex + Scanner_id + rel_motion")), dat[dat$group=="TSC",])))
}

# adding medication status
for (v in vars){
  print(v)
  print("===========================", quote=F)
  print("##        FDC           ##")
  print(summary(lm(as.formula(paste(v, "~  FDC_cluster1_fdc+ age + sex + Scanner_id + med")), dat[dat$group=="TSC",])))
  print(summary(lm(as.formula(paste(v, "~  FDC_cluster2_fdc+ age + sex + Scanner_id + med")), dat[dat$group=="TSC",])))
  print(summary(lm(as.formula(paste(v, "~  FDC_cluster3_fdc+ age + sex + Scanner_id + med")), dat[dat$group=="TSC",])))
  
  print("##        FD           ##")
  print(summary(lm(as.formula(paste(v, "~  FD_cluster1 + age + sex + Scanner_id + med")), dat[dat$group=="TSC",])))
  
  print("##        Log FC           ##")
  print(summary(lm(as.formula(paste(v, "~  FC_cluster1 + age + sex + Scanner_id + med")), dat[dat$group=="TSC",])))
}



#===========================
#     Summarise results
#===========================

# IQ --> all n.s.
#==================

# SRS-SCI and SRS-RRB --> significant effect for FDC in R SLF (cluster 1):
#=========================================================================

fit1 <- lm(SRS2_SC ~ FDC_cluster1_fdc + age + sex + Scanner_id, dat[dat$group=="TSC",])
summary(fit1)

# png( "Effect6.jpeg",  width = 6, height = 6, units = 'in', res = 300)

effect_plot(fit1, pred=FDC_cluster1_fdc, plot.points=T, interval=T, point.size=3,
            partial.residuals=T, y.label="SRS SCI (partial residuals)", x.label="FDC") +
  theme(axis.text=element_text(size=30),
        axis.title=element_text(size=30),
        plot.title = element_text(size = 30, face = "bold")) +
  ggtitle("Social Communication") 
# dev.off()


fit2 <- lm(SRS2_RRB ~ FDC_cluster1_fdc + age + sex + Scanner_id, dat[dat$group=="TSC",])
summary(fit2)
effect_plot(fit2, pred=FDC_cluster1_fdc, plot.points=T, interval=T,  point.size=3,
            partial.residuals=T, y.label="SRS RRB (partial residuals)", x.label="FDC") +
  theme(axis.text=element_text(size=30),
        axis.title=element_text(size=30),
        plot.title = element_text(size = 30, face = "bold")) +
  ggtitle("Restricted Repetitive Behaviours") 




# Conners inattention --> significant effect for FDC in R ILF (cluster 3):
#=========================================================================

fit3 <- lm(Conners_DSM4_Inattention ~ FDC_cluster3_fdc + age + sex + Scanner_id, dat[dat$group=="TSC",])
summary(fit3)
effect_plot(fit3, pred=FDC_cluster3_fdc, plot.points=T, interval=T,  point.size=3,
            partial.residuals=T, y.label="Inattention (partial residuals)", x.label="FDC") +
  theme(axis.text=element_text(size=30),
        axis.title=element_text(size=30),
        plot.title = element_text(size = 30, face = "bold")) +
  ggtitle("Inattention") 



#==================================================
# Effect of tubers / E-CHESS / age of seizure onset
#==================================================
#

lm1 <- lm(FD_cluster1 ~ Comb_tubtot + age + sex + Scanner_id, dat[dat$group=="TSC",])
effect_plot(lm1, pred=Comb_tubtot, plot.points=T, interval=T,  point.size=3,
            partial.residuals=T, y.label="FD tapetum (partial residuals)", x.label="Tuber load") +
  theme(axis.text=element_text(size=20),
        axis.title=element_text(size=20)) 


lm2 <- lm(FDC_cluster1_fdc ~ age_seizure_onset + age + sex + Scanner_id, dat[dat$group=="TSC",])
effect_plot(lm2, pred=age_seizure_onset, plot.points=T, interval=T,  point.size=3,
            partial.residuals=T, y.label="FDC Right SLF-I (partial residuals)", x.label="Age of seizure onset") +
  theme(axis.text=element_text(size=20),
        axis.title=element_text(size=20)) 

