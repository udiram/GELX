function Integration2D(obj,flag, qmin, qmax, varargin)
% This function integrates 2D X-ray data various ways:

%  obj.Integral = Integration2D('i', InputFileName,qmin,qmax, minAngle, maxAngle, OutputFileName);
%           Integrates the data over a circular path along q_||. Integral
%           is a vector consisting out of [qpar data error]
%  obj.Integral = Integration2D('cr',InputFileName,qmin,qmax,minAngle, OutputFileName);
%           Integrates the data over a circular path along q_z resulting in
%           a circular integrated reflectivity. Integral is a vector consisting out of [qz data error]
%  obj.Integral = Integration2D('h',InputFileName,qmin,qmax,minAngle,maxAngle,OutputFileName);
%           Computes Hermans Orientation function. Integral includes [phi data error]
%  obj.Integral = Integration2D('lr',InputFileName,qmin,qmax, width,OutputFileName);
%           Computes a relectivity curve by integrating the rows of a
%           sqared cropped data set. The data gets cropped +-width/2 from
%           q|| = 0. Integral includes [qz data error]
%  obj.Integral = Integration2D('d',InputFileName,qmin,qmax, width,OutputFileName);
%           Computes the diffuse scattering profile by integrating
%           columnwise over a cropped version of the data. The data are
%           cropped +width from q||=0. Integral includes [qpar data error]
%  The Outputfile variable is optional. If not set, the function will
%  display the data but not save them. The outputfile includes Integral,
%  and all set parameters: qmin, qmax, minAngle ...
%
% Copyright & Questions: Laboratory of membrane and protein dynamics, McMaster University,
% Sebastian Himbert (himberts@mcmaster.ca), Dylan Malenfant (malenfad@mcmaster.ca)

NumVargin = numel(varargin);

SaveData = 0;

% Parse function Arguments and set Mode
if strcmp(flag,'i')
   Mode = 0;
   minAngle       = varargin{1};
   maxAngle       = varargin{2};
   if NumVargin == 3
      OutputFileName = varargin{3};
      SaveData = 1;
   end
elseif strcmp(flag,'cr')
   Mode     = 1;
   minAngle = varargin{1};
   maxAngle = 90;
   if NumVargin == 2
      OutputFileName = varargin{2};
      SaveData = 1;
   end
   if qmin < 0.04
      qmin = 0.04;
   end
elseif strcmp(flag,'h')
   Mode = 2;
   minAngle       = varargin{1};
   maxAngle       = varargin{2};
   if NumVargin == 3
      OutputFileName = varargin{3};
      SaveData = 1;
   end
elseif strcmp(flag,'lr')
   Mode = 3;
   width = varargin{1};
   if NumVargin == 2
      OutputFileName = varargin{2};
      SaveData = 1;
   end
elseif strcmp(flag,'d')
   Mode = 4;    
   width = varargin{1};
   if NumVargin == 2
      OutputFileName = varargin{2};
      SaveData = 1;
   end
end

data = obj.Data2D;
qpar = obj.qpar;
qz = obj.qz;
origin = obj.Origin;
DimX = obj.SizeX;
DimY = obj.SizeY;

%swap max and min if the user is being difficult
if(qmin > qmax)
    temp = qmin;
    qmin = qmax;
    qmax = temp;
end

if (Mode == 0 || Mode ==1 || Mode ==2) && (minAngle > maxAngle)
    temp = minAngle;
    minAngle = maxAngle;
    maxAngle = temp;
end


%Determine indeces of qmin and qmax in q_par or q_z, depending on the mode
if Mode == 0 || Mode ==2 
    [~, rad1] = min(abs(qpar-qmin)); %the index is given by the index of the minimum of qpar - qmin
    [~, rad2] = min(abs(qpar-qmax)); %same
    rad1 = rad1-origin(1);
    rad2 = rad2-origin(1);
elseif Mode == 1 || Mode == 3 || Mode ==4
    [~, rad1] = min(abs(qz-qmin));
    [~, rad2] = min(abs(qz-qmax));
     rad1 = rad1-origin(2);
     rad2 = rad2-origin(2);
end

% rad1 = qmin;
% rad2 = qmax;

rad1 = round(rad1);
rad2 = round(rad2);

%Display data as image
obj.Plot2Ddata('q');

%%

if Mode ~=3 && Mode ~= 4
    
%Allocate Memory for profile Array and Integral Array
ProfileIm = zeros(DimY,DimX);
Integral = zeros(rad2-rad1,3);
h = waitbar(0,'Perform 2D integration ...');

for rad = rad1 : 1 : rad2  %Run a loop starting with the outer radius and end up with the inner radius
    % Define a angular vector while phi is defined as angle from the
    % x-axis upwards. The stepsize was found to be optimal for qpar_max=1.9.
    % For larger q_par the stepsize should be increased to take all pixels
    % into account. Otherwise, there is a risk of missing pixels.

    waitbar((rad-rad1)/(rad2-rad1));
    
    if Mode == 1
        radtmp = qz(round(rad + origin(2)));
    else
        radtmp = qpar(round(rad + origin(1)));
    end
    
    phi = minAngle:.01:maxAngle;
    qpar_r = (radtmp.*cosd(phi)) ; 
    qz_r = (radtmp.*sind(phi)) ; 
    
    x = zeros(1,numel(qpar_r));
    y = zeros(1,numel(qz_r));
    
    for i = 1:1:numel(qpar_r)
        x(i) = obj.GetqparPos(qpar_r(i));
        y(i) = obj.GetqzPos(qz_r(i));
    end
    
    
    % round x and y down to get pixel values
    x = floor(x); 
    y = floor(y);
    
    qpar_rounded = qpar(x);
    qz_rounded = qz(y);
    
    % The angle phi can be also calculated using phi = atan(y/x). However x
    % and y need to take the shifted origin into account. PhiRounded
    % determines the angular position of every pixel on the circle. 
    
    PhiRounded =  atand(qz_rounded./qpar_rounded);  
    
    %Since the step size for phi is chosen small, multiple points of x and
    %y actually end up on the same pixel. Hence the slope of phi is
    %determined by substracting a shifted vector. 
    Slope = PhiRounded(2:end)-PhiRounded(1:end-1);
    
    %Parts with a slope = to 0 are discard.
    ZeroSlope = find(Slope~=0);
    PhiRounded = PhiRounded(ZeroSlope);
    x=x(ZeroSlope);
    y=y(ZeroSlope);
    
    % Export data on the circular line
    Profile = zeros(numel(x),3);
    for i = 1:1:numel(x)
            CurrentAngle = PhiRounded(i);
            Profile(i,1) = CurrentAngle; %angle
            Profile(i,2) = data(y(i),x(i)); %data
            Profile(i,3) = sqrt(data(y(i),x(i))); % Error per pixel is defined as the sqrt(I)
            ProfileIm(y(i),x(i)) = data(y(i),x(i)); % Save Data in the profile Array
    end
    
    CurrentNumPixels = numel(Profile(:,2));
    
    if Mode==0
        Integral(rad2 - rad + 1,1) = qpar(floor(rad+origin(1))); % X cordinate is given by qpar
        Integral(rad2 - rad + 1,2) = mean(Profile(:,2)); % The integral itself is given by the average intensity of every profile
        Integral(rad2 - rad + 1,3) = sqrt(sum(Profile(:,3).^2))/CurrentNumPixels; % Error is given by errorpropagation normalized by the number of pixels
    elseif Mode==1
        Integral(rad2 - rad + 1,1) = qz(floor(origin(2)+rad)); % X cordinate is given by qz: qz itself is inverted ( qz=[qz_max ... 0]). Hence one need to substract the radius here
        Integral(rad2 - rad + 1,2) = mean(Profile(:,2)); % The integral itself is given by the average intensity of every profile
        Integral(rad2 - rad + 1,3) = sqrt(Integral(rad2 - rad + 1,2));
    elseif Mode==2
        Integral = Profile; % Just write one profile in Integral
    end
    clear Profile;
end 
close(h);
if Mode == 1
    % The circular integration of the q_z axis takes only the positive half
    % into account. Assuming symetrie, the integral needs to be doubled to
    % take the negative half part account.
    Integral(:,2) = 2*Integral(:,2); 
end
%%
elseif Mode==3
  CropedData = data(rad1:rad2,round(origin(1)-width/2):round(origin(1)+width/2));  % Crop Data
  
  % Set all values outside of the cropped area in ProfileIm to zero
  ProfileIm = data;
  ProfileIm(1:rad1,round(origin(1)-width/2):round(origin(1)+width/2)) = 0;
  ProfileIm(rad2:end,round(origin(1)-width/2):round(origin(1)+width/2)) = 0;
  ProfileIm(:,1:round(origin(1)-width/2-1)) = 0;
  ProfileIm(:,round(origin(1)+width/2+1):end) = 0;
  
  %Integral is just the average over all data
  Integral(:,1) = qz(rad1:rad2);
  Integral(:,2) = mean(CropedData,2);
  Integral(:,3) = sqrt(Integral(:,2));  
elseif Mode==4
  CropedData = data(rad1:rad2,origin(1):origin(1)+width); % Crop Data
  % Set all values outside of the cropped area in ProfileIm to zero
  ProfileIm = data;
  ProfileIm(1:rad1,origin(1):origin(1)+width) = 0;
  ProfileIm(rad2:end,origin(1):origin(1)+width) = 0;
  ProfileIm(:,1:origin(1)) = 0;
  ProfileIm(:,origin(1)+width+1:end) = 0;
  %Integral is just the average over all data
  Integral(:,1) = qpar(origin(1):origin(1)+width);
  Integral(:,2) = mean(CropedData,1);
  Integral(:,3) = sqrt(Integral(:,2)); 
end
%%
close gcf;

if Mode==0
obj.Inplane = Integral;
obj.qminI = qmin;
obj.qmaxI = qmax;
obj.minAngleI = minAngle;
obj.maxAngleI = maxAngle;
elseif Mode == 1
obj.CircRefl = Integral;
obj.qminCr = qmin;
obj.qmaxCr = qmax;
obj.minAngleCr = minAngle;
elseif Mode == 2
obj.Herman = Integral;
obj.qminH = qmin;
obj.qmaxH = qmax;
obj.minAngleH = minAngle;
obj.maxAngleH = maxAngle;
elseif Mode == 3
obj.LinRefl = Integral;
obj.qminLr = qmin;
obj.qmaxLr = qmax;
obj.widthLr = width;
elseif Mode == 4
obj.Diffuse = Integral;
obj.qminD = qmin;
obj.qmaxD = qmax;
obj.widthD = width;
end

% Plot Data
logdata = log(ProfileIm);
logdata(logdata == -inf) = 0;
pcolorPlot = pcolor(qpar,qz,logdata);
box on;
set(gca,'layer','top')
set(pcolorPlot,'EdgeColor','none');
colormap default
caxis([2 10]);
xlabel('$q_{||}$ ($\AA^{-1}$)','Interpreter','latex');
ylabel('$q_{z}$ ($\AA^{-1}$)','Interpreter','latex');  
set(gcf,'position',[200 50 850 700]);
pbaspect([1 1 1]);

figure()
    errorbar(Integral(:,1),Integral(:,2),Integral(:,3),'.');
    if Mode==0 || Mode == 4 
        xlabel('$q_{||}$ ($\AA^{-1}$)','Interpreter','latex');
    elseif Mode == 1 || Mode == 3 
        xlabel('$q_{z}$ ($\AA^{-1}$)','Interpreter','latex');
    else
        xlabel('$\phi$ (deg)','Interpreter','latex');
    end
    ylabel('Intensity','Interpreter','latex');
    set(gcf,'position',[600 50 850 700]);
    if Mode==1 || Mode ==3
        set(gca, 'YScale', 'log');
    end

%%
% Save Data (Optional)
if SaveData==1
    t = datetime('now','Format','MMddyyyy');
    t = string(t);
    if Mode == 0
        OutputFileName = sprintf('%s_inplane_%s',OutputFileName,t);
        save(OutputFileName,'Integral','qmin','qmax','minAngle','maxAngle');
    elseif Mode == 1
        OutputFileName = sprintf('%s_circref_%s',OutputFileName,t);
        save(OutputFileName,'Integral','qmin','qmax','minAngle','maxAngle');
    elseif Mode == 2
        OutputFileName = sprintf('%s_herman_%s',OutputFileName,t);
        save(OutputFileName,'Integral','qmin','qmax','minAngle','maxAngle');
    elseif Mode == 3
        OutputFileName = sprintf('%s_linref_%s',OutputFileName,t);
        save(OutputFileName,'Integral','qmin','qmax','width');
    elseif Mode == 4
        OutputFileName = sprintf('%s_diffuse_%s',OutputFileName,t);
        save(OutputFileName,'Integral','qmin','qmax','width');
    end
end

end