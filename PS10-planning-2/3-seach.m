% Initialize map, search start and goal as well as the solution map
Map = zeros(11, 9);
Map(1, :) = -1; Map(11, :) = -1; Map(:, 1) = -1; Map(:, 9) = -1;
Map(9, 2) = -1; Map(10, 2) = -1; Map(10, 3) = -1; Map(5:6, 5:8) = -1;

SearchStart = [3, 7];
SearchGoal = [9, 6];

SolutionMap = Inf * ones(size(Map)); % store g-values in here during search

% A* search
% Initialize the binary min-heap with a custom structure
BinMinHeap = struct('pos', {}, 'g', {}, 'h', {}, 'key', {});

% Insert search start onto heap, using the Euclidean distance as the heuristic
startG = 0;
startH = norm(SearchGoal - SearchStart);
startKey = startG + startH;

% Reuse the insert function you developed
insert(struct('pos', SearchStart, 'g', startG, 'h', startH, 'key', startKey));

goalReached = false;
while ~isempty(BinMinHeap) && ~goalReached
    % Extract the top element from the heap and make it consistent again
    CurrState = extract(BinMinHeap);

    % Store the g value (cost so far) of the state in the solution map,
    % but only if this position has not been expanded before already
    if isinf(SolutionMap(CurrState.pos(1), CurrState.pos(2)))
        SolutionMap(CurrState.pos(1), CurrState.pos(2)) = CurrState.g;
    end

    % Terminate search if CurrState is the goal
    if isequal(CurrState.pos, SearchGoal)
        goalReached = true;
        continue;
    end

    % Expand neighbors of CurrState using the 8-neighborhood
    neighbors = [
        CurrState.pos(1) - 1, CurrState.pos(2);
        CurrState.pos(1) + 1, CurrState.pos(2);
        CurrState.pos(1), CurrState.pos(2) - 1;
        CurrState.pos(1), CurrState.pos(2) + 1;
        CurrState.pos(1) - 1, CurrState.pos(2) - 1;
        CurrState.pos(1) - 1, CurrState.pos(2) + 1;
        CurrState.pos(1) + 1, CurrState.pos(2) - 1;
        CurrState.pos(1) + 1, CurrState.pos(2) + 1;
    ];

    for i = 1:size(neighbors, 1)
        neighborX = neighbors(i, 1);
        neighborY = neighbors(i, 2);

        % Calculate neighbor g and h values
        neighborG = CurrState.g + 1; % Assuming a cost of 1 for movement
        neighborH = norm(SearchGoal - [neighborX, neighborY]);

        % Check if the neighbor is within the map boundaries and is not occupied
        if neighborX >= 1 && neighborX <= size(Map, 1) && neighborY >= 1 && neighborY <= size(Map, 2) && Map(neighborX, neighborY) == 0
            % Insert the neighbor into the heap and ensure the heap is consistent
            insert(BinMinHeap, struct('pos', [neighborX, neighborY], 'g', neighborG, 'h', neighborH, 'key', neighborG + neighborH));
        end
    end
end

% Visualize the solution map (g values)
imagesc(SolutionMap)
set(gca, 'dataAspectRatio', [1 1 1])
