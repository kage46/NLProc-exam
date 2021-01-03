library(rstudioapi)
current_path = rstudioapi::getActiveDocumentContext()$path 
setwd(dirname(current_path))

library(tidyverse)
library(rethinking)
library(brms)

#listyList = list.files(path="data/",pattern="*.csv",full.names=T)
BPMH <- do.call(rbind,lapply("dataFull.csv",read.csv))

BPMH$choice <- ifelse(BPMH$choice=="Left",1,0)

BPMHMachine <- BPMH[!(BPMH$condition=="Like"),]
BPMHLike <- BPMH[!(BPMH$condition=="Machine"),]


ggplot(BPMHMachine, aes(x=poemNr,y=certainty))+
  geom_smooth()+
  labs(title="Player certainty regarding choice",
       x="Poem Pair Number",y="Certainty")

ggplot(BPMHMachine, aes(x=poemNr,y=correctness))+
  geom_smooth()+
  labs(title="Player correctness regarding choice",
       x="Poem Pair Number",y="Correctness")

ggplot(BPMH, aes(x=choice,y=correctness))+
  geom_smooth()

ggplot(data=BPMH, aes(x=poemNr, y=choice, fill=condition)) +
  geom_bar(stat="identity", position=position_dodge())+
  scale_fill_brewer(palette="Paired")+
  theme_minimal()

summary(BPMHMachine$correctness)

prior = c(prior(normal(0,.5), class = "Intercept"), 
          prior(normal(0,.2), class = "b"),
          prior(normal(0,.1), class = "sd"))
priorTwo = c(prior(normal(0,.5), class = "Intercept"), 
             #prior(normal(0,.2), class = "b"),
             prior(normal(0,.1), class = "sd"))

muffin <- brm(
  choice ~ 1 + correctness + (1+correctness|playerID) + (1|poemNr),
  family = "bernoulli",
  prior = prior,
  sample_prior = "yes",
  data = BPMH,
  cores = 2,
  iter = 5000, warmup = 2000,
  seed = 999
)
#(hypothesis(muffin, "narrativesimple>0"))
summary(muffin)
plot(muffin)
pp_check(muffin)

#muffinMarg <- plot(marginal_effects(muffin), main="Title")
plot(marginal_effects(muffin), points = T)
