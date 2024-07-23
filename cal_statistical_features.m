load('LSTMSign.mat')

for i=1:size(dataReal,1)
    
    count=size(dataReal{i,1},1);
    
    s=size(dataReal{i,1},2);
    
    
    for j=[1:16]
        
        %% max Amplitude
        count=count+1
        
        dataReal{i,1}(count,:)=zeros(1,s);
        dataReal{i,1}(count,1)=max(dataReal{i,1}(j,:));
        
        
        
        %% min Amplitude
        count=count+1
        
        dataReal{i,1}(count,:)=zeros(1,s);
        dataReal{i,1}(count,1)=min(dataReal{i,1}(j,:));
        
        
        
        %% mean Amplitude
        count=count+1
        
        dataReal{i,1}(count,:)=zeros(1,s);
        dataReal{i,1}(count,1)=mean(dataReal{i,1}(j,:));
        
        
        
        %% variance Amplitude
        count=count+1
        
        dataReal{i,1}(count,:)=zeros(1,s);
        dataReal{i,1}(count,1)=var(dataReal{i,1}(j,:));
        
        
        
        %% kurtosis Amplitude
        count=count+1
        
        dataReal{i,1}(count,:)=zeros(1,s);
        dataReal{i,1}(count,1)=kurtosis(dataReal{i,1}(j,:));
        
        
        
        %% skewness Amplitude
        count=count+1
        
        dataReal{i,1}(count,:)=zeros(1,s);
        dataReal{i,1}(count,1)=skewness(dataReal{i,1}(j,:));
        
    end
end

for i=1:size(dataFake,1)
    
    count=size(dataFake{i,1},1);
    s=size(dataFake{i,1},2);
    
    for j=[1:16]
        
        %% max Amplitude
        count=count+1
        
        dataFake{i,1}(count,:)=zeros(1,s);
        dataFake{i,1}(count,1)=max(dataFake{i,1}(j,:));
        %% min Amplitude
        count=count+1
        
        dataFake{i,1}(count,:)=zeros(1,s);
        dataFake{i,1}(count,1)=min(dataFake{i,1}(j,:));
        
        %% mean Amplitude
        count=count+1
        
        dataFake{i,1}(count,:)=zeros(1,s);
        dataFake{i,1}(count,1)=mean(dataFake{i,1}(j,:));
        
        %% variance Amplitude
        count=count+1
        
        dataFake{i,1}(count,:)=zeros(1,s);
        dataFake{i,1}(count,1)=var(dataFake{i,1}(j,:));
        
        %% kurtosis Amplitude
        count=count+1
        
        dataFake{i,1}(count,:)=zeros(1,s);
        dataFake{i,1}(count,1)=kurtosis(dataFake{i,1}(j,:));
        %% skewness Amplitude
        count=count+1
        
        dataFake{i,1}(count,:)=zeros(1,s);
        dataFake{i,1}(count,1)=skewness(dataFake{i,1}(j,:));
    end
    
end
save("Stat_Sign.mat",'dataLabelReal','dataReal','dataLabelFake','dataFake')



