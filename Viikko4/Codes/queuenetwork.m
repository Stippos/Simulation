function T=queuenetwork(n,ent,seq,lambda,mu)
%Simulate a queuing network.
%
%length(lambda) different arrival processes
%length(mu) servers
%
%All times independent, exponential. Queue size infinite.
%
%n          simulate until n customers have left the system
%ent(i)     first server when entering the system from arrival process i
%seq(i)     destination server after leaving server i, length(mu)+1 to leave the system 
%lambda     inter-arrival time means of customers
%mu         service time means of servers
 
m=length(mu);       %Number of servers

t=0;                %Simulation clock

ta=exprnd(lambda);  %Times of next customer arrivals
td=ones(1,m)*inf;   %Departure times of customers (set to infinite)
 
served=zeros(1,m);  %Customers being served
queue=cell(1,m);    %Queued customers
 
n_in=0;             %Number of customer arrivals
n_out=0;            %Number of customer departures
 
tin=[];             %Times of entering the system
tout=[];            %Total time in system
 
cout=0;             %Command line output on/off
 
%The main simulation loop
while n_out<n
    
    if min(ta)<min(td)                    %Next event is arrival
        
        %Specify arrival process
        [z,i]=min(ta);
        
        %Update statistics
        n_in=n_in+1;    
        tin=[tin;z];
 
        %Select server
        j=ent(i);
        
        %Add either to server or queue
        if served(j)==0                         
            served(j)=n_in;
            td(j)=z+exprnd(mu(j));
        else                                       
            queue{j}=[queue{j} n_in];
        end

        %Update simulation clock
        t=z;
        
        %Next arrival
        ta(i)=z+exprnd(lambda(i));
        
    else                            %Next event is departure
        
        %Get the index i of the server with the smallest departure time
        [z,i]=min(td);
                
        %Index of the customer leaving the server
        k=served(i);
        
        %Next server in sequence
        j=seq(i);
        
        %Customer either leaves the network or proceeds to next server
        if j>m                                      %Leave system
            n_out=n_out+1;
            tout=[tout; z-tin(k)];
        else                                        %Go to next server
            if served(j)==0 
                served(j)=k;
                td(j)=z+exprnd(mu(j));
            else
                queue{j}=[queue{j} k];
            end
        end
 
        %Take next customer from queue at server i, if any exist
        if length(queue{i})>0
            served(i)=queue{i}(1);
            td(i)=z+exprnd(mu(i));
            queue{i}=queue{i}(2:end);
        else
            served(i)=0;
            td(i)=inf;
        end
                
        %Update simulation clock
        t=z;
                
    end    
    
    %Command line output
    if cout
        str=['t: ' sprintf('%6.2f',t)];
        for i=1:m
            if served(i)>0
                str=[str '   o|'];
            else
                str=[str '    |'];
            end
            str=[str repmat('o',1,length(queue{i})) repmat(' ',1,15-length(queue{i})) ];
        end
        disp(str);    
    end
    
    
end

T=mean(tout);