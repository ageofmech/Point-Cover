clear,clc
t = cputime;
%primitives
nPoints = 30; %number of targets
rad = 50; %radius of look
scanRad = 5*rad;
%ppSample = 10; %per point samples
circles = zeros(nPoints,2);
numCircles = 0;

%pick points
x = rand(nPoints,2);
x(:,1) = sqrt(x(:,1)).*scanRad;
x(:,2) = x(:,2)*2*pi;
x = [x(:,1).*cos(x(:,2)),x(:,1).*sin(x(:,2))];
y = ones(nPoints,1);

% ppSample = floor(mean(pdist(x,'euclidean'))/rad*2);
ppSample = 10;

%generate ppSample circles per point
c_rad = rand(nPoints*ppSample,1)*rad;
c_vec = rand(nPoints*ppSample,2).*2.-1;
twoNorm = sqrt(sum(abs(c_vec').^2,1))';
c_vec = [c_vec(:,1)./twoNorm.*c_rad,c_vec(:,2)./twoNorm.*c_rad];

%pick circles
for i=1:nPoints
    if y(i) == 0
        continue
    end
    currentCircle = 0;
    currentMaxEnclosed = 0;
    currentCenter = [0,0];
    ii = (i-1)*10;
    for j = 1:ppSample
        tempCenter = x(i,:)+c_vec(ii+j);
        tempEnclosed = sum(sqrt(sum(bsxfun(@minus,tempCenter,x)'.^2,1))'<rad .* y);
        if(tempEnclosed>currentMaxEnclosed)
            currentCenter = tempCenter;
            currentCircle = ii+j;
            currentMaxEnclosed = tempEnclosed;
        end
    end
    y = max(y-(sqrt(sum(bsxfun(@minus,currentCenter,x)'.^2,1))'<rad),0);
    numCircles = numCircles + 1;
    circles(numCircles,:) = currentCenter;
    if max(y)<1
        break
    end
end
time = cputime - t;
%draw points and circles
scatter(x(:,1),x(:,2),'filled');
hold on
viscircles([0,0],scanRad,'Color','b');
for i=1:nPoints
    if abs(circles(i,1))>0
        viscircles(circles(i,:),rad);
    end
end
ax = scanRad + rad;
axis([-ax,ax,-ax,ax]);
axis('square');

