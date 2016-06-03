clear,clc

%primitives
nPoints = 30; %number of targets
rad = 50; %radius of look
scanRad = 5*rad; %scanning limit of beam
circles = zeros(nPoints,2); %prealloc space for solution
numCircles = 0; %start with 0 circles
dpTarget = 8; %number of circles per target

%pick points
x = rand(nPoints,2);
x(:,1) = sqrt(x(:,1)).*scanRad;
x(:,2) = x(:,2)*2*pi;
x = [x(:,1).*cos(x(:,2)),x(:,1).*sin(x(:,2))];
y = ones(nPoints,1);

%generate dpTarget disks per target
angle = (1:dpTarget)*(2*pi/dpTarget);
nn = rad.*[cos(angle)',sin(angle)'];

%select disks greedily
sum1 = 0;
for i=1:nPoints
    if y(i) == 0 %if a point was previously covered then skip
        continue
    end
    currentMaxEnclosed = 0;
    currentCenter = [0,0];
    for j = 1:dpTarget
        tempCenter = x(i,:)+nn(j,:);
        tempEnclosed = sum(sqrt(sum(bsxfun(@minus,tempCenter,x)'.^2,1))'<=rad+0.01 .* y);
        if(tempEnclosed>currentMaxEnclosed)
            currentCenter = tempCenter;            
            currentMaxEnclosed = tempEnclosed;
        end
    end
    y = max(y-(sqrt(sum(bsxfun(@minus,currentCenter,x)'.^2,1))'<=rad+0.01),0);
    numCircles = numCircles + 1;
    sum1 = sum1 + currentMaxEnclosed;
    circles(numCircles,:) = currentCenter;
    if max(y)<1 %if all points are covered then conclude disk selection
        break
    end
end

%draw points and circles
% [idx, C] = kmeans(x,numCircles);
% x1 = min(x(:,1)):1:max(x(:,1));
% x2 = min(x(:,2)):1:max(x(:,2));
% [x1G,x2G] = meshgrid(x1,x2);
% XGrid = [x1G(:),x2G(:)]; % Defines a fine grid on the plot
% idx2Region = kmeans(XGrid,numCircles,'MaxIter',1,'Start',C);
% gscatter(XGrid(:,1),XGrid(:,2),idx2Region);
% hold on
scatter(x(:,1),x(:,2),'filled');
hold on
viscircles([0,0],scanRad,'Color','b');
for k=1:nPoints
    if abs(circles(k,1))>0
        viscircles(circles(k,:),rad);
    end
end
ax = scanRad + rad;
axis([-ax,ax,-ax,ax]);
axis('square');



