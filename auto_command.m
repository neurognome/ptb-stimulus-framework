%%
addpath(genpath('C:\Users\Res_Imaging\Documents\MATLAB\msocket'));
%%
disp('establishing socket connection with DAQ')
DAQ_IP = '136.152.58.120';% '128.32.173.99';
socket = msconnect(DAQ_IP,42041);

invar=[];
while ~strcmp(invar,'A');
    invar = msrecv(socket,0.1);
    disp('Not Recieved')
end
disp('Recieved')

sendVar ='B';
mssend(socket,sendVar);
disp('Input from DAQ Computer confirmed');


%%
disp('Waiting for Command from DAQ')
go = true;

invar =msrecv(socket,0.1);
while ~isempty(invar)
    invar =msrecv(socket,0.1);
end

while go
    pause(0.1);
    invar = msrecv(socket,0.1);
 if ~isempty(invar) 
     if strcmp(invar,'end')
        disp('end kthx');
        go = false;
        mssend(socket,'kthx');
     else
         disp('Eval Command Received')
         try
         out = eval(invar);
         catch
             out='No Output';
             try
                 disp(invar);
                 eval(invar);
             catch
                 
                 out='Eval Error';
             end
         end
         if isempty(out)
             out='-';
         end
         disp(out)
         mssend(socket,out);
     end
 end
end


