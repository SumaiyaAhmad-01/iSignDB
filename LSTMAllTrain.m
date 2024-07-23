% load data with sensor_stat_image data
load('Sign_stat_img.mat')
base_dir='Authentication';

cd(base_dir);
user_i=[1:32];

for ui=1:32
    %     get each user id in i
    
    XTempFake={};
    XTest3={};
    i=user_i(ui);
    
    l=dataLabelReal==categorical(i);
    XTrainReal=dataReal(l);
    
    l=dataLabelFake==categorical(i);
    XTrainFake=dataFake(l);
    
    for indx=1:32
        if indx==i
            continue
        else
            l=dataLabelReal==categorical(indx);
            k=find(l);
            %%Random Fake Training
            XTempFake(end+1,1)=dataReal(k(1,1));
            %%Random Fake Test
            XTest3(end+1,1)=dataReal(k(2,1));
            
        end
    end
    % first 23 genuine samples for training
    % first 11 skilled forgery samples for training
    [XTrain,YTrain,XTest,YTest]=train_test_split(XTrainReal,XTrainFake);
    
    
    %%
    % XTrain----[1:23]--  samples real
    % XTrain----[24:34]-- skilled forgery
    
    XTrain(end+1:end+size(XTempFake,1),1)=XTempFake;
    YTrain(end+1:end+size(XTempFake,1),1)=categorical(0);
    
    % XTrain----[35:65]-- random forgery
    % XTest1----genuine test samples
    
    l=YTest==categorical(1);
    XTest1(1:size(XTest(l),1),1)=XTest(l);
    YTest1(1:size(XTest(l),1),1)=categorical(1);
    
    % XTest1----skilled forgery test samples
    l=YTest==categorical(0);
    XTest2(1:size(XTest(l),1),1)=XTest(l);
    YTest2(1:size(XTest(l),1),1)=categorical(0);
    
    
    YTest3(1:size(XTest3,1),1)=categorical(0);
    
    [net,options,layers]=LSTMTrain(XTrain,YTrain)
    
    save(int2str(i)+".mat",'i','XTrain','XTest1','XTest2','XTest3','YTrain','YTest1','YTest2','YTest3','net','options','layers' );
    clear  XTrainFake XTrainReal XTempFake  XTrainFake   XTrain YTrain XTest1 YTest1 XTest2 YTest2 XTest3 YTest3 net
end
