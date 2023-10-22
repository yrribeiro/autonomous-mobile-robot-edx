% initialize map, search start and goal as well as the solution map
Map = zeros(11,9);
Map(1,:) = -1; Map(11,:) = -1; Map(:,1) = -1; Map(:,9)     = -1;
Map(9,2) = -1; Map(10,2) = -1; Map(10,3)= -1; Map(5:6,5:8) = -1;

SearchStart = [3,7];
SearchGoal  = [9,6];

% visualize the map
imagesc(Map)
set(gca,'dataAspectRatio',[1 1 1])