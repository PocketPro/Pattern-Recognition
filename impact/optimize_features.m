function optimalNumberOfFeatures = optimize_features(pattern)
# preforms a cross validation algorithm on the files specified by pattern. For
# the sake of this function the files specified by pattern are expected to be
# csv files with 7 columns - 1 time, and 6 data

# grab all the file names and the create the hypothesis to test.
files = glob(pattern);
numberOfFeatures = (10:1:50)';

# here, we extract the data from each file, store it, and set it aside.
totalFiles = size(files,1);   # grab the total number of files
nTests = 0;                   # keep a counter for the number of tests
optimalNumberOfFeatures = []; # keep an array to store the optimal number of features
for i = 1:size(files,1)
  fileNumber = i;
  file = files{i};

  # each file has 7 data columns, time, x, y ,z
  for column = 2:7
    [xi, yi] = massage_data(file, column);
  
    # for each number of features we need to calculate the generalized error. 
    # We determine the generalized error by training the hypothesis with a 
    # subset of the training data. We then calculate the error in the remaining 
    # error. We repeat this for each number of input features to test.
    errors = [];
    for j = 1:size(numberOfFeatures,1)
      X = [];
      nFeatures = numberOfFeatures(j);
      orders = (0:1:nFeatures);
      for k=1:size(yi,1);
        X(k,:) = xi(k).^(orders);
      endfor
      averageError = kFoldCrossValidation(X, yi, 10);
      #printf("number of features: %4d, error: %.4E\n", nFeatures, averageError);
      errors(j) = averageError;
    endfor
    nTests++;
    optimalNFeatures = numberOfFeatures(find(errors == min(errors)));
    optimalNumberOfFeatures(nTests,:) = [column, optimalNFeatures];
    printf("FILE %2d of %2d, COLUMN %2d OPTIMAL FEATURES: %4d\n", fileNumber,
            totalFiles, column, optimalNFeatures);
  endfor
endfor
printf("OPTIMAL NUMBER OF FEATURES %f\n", mean(optimalNumberOfFeatures(:,2))); 
endfunction

function averageError = kFoldCrossValidation(X, y, k = 1)
# this function computes the k-fold cross validation for a linear regression 
# hypothesis

nTrainingExamples = size(y,1);
allIndeces = (1:nTrainingExamples)';
nSectionTrainingExamples = nTrainingExamples/k;
errors = [];

# right now, the data and y is ordered and removing a chunk of data from it 
# will grossly affect the fit. To counteract this, we need to randomize the
# ordering of X and y
randomIndeces = randperm(nTrainingExamples);
_y = y(randomIndeces);
_X = X(randomIndeces,:);

for i = 1:k
  sectionStartIndex = round(nSectionTrainingExamples*(i-1))+1;
  sectionEndIndex = round(nSectionTrainingExamples*i);

  # now that we have the start and end indeces, we want to split the data into
  # training set, and validation set. The training set goes from 1:s
  trainingIndeces = [find(allIndeces < sectionStartIndex);
                     find(allIndeces > sectionEndIndex)];
  validatingIndeces = [find(allIndeces >= sectionStartIndex)];
  validatingIndeces = [validatingIndeces(find(validatingIndeces <= sectionEndIndex))];
  
  trainingY = _y(trainingIndeces);
  trainingX = _X(trainingIndeces,:);
  validatingY = _y(validatingIndeces);
  validatingX = _X(validatingIndeces,:);

  b = ols(trainingY,trainingX);
  esquared = (validatingY - validatingX*b).^2;
  errors(i) = mean(esquared);
endfor

averageError = mean(errors);

endfunction
