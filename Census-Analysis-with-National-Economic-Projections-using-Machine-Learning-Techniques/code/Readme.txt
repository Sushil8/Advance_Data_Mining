########Steps to run#######

Please follow the following steps

1. Run preprocessing.r file to merge and preprocess(clean, transform) the Unemployment and population datasets.(Code file and both the datasets are placed in the Preprocessing folder)

2. Run the ensembel- To see how ensemble performs to predict the unemployment rate of the United States counties, please run ensemble.r under Ensemble folder.(Preprocessing output file is passed as the input to the ensemble)

3. ARIMA- To see how the time series data performs with ARIMA, run the file ARIMA.r under ARIMA folder. Input file is present in the same folder.

4. RNN- Please install theano, tensorflow and keras libraries in python and then run rnn.py file. The input file is divided into train and test data. RNN is trained on the training data and tested on the test data to see how RNN performs on the time series data.

Thank You 