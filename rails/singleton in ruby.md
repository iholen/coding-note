## singleton\_class & singleton_method
```ruby
class A
	def say
		puts "I'm class A"
	end
end

module Single
	def say_single
		puts 'say_single'
	end
end

a = A.new

# The following cases will define a singleton_method to instance a

# case 1
def a.say_single
	puts 'say_single'
end	

# case 2
a.define_singleton_method(:say_single) do
	puts 'say_single'
end

# case 3
a.extend(Single)

# case 4
a.instance_eval do
	def say_single
		puts 'say_single'
	end
end

# case 5
a.singleton_class.class_eval do
	def say_single
		puts 'say_single'
	end
end

# case 6
a.singleton_class.include(Single)

```

----------
作者 [@iholen](https://github.com/iholen)

2018 年 08月 31日