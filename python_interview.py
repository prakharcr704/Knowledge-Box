# Python interview questions.

# Q1. Find out the common letters between two strings.

s1 = 'prakhar'
s2 = 'gupta'

common = set(s1) & set(s2)
# return a sorted list of common alphabets.
print(sorted(list(common)))

# Another way using for loop and iterate over the strings.
common = []

for ch in s1.lower():
    if ch.isalpha() and ch in s2.lower() and ch not in common:
        common.append(ch)
print(common)

# ---------------------------------------------------------------------------------------------------------------
