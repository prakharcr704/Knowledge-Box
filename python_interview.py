# Python interview questions.

# Q1. Find out the common letters between two strings.

s1 = 'prakhar'
s2 = 'gupta'

common = set(s1) & set(s2)
# return a sorted list of common alphabets.
print(sorted(list(common)))

