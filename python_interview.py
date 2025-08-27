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

# Q2 Find out the frequency of each letter in a string 

s = 'prakhar'
frequency = {}

for ch in s.lower():
    if ch.isalpha():
        if ch in frequency:
            frequency[ch] += 1
        else:
            frequency[ch] = 1  
            

print(frequency)

# -----------------------------------------------------------------------------------------------------------------

# Q3 python program for conversion of 2 list into dictionary

keys = ["a", "b", "c"]
values = [1, 2, 3]

my_dict = dict(zip(keys, values))

print(my_dict)
#------------------------------------------------------------------------------------------------------------------

