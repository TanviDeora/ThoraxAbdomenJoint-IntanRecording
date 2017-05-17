function [sorted_prime_numbers]=PrimeNumGen(freq_max,numPrimes)
% written by Tanvi, May 2017
% to generate N prime sine numbers to check motor input-outout curve
% Input: freq_max =  Maximum freq that you want to include
% numPrimes = total number of primes we want
% output: sorted_prime_numbers = sorted Sequence of Prime Numbers

p = primes(freq_max);
S = randperm(numel(p),numPrimes); % get 10 random indecies
sorted_prime_numbers = sort(p(S));
