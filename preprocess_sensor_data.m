base_dir='iSignDB';

cd (base_dir);

list=dir();

n=size(list,1);

days=["Day 1","Day 2","Day 3"];
count=1;

%%
for i=3:32
    
    user_name=list(i).name;
    per_user_count=1;
    
    %% TRAVERSE THROUGH DAYS
    
    for j=1:size(days,2)
        cd(base_dir + "\" +user_name+"\"+ days(j)+"\"+ "Fake\Sensor Data")
        samples=dir(base_dir + "\" +user_name+"\"+ days(j)+"\"+ "Fake\Sensor Data");  % for Fake as well.
        
        %% GET SAMPLES
        
        for k=1:size(samples)
            
            if ~(strcmp(samples(k).name,'.') || strcmp(samples(k).name,'..'))
                load(samples(k).name);
                % In some sensor data Position was empty thus check
                %%
                if isempty(Position.Timestamp)
                    Tstart=[Acceleration.Timestamp(1),AngularVelocity.Timestamp(1),...
                        MagneticField.Timestamp(1),Orientation.Timestamp(1)];
                    
                    Tend=[Acceleration.Timestamp(size(Acceleration,1)),AngularVelocity.Timestamp(size(AngularVelocity,1)),...
                        MagneticField.Timestamp(size(MagneticField,1)),Orientation.Timestamp(size(Orientation,1))];
                else
                    Tstart=[Acceleration.Timestamp(1),AngularVelocity.Timestamp(1),...
                        MagneticField.Timestamp(1),Orientation.Timestamp(1),Position.Timestamp(1)];
                    
                    Tend=[Acceleration.Timestamp(size(Acceleration,1)),AngularVelocity.Timestamp(size(AngularVelocity,1)),...
                        MagneticField.Timestamp(size(MagneticField,1)),Orientation.Timestamp(size(Orientation,1)),...
                        Position.Timestamp(size(Position,1))];
                end
                
                Tstart=sort(Tstart);
                Tend=sort(Tend,'descend');
                diff=seconds(Tend(1)-Tstart(1));
                Timestamp=0:0.05:diff;
                
                d=seconds(Acceleration.Timestamp-Tstart(1));
                [~,index]=unique(Acceleration.X,'stable');
                AX = interp1(d(index),Acceleration.X(index),Timestamp,'linear','extrap');
                AY = interp1(d(index),Acceleration.Y(index),Timestamp,'linear','extrap');
                AZ = interp1(d(index),Acceleration.Z(index),Timestamp,'linear','extrap');
                MagA=sqrt(AX.^2+AY.^2+AZ.^2);
                
                d=seconds(AngularVelocity.Timestamp-Tstart(1));
                [~,index]=unique(AngularVelocity.X,'stable');
                AVX = interp1(d(index),AngularVelocity.X(index),Timestamp,'linear','extrap');
                AVY = interp1(d(index),AngularVelocity.Y(index),Timestamp,'linear','extrap');
                AVZ = interp1(d(index),AngularVelocity.Z(index),Timestamp,'linear','extrap');
                MagAV=sqrt(AVX.^2+AVY.^2+AVZ.^2);
                
                d=seconds(MagneticField.Timestamp-Tstart(1));
                [~,index]=unique(MagneticField.X,'stable');
                MFX = interp1(d(index),MagneticField.X(index),Timestamp,'linear','extrap');
                MFY = interp1(d(index),MagneticField.Y(index),Timestamp,'linear','extrap');
                MFZ = interp1(d(index),MagneticField.Z(index),Timestamp,'linear','extrap');
                MagMF=sqrt(MFX.^2+MFY.^2+MFZ.^2);
                
                d=seconds(Orientation.Timestamp-Tstart(1));
                [~,index]=unique(Orientation.X,'stable');
                OX = interp1(d(index),Orientation.X(index),Timestamp,'linear','extrap');
                OY = interp1(d(index),Orientation.Y(index),Timestamp,'linear','extrap');
                OZ = interp1(d(index),Orientation.Z(index),Timestamp,'linear','extrap');
                MagO=sqrt(OX.^2+OY.^2+OZ.^2);
                               
                Acceleration=[AX', AY', AZ', MagA'];
                AngularVelocity=[AVX', AVY', AVZ', MagAV'];
                MagneticField=[MFX', MFY', MFZ', MagMF'];
                Orientation=[OX', OY', OZ', MagO'];
                
                %%GET THE Data IN A CELL FOR LSTM
                val(1,:)=AX;
                val(2,:)=AY;
                val(3,:)=AZ;
                val(4,:)=MagA;
                val(5,:)=AVX;
                val(6,:)=AVY;
                val(7,:)=AVZ;
                val(8,:)=MagAV;
                val(9,:)=MFX;
                val(10,:)=MFY;
                val(11,:)=MFZ;
                val(12,:)=MagMF;
                val(13,:)=OX;
                val(14,:)=OY;
                val(15,:)=OZ;
                val(16,:)=MagO;
                dataFake{count,1}=val;
                dataLabelFake{count,1}=categorical(i-2);
                count=count+1;
                per_user_count=per_user_count+1;
                clear val values;
            end
       
        end
    end
    
end

save("LSTMdataFake.mat",'data','dataLabel')
