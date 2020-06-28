clear 

%--------------------------------------------------------------------------------------------------
% Simulation parameters
simTime=1000;                                 % Max simulation time
timeSteps = 10000;                            % Number of Time steps
dt = simTime/timeSteps;                     % Time step
nodeNum = 50;                               % Number of nodes to break bar into                                 
time = linspace(0,simTime,timeSteps);       % Array of time steps

%--------------------------------------------------------------------------------------------------
%SlabParameters
% Slab Diementions
L = 0.43;                                   % Length of slab
dx = L/nodeNum ;                            % length of each node
dy = 0.0001;                                % Thickness of slab
dz = 0.28;                                  % Width of slab
length=linspace(0,L,1/dx);                  % Array of node positions
convArea = dx*dz;                           % Area for convection
condArea = dx*dy;                           % Area for conduction
nodeVol = dx*dy*dz;                         % Node volume


% Slab parameters
densitySlab=2700;                           % Density of slab
kSlab=205;                                  % Slab conductivity
cpSlab = 0.9;                               % Specific heat capacity kj/kgK
nodeMass = nodeVol*densitySlab;             % Node Mass
alpha=kSlab/(densitySlab*cpSlab);           % Thermal Diffusivity
initialSlabTemp=2;                          % Initial Slab temperature


% Intialise Slab Array
Ts= zeros(nodeNum,timeSteps);               % Making empty matrix for slab to store values
Ts(:,1)= initialSlabTemp;                      % Setting initial slab temperature assuming uniform

%--------------------------------------------------------------------------------------------------
%AirParameters
InletAtemp=20;                              % Constant inlet air temperature degrees Celcius
h=17.2;                                     % Convective heat transfer coefficient
Ta= zeros(nodeNum,timeSteps);               % Making empty matrix for air temperature to store values.
Ta(1,:)= InletAtemp;                        % Setting air temperature at x=0
Ta(:,1)= initialSlabTemp;                        % Setting air temperature at x=0

cpAir=1.005;                                % Specific Heat capacity of air
pAir=1.205;                                 % Density of air
Velocity=2;                                 % Velocity of air
CSarea=0.0025;                              % Cross Sectional area to flow
VolumetricFlowrate=Velocity*CSarea;         % Volumetric flow rate of air
massAir=VolumetricFlowrate*pAir;                 % Mass Flow rate of air

%--------------------------------------------------------------------------------------------------
%row is distance where row 1 is at x=0, row 2 x=dx
%column is time where column 1 is time=0, column 2 is time =dt
%        Ta(x,t)=Ta(x-1,t)+(Ts(x,t)-Ta(x-1,t))*h*area*dx/(Ma*cpair); % Air temperature profile  

% Conduction

airSkips = (dx/dt)/Velocity;
airItr = 0;

for t= 1:(timeSteps-1)                   %Change in Time
    airItr = airItr +1;
    for x = 1:nodeNum                         %Change in distance
       
%        %Convection
%        if (airItr >= airSkips)
%        Ta(x,t+1)=Ta(x,t)+(Ts(x,t)-Ta(x,t))*h*convArea*dx/(massAir*cpAir); % Air temperature profile
%        else
        Ta(x+1,t+1)=Ta(x,t)+(Ts(x,t)-Ta(x,t))*h*convArea*dx/(massAir*cpAir); % Air temperature profile
%        end
       %Convection Slab
       Q = massAir*cpAir*(Ta(x+1,t+1)-Ta(x,t))*dt ;
       if(x < nodeNum)
       Ts(x,t+1)= Ts(x,t+1) + Ts(x,t)-(massAir*cpAir*dt*(Ta(x+1,t+1)-Ta(x,t)))/(nodeMass*cpSlab);

       %conduction not working rn
%        Ts(x,t+1) = Ts(x,t+1) - (kSlab*condArea*(Ts(x+1,t)-Ts(x,t))*dt/dx)/(nodeMass*cpSlab);
% Qi = kSlab*condArea*(Ts(x+1,t)-Ts(x,t))*dt/dx;
%        Ts(x+1,t+1) = Ts(x+1,t+1) - (kSlab*condArea*(Ts(x+1,t)-Ts(x,t))*dt/dx)/(nodeMass*cpSlab);
%        Ts(x+1,t+1) = Ts(x,t+1) + (massAir*cpAir*(Ta(x+1,t+1)-Ta(x,t))*dt*dx)/(dt*kSlab*condArea)+ Ts(x,t);

       end
       
    end
%     if (airItr >= airSkips)
%         airItr = 0;
%     end
end



