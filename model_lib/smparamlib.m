%     SYNCHRONOUS MACHINE PARAMETERS <smparamlib.m>

% ------------------------  DATA  --------------------------------------------
%                      Machine parameters (pu) :
        Ra=.018;           %Stator resistance     
        Ld=1.15;           %Direct-axis synchronous inductance
        Lq=.75;            %Quadrature-axis synchronous inductance 
        Lal=0.15;          %Armature leakage inductance  
        Rf=0.001;          %Field resistance
        Lfl=0.2;           %Field leakage inductance
        Rkd=0.02;          %Direct-axis damper resistance 
        Lkdl=0.11;         %Direct-axis damper leakage inductance
        Rkq=0.04;          %Quadrature-axis damper resistance
        Lkql=0.15;         %Quadrature-axis damper leakage inductance
        freq0=60;          %Frequency [Hz]
        Lmd=Ld-Lal;
        Lmq=Lq-Lal; 
        wo=2*pi*freq0 ;
% ----------------------------------------------------------------------------

%                 INDUCTANCES    
      L=[Lal+Lmd    0     Lmd     0       Lmd
           0    Lal+Lmq   0       Lmq      0
         Lmd       0      Lmd+Lkdl 0      Lmd
         0       Lmq      0       Lmq+Lkql 0
         Lmd       0       Lmd     0      Lmd+Lfl]; 
         
      L_1=inv(L); %Inverse inductance matrix
Ts = 1e-4;
% ----------------------------------------------------------------------------           
      