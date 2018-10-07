# Recurrent Neural Network
# Importing the libraries
import numpy as np
import matplotlib.pyplot as plt
import pandas as pd

dataset_train = pd.read_csv('train.csv')
training_set = dataset_train.iloc[:, 1:2].values
#plt.plot(training_set)
#plt.show()
# Scaling
from sklearn.preprocessing import MinMaxScaler
sc = MinMaxScaler(feature_range = (0, 1))
training_set_scaled = sc.fit_transform(training_set)

#data structure
X_train = []
y_train = []
for i in range(90, 828):
    X_train.append(training_set_scaled[i-90:i, 0])
    y_train.append(training_set_scaled[i, 0])
X_train, y_train = np.array(X_train), np.array(y_train)

# Reshaping
X_train = np.reshape(X_train, (X_train.shape[0], X_train.shape[1], 1))

from keras.models import Sequential
from keras.layers import Dense
from keras.layers import LSTM
from keras.layers import Dropout

# Initialising the RNN
regressor = Sequential()

#first LSTM layer and Dropout regularisation
regressor.add(LSTM(units = 150, return_sequences = True, input_shape = (X_train.shape[1], 1)))
regressor.add(Dropout(0.2))

#second LSTM layer and Dropout regularisation
regressor.add(LSTM(units = 150, return_sequences = True))
regressor.add(Dropout(0.2))

#third LSTM layer and Dropout regularisation
regressor.add(LSTM(units = 150, return_sequences = True))
regressor.add(Dropout(0.2))

#fourth LSTM layer and Dropout regularisation
regressor.add(LSTM(units = 150))
regressor.add(Dropout(0.2))

#output layer
regressor.add(Dense(units = 1))

# compiling the RNN
regressor.compile(optimizer = 'adam', loss = 'mean_squared_error')

# Fitting the RNN
regressor.fit(X_train, y_train, epochs = 120, batch_size = 30)

# real employment rate
dataset_test = pd.read_csv('test.csv')
ptest = dataset_test.iloc[:, 1:2].values

# Getting the predicted employment rate of 2017
dataset_total = pd.concat((dataset_train['Emp'], dataset_test['Emp']), axis = 0)
inputs = dataset_total[len(dataset_total) - len(dataset_test) - 90:].values
inputs = inputs.reshape(-1,1)
inputs = sc.transform(inputs)
X_test = []
for i in range(90, 108):
    X_test.append(inputs[i-90:i, 0])
X_test = np.array(X_test)
X_test = np.reshape(X_test, (X_test.shape[0], X_test.shape[1], 1))
predicted_Emp = regressor.predict(X_test)
predicted_Emp = sc.inverse_transform(predicted_Emp)

# Visualising the results
plt.plot(ptest, color = 'red', label = 'Employment Rate')
plt.plot(predicted_Emp, color = 'blue', label = 'Predicted employment rate')
plt.title('Employment rate')
plt.xlabel('Time')
plt.ylabel('Employment Rate')
plt.legend()
plt.show()

import math
from sklearn.metrics import mean_squared_error
rmse = math.sqrt(mean_squared_error(ptest, predicted_Emp))
rmse

mse = mean_squared_error(ptest, predicted_Emp)
mse