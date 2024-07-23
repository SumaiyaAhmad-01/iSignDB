%%file that'll save the result metrics

LSTMTrainFilename = fopen('LSTMTest.txt','w');
fprintf(LSTMTrainFilename,'user_number\taccuracy\tTAR\tFAR\tFRR\tEER\tTP\tFN\tFP\tTN\n');

%%
% %base_dir1 is the directory containig trained models
base_dir1='Authentication';
%
% %base_dir2 is the directory tha'll save the test results of Tes1
base_dir2='Test';

cd(base_dir2);

user_i=[1:32];
for ui=1:size(user_i,2)
    
    i=user_i(ui);
    
    load(base_dir1+"\"+int2str(i)+".mat");
    
    XTest=XTest1;
    YTest=YTest1;
    
    XTest(end+1:end+size(XTest4,1),1)=XTest4;
    YTest(end+1:end+size(XTest4,1),1)=categorical(0);
    
    %% TESTING
    %
    numObservations = numel(XTest);
    
    miniBatchSize =1;
    
    [YPred,scores] = classify(net,XTest, ...
        'MiniBatchSize',miniBatchSize, ...
        'SequenceLength','longest');
    confmat=confusionmat(YTest,YPred)
    accuracy = sum(YPred ==YTest )/numel(YTest)
    %%
    targets=zeros(2,size(YTest,1));
    for j=1:size(YTest,1)
        if YTest(j,1)=='1'
            targets(1,j)=1;
        else
            targets(2,j)=1;
        end
    end
    outputs=scores';
    
    [tpr,fpr,thresholds]=roc(targets,outputs);
    
    for j=1:2
        for k=1:size(tpr{1,j},2)
            fnr{1,j}(1,k)=1-tpr{1,j}(1,k);
        end
    end
    %%
    TAR=confmat(1,1)/(confmat(1,1)+confmat(1,2));
    FAR=confmat(2,1)/(confmat(2,1)+confmat(2,2));
    FRR=confmat(1,2)/(confmat(1,2)+confmat(1,1));
    
    [xi,yi] = polyxpoly(thresholds{1,1},fpr{1,1},thresholds{1,1},fnr
    {1,1},'unique')
    EER=double(yi);
    
    save(int2str(i)+".mat",'i','FAR','FRR','TAR','confmat','accuracy','XTrain','XTest','YTrain','YTest','YPred','net','scores','thresholds','tpr','fpr','fnr');
    
    
    fprintf(LSTMTrainFilename,'%d',i);
    fprintf(LSTMTrainFilename,'\t');
    fprintf(LSTMTrainFilename,'%f',accuracy);
    fprintf(LSTMTrainFilename,'\t');
    fprintf(LSTMTrainFilename,'%f',TAR);
    fprintf(LSTMTrainFilename,'\t');
    fprintf(LSTMTrainFilename,'%f',FAR);
    fprintf(LSTMTrainFilename,'\t');
    fprintf(LSTMTrainFilename,'%f',FRR);
    fprintf(LSTMTrainFilename,'\t');
    fprintf(LSTMTrainFilename,'%f',EER);
    fprintf(LSTMTrainFilename,'\t');
    fprintf(LSTMTrainFilename,'%d',confmat(1,1));
    fprintf(LSTMTrainFilename,'\t');
    fprintf(LSTMTrainFilename,'%d',confmat(1,2));
    fprintf(LSTMTrainFilename,'\t');
    fprintf(LSTMTrainFilename,'%d',confmat(2,1));
    fprintf(LSTMTrainFilename,'\t');
    fprintf(LSTMTrainFilename,'%d',confmat(2,2));
    fprintf(LSTMTrainFilename,'\n');
    
    clear accuracy confmat scores XTrainFake XTrainReal XTrain YTrain XTest YTest YPred net tpr fpr fnr FAR FRR  targets thresholdsclear YTest2 YTest XTest2 XTest XTest3 YTest3 sequence sequenceLengths targets;
    
end