% initialize map, search start and goal as well as the solution map
Map = zeros(11,9);
Map(1,:) = -1; Map(11,:) = -1; Map(:,1) = -1; Map(:,9)     = -1;
Map(9,2) = -1; Map(10,2) = -1; Map(10,3)= -1; Map(5:6,5:8) = -1;

SearchStart = [3,7];
SearchGoal  = [9,6];

SolutionMap = Inf*ones(size(Map)); %store g-values in here during search


% A* search
% insert search start onto heap, using the Euclidean distance as heuristic
BinMinHeap(1).pos = SearchStart;
BinMinHeap(1).g   = 0;
BinMinHeap(1).h   = norm(SearchGoal-SearchStart);
BinMinHeap(1).key = BinMinHeap(1).g+BinMinHeap(1).h;

% iteratively expand states
goalReached = false;
while length(BinMinHeap) ~= 0 && ~goalReached
    % extract top element from heap (reuse your code from before) and
    % make it consistent again
    CurrState = BinMinHeap(1);
    BinMinHeap(1)   = BinMinHeap(end);
    BinMinHeap(end) = [];
    heapSize        = length(BinMinHeap);
    consistent = false; n = 1;
    while ~consistent
        if heapSize >= 2*n+1 && BinMinHeap(n).key > min(BinMinHeap(2*n).key, BinMinHeap(2*n+1).key)
            [minKey,minKeyIdx] = min([BinMinHeap(2*n).key, BinMinHeap(2*n+1).key]);
            nNext = 2*n-1+minKeyIdx;
            BinMinHeap([n nNext]) = BinMinHeap([nNext n]);
            n = nNext;
        elseif 2*n == heapSize && BinMinHeap(n).key > BinMinHeap(2*n).key
            nNext = heapSize;
            BinMinHeap([n nNext]) = BinMinHeap([nNext n]);
            n = nNext;
        else
            consistent = true;
        end
    end

    %store the g value (cost so far) of the state in the solution map
    if ~isinf(SolutionMap(CurrState.pos(1),CurrState.pos(2)))
        continue;
    end
    SolutionMap(CurrState.pos(1),CurrState.pos(2)) = CurrState.g;

    % terminate search in case currState is the goal
    if CurrState.pos == SearchGoal
        goalReached = true;
        continue;
    end

    % expand neighbors of currState using the 8-neighborhood
    % i.e., straigt and diagonal neighbors. Traversal to diagonal
    % neighbors incurs a cost of sqrt(2). Insert them into the heap
    % and ensure that the heap becomes consistent again
	dx = [-1, 0, 1,-1, 1,-1, 0, 1];
    dy = [-1,-1,-1, 0, 0, 1, 1, 1];
    for n=1:1:size(dx,2)
        % insert expanded states at the end of the heap if cell
        % is not occupied
        ExpandedState.pos = CurrState.pos + [dx(n),dy(n)];
        if Map(ExpandedState.pos(1),ExpandedState.pos(2)) == -1
        	continue;
        end
        ExpandedState.g   = CurrState.g + norm([dx(n),dy(n)]);
        ExpandedState.h   = norm(SearchGoal-ExpandedState.pos);
        ExpandedState.key = ExpandedState.g+ExpandedState.h;
        BinMinHeap        = [BinMinHeap; ExpandedState];

        %make heap consistent by moving the inserted element
        %up the binary tree
        m = length(BinMinHeap);
        while m > 1 && BinMinHeap(floor(m/2)).key > BinMinHeap(m).key
            BinMinHeap([m floor(m/2)]) = BinMinHeap([floor(m/2) m]);
            m = floor(m/2);
        end
    end
end

% extract solution path from goal to start. Also check, whether
% the search actually found a solution (check for "Inf" values)
OptimalPath = SearchGoal; % Initialize the path with the goal

% Check if a solution was found (i.e., the goal is reachable)
if ~isinf(SolutionMap(SearchGoal(1), SearchGoal(2)))
    % While the current position is not the start position
    while ~isequal(OptimalPath(end, :), SearchStart)
        x = OptimalPath(end, 1);
        y = OptimalPath(end, 2);

        % Create a neighborhood of possible next positions (8 neighbors)
        dx = [-1, 0, 1, -1, 1, -1, 0, 1];
        dy = [-1, -1, -1, 0, 0, 1, 1, 1];

        % Initialize variables to find the next optimal position
        minG = Inf;
        nextX = x;
        nextY = y;

        % Iterate through the neighborhood and find the minimum "g" value
        for n = 1:length(dx)
            neighborX = x + dx(n);
            neighborY = y + dy(n);

            % Check if the neighbor is within the map boundaries
            if neighborX >= 1 && neighborX <= size(Map, 1) && neighborY >= 1 && neighborY <= size(Map, 2)
                neighborG = SolutionMap(neighborX, neighborY);

                if neighborG < minG
                    minG = neighborG;
                    nextX = neighborX;
                    nextY = neighborY;
                end
            end
        end

        % Append the next optimal position to the path
        OptimalPath = [OptimalPath; [nextX, nextY]];
    end

    % Reverse the path to start from the beginning
    OptimalPath = flipud(OptimalPath);
end

% Display the solution path
disp(OptimalPath)