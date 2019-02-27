### Two Sum

Given an array of integers, return indices of the two numbers such that they add up to a specific target.

You may assume that each input would have exactly one solution, and you may not use the same element twice.

**Example:**
```
Given nums = [2, 7, 11, 15], target = 9,

Because nums[0] + nums[1] = 2 + 7 = 9,
return [0, 1].
```

**Solution:**
```
def two_sum(nums, target, have = {})
  nums.each_with_index { |n, i| have[k = target - n] ? (return [have[k], i]) : have[n] = i }
end
```

### Find the odd int
Given an array, find the int that appears an odd number of times.

There will always be only one integer that appears an odd number of times.

**Solution:**
```
def find_it(arr)
  arr.reduce(:^)
end
```