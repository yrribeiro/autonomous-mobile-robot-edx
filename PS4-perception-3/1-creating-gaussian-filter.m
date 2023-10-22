% Enter the values of your filter (note that we are looking for a row vector)
sigma = 1;
mean = 0;
radius = 2;

f = normpdf(-radius:radius, mean, sigma);
f = f./sum(f);