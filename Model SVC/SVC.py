from sklearn.svm import SVC
from sklearn.datasets import load_iris	# iris data set 
from sklite import LazyExport
import numpy as np
from sklearn import svm
import pandas as pd


dataframe=pd.read_csv('data1.csv')
dataset=dataframe.values

X=dataset[:,0:5]
y=dataset[:,-1]
y=np.reshape(y, (-1,1))

clf = svm.SVC(kernel='rbf', C=1.0)

clf.fit(X,y)

lazy = LazyExport(clf)
lazy.save('svc1.json')

