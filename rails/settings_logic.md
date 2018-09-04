##SettingsLogic隐藏的坑
场景如下：

### 有配置文件

```yaml
# config/example.yml
my_key: 
	value: "this is my origin value"	
```

### 有类Test继承SettingsLogic

```ruby
class Test < Settingslogic
  source "#{Rails.root}/config/example.yml"
  
  def self.my_key
    Test[:my_key][:value]
  end
end  
```

### rails c 进入控制台查看

```shell
[1] pry(main)> Test.instance_variables
=> [:@source, :@namespace]
[2] pry(main)> Test.my_key
=> "this is my origin value"
[3] pry(main)> Test.instance_variables
=> [:@source, :@namespace, :@instance]
[4] pry(main)> Test.my_key
=> {"value"=>"this is my origin value"}
```
### 这么写的人可能是想直接取到my_key的value值，但是从运行结果来看，是不是很疑惑?(为什么第一次的结果是预期的，再运行一次就不对了呢)，好奇心驱使我去看了下源码，从我在控制台执行的instance_variables可以看出，执行完一次重写的my_key方法后，Test的instance_variables结果中多了一个@instance，看如下代码：

```ruby
class << self
	... # 此处有省略
	def [](key)
     instance.fetch(key.to_s, nil) # 1. 在执行Test[:my_key]会执行此处，所以我们再去看一下instance从何而来
   end

	private
		# 此处是单例模式，只会产生一个实例
      def instance
        return @instance if @instance
        @instance = new  # 2. 执行的new方法，所以我们转去看initialize方法
        create_accessors!
        @instance
      end   
   
   	   def method_missing(name, *args, &block)
        instance.send(name, *args, &block)
      end

      # It would be great to DRY this up somehow, someday, but it's difficult because
      # of the singleton pattern.  Basically this proxies Setting.foo to Setting.instance.foo
      def create_accessors!
        instance.each do |key,val|
          create_accessor_for(key)
        end
      end

      def create_accessor_for(key)
        return unless key.to_s =~ /^\w+$/  # could have "some-setting:" which blows up eval
        instance_eval "def #{key}; instance.send(:#{key}); end"
      end

# 3. 从代码看到，initialize首先会读取文件，然后转换成hash对象，然后将类本身replace成获取到的hash，再去执行create_accessors!(此处的create_accessors!动态定义了一些类方法，方法名为Hash所有第一级的key)
def initialize(hash_or_file = self.class.source, section = nil)
    #puts "new! #{hash_or_file}"
    case hash_or_file
    when nil
      raise Errno::ENOENT, "No file specified as Settingslogic source"
    when Hash
      self.replace hash_or_file
    else
      file_contents = open(hash_or_file).read
      hash = file_contents.empty? ? {} : YAML.load(ERB.new(file_contents).result).to_hash
      if self.class.namespace
        hash = hash[self.class.namespace] or return missing_key("Missing setting '#{self.class.namespace}' in #{hash_or_file}")
      end
      self.replace hash
    end
    @section = section || self.class.source  # so end of error says "in application.yml"
    create_accessors!
end 

# This handles naming collisions with Sinatra/Vlad/Capistrano. Since these use a set()
# helper that defines methods in Object, ANY method_missing ANYWHERE picks up the Vlad/Sinatra
# settings!  So settings.deploy_to title actually calls Object.deploy_to (from set :deploy_to, "host"),
# rather than the app_yml['deploy_to'] hash.  Jeezus.
def create_accessors!
	self.each do |key,val|
	  create_accessor_for(key)
	end
end

# Use instance_eval/class_eval because they're actually more efficient than define_method{}
# http://stackoverflow.com/questions/185947/ruby-definemethod-vs-def
# http://bmorearty.wordpress.com/2009/01/09/fun-with-rubys-instance_eval-and-class_eval/
def create_accessor_for(key, val=nil)
	return unless key.to_s =~ /^\w+$/  # could have "some-setting:" which blows up eval
	instance_variable_set("@#{key}", val)
	self.class.class_eval <<-EndEval   # 4.所以在此处又重写了self.my_key方法，采用SettingsLogic自己的定义方法，所以在类中定义的方法没有效果
	  def #{key}
	    return @#{key} if @#{key}
	    return missing_key("Missing setting '#{key}' in #{@section}") unless has_key? '#{key}'
	    value = fetch('#{key}')
	    @#{key} = if value.is_a?(Hash)
	      self.class.new(value, "'#{key}' section in #{@section}")
	    elsif value.is_a?(Array) && value.all?{|v| v.is_a? Hash}
	      value.map{|v| self.class.new(v)}
	    else
	      value
	    end
	  end
	EndEval
end   
    
```

### 小结

1. []方法 会获取instance
2. 获取instance会执行initailize
3. initailize方法会执行实例方法 create_accessors! 会定义以Hash第一层key为方法名的一系列类方法
4. new完instance之后会 执行私有方法 create_accessors!  之后会定义该实例以第一层key为方法名的一系列的单例方法
5. 所以在第三步会重写掉 类中自己定义的同名类方法

### 个人建议

避免定义的方法名是配置文件中的key, 这样可以避免程序里面其他地方调用了一次[]之后，影响其他地方调用my_key方法的值，引发错误，定义其他名称的类方法即可

----------
作者 [@holen](https://github.com/holen)

2018 年 08月 31日