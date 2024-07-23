% select the test and train for fake
function [XTrain,YTrain,XTest,YTest]=train_test_split(XTrainReal,XTrainFake)
    % 7 samples of from real
    % s=7
    max=size(XTrainReal,1);

    r=[1:23];
    %%
    XTrain=XTrainReal(r);
    YTrain(1:size(r,2))=categorical(1);

    XTrainReal(r)=[];
    %%
    XTest=XTrainReal;
    YTest(1:size(XTest,1))=categorical(1);
    %%
    clear r ;

    r=[12:15];
    %%

    min=size(XTest,1)+1;
    max=size(XTest,1)+size(r,2);

    XTest(min:max)=XTrainFake(r);
    YTest(min:max)=categorical(0);

    XTrainFake(r)=[];
        %%
    min=size(XTrain,1)+1;
    max=size(XTrain,1)+size(XTrainFake,1);

    XTrain(min:max)=XTrainFake;
    YTrain(min:max)=categorical(0);

    YTrain = removecats(YTrain');
    YTest = removecats(YTest');

end