% the following elements are to be inserted into the heap
ElementsToInsert = struct('pos', {}, 'key', {});
ElementsToInsert(1).pos = [3,1]; ElementsToInsert(1).key = 4;
ElementsToInsert(2).pos = [3,2]; ElementsToInsert(2).key = 2;
ElementsToInsert(3).pos = [3,3]; ElementsToInsert(3).key = 1;
ElementsToInsert(4).pos = [4,2]; ElementsToInsert(4).key = 3;

% binary min-heap container
% use the same structure as for "ElementsToInsert"
BinMinHeap = ElementsToInsert; % Initialize the heap with the elements
swap = @(a, b) temp = BinMinHeap(a); BinMinHeap(a) = BinMinHeap(b); BinMinHeap(b) = temp;
insert = @(element) BinMinHeap = [BinMinHeap, element]; % Insert at the end

n = length(BinMinHeap);
while n > 1
    parent = floor(n / 2);
    if BinMinHeap(n).key < BinMinHeap(parent).key
        swap(n, parent);
        n = parent;
    else
        break; % The heap property is satisfied
    end
end

%% --------------------
% Extract op

% Define the binary min-heap as an array of elements
BinMinHeap = struct('pos', {}, 'key', {});
BinMinHeap(1).pos = [3, 1]; BinMinHeap(1).key = 1;
BinMinHeap(2).pos = [3, 2]; BinMinHeap(2).key = 2;
BinMinHeap(3).pos = [3, 3]; BinMinHeap(3).key = 4;
BinMinHeap(4).pos = [4, 2]; BinMinHeap(4).key = 3;
BinMinHeap(5).pos = [5, 2]; BinMinHeap(5).key = 6;

% Function to swap two elements in the heap
swap = @(a, b) temp = BinMinHeap(a); BinMinHeap(a) = BinMinHeap(b); BinMinHeap(b) = temp;

% Function to find the minimum child index
minChild = @(index) left = 2 * index; right = 2 * index + 1;
    if right <= length(BinMinHeap)
        if BinMinHeap(left).key < BinMinHeap(right).key
            left;
        else
            right;
        end
    else
        left;
    end

% Extract function
extract = @() 
    % Store the top element for return
    extracted = BinMinHeap(1);
    
    % Move the last element to the top
    BinMinHeap(1) = BinMinHeap(end);
    BinMinHeap(end) = [];
    
    % Make the heap consistent by moving the new top element down the binary tree
    n = 1;
    while true
        child = minChild(n);
        if child <= length(BinMinHeap) && BinMinHeap(child).key < BinMinHeap(n).key
            swap(child, n);
            n = child;
        else
            break; % The heap property is satisfied
        end
    end
    
    extracted; % Return the extracted element
end

% Call the extract function to extract an element
extractedElement = extract();
disp('Extracted Element:');
disp(extractedElement);

% After the extraction, the BinMinHeap should be consistent
disp('Updated BinMinHeap:');
disp(BinMinHeap);
