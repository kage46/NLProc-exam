#https://www.kaggle.com/paultimothymooney/poetry-generator-rnn-markov
#Markov Chains

import random
import os
import re

abspath = os.path.abspath(__file__)
dname = os.path.dirname(abspath)
os.chdir(dname)

lovepath = "poems\\Lovecraft"
loveraw = '\n\n'.join(open(os.path.join(lovepath, poem), encoding='utf-8', errors='ignore').read() \
                      for poem in os.listdir(lovepath))
poepath = "poems\\Poe"
poeraw = '\n\n'.join(open(os.path.join(poepath, poem), encoding='utf-8', errors='ignore').read() \
                      for poem in os.listdir(poepath))
plathpath = "poems\\Plath"
plathraw = '\n\n'.join(open(os.path.join(plathpath, poem), encoding='utf-8', errors='ignore').read() \
                      for poem in os.listdir(plathpath))
baudpath = "poems\\Baudelaire"
baudraw = '\n\n'.join(open(os.path.join(baudpath, poem), encoding='utf-8', errors='ignore').read() \
                      for poem in os.listdir(baudpath))

poems = loveraw + poeraw + plathraw + baudraw
len(poems)

import numpy as np
from matplotlib import pyplot as plt
def plotWordFrequency(input):
    f = open(poems,'r')
    words = [x for y in [l.split() for l in f.readlines()] for x in y]
    data = sorted([(w, words.count(w)) for w in set(words)], key = lambda x:x[1], reverse=True)[:40] 
    most_words = [x[0] for x in data]
    times_used = [int(x[1]) for x in data]
    plt.figure(figsize=(20,10))
    plt.bar(x=sorted(most_words), height=times_used, color = 'grey', edgecolor = 'black',  width=.5)
    plt.xticks(rotation=45, fontsize=18)
    plt.yticks(rotation=0, fontsize=18)
    plt.xlabel('Most Common Words:', fontsize=18)
    plt.ylabel('Number of Occurences:', fontsize=18)
    plt.title('Most Commonly Used Words: %s' % (poems), fontsize=24)
    plt.show()