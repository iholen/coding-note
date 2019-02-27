## includes

```ruby
customers = org.customers.includes(:contacts).order('contacts.is_primary desc').ids
```

```ruby
# activerecord-5.1.2/lib/active_record/relation/query_methods.rb
def includes(*args)
  check_if_method_has_arguments!(:includes, args)
  spawn.includes!(*args)
end

# 只是设置了includes_values
def includes!(*args)
  args.reject!(&:blank?)
  args.flatten!

  self.includes_values |= args
  self
end
```

```ruby
# activerecord-5.1.2/lib/active_record/relation.rb
# 最终执行查询
def exec_queries(&block)
	@records = eager_loading? ? find_with_associations.freeze : @klass.find_by_sql(arel, bound_attributes, &block).freeze
	
	preload = preload_values
	preload += includes_values unless eager_loading?
	preloader = nil
	preload.each do |associations|
	  preloader ||= build_preloader
	  preloader.preload @records, associations
	end
	
	@records.each(&:readonly!) if readonly_value
	
	@loaded = true
	@records
end

def build_preloader
	ActiveRecord::Associations::Preloader.new
end
```

```ruby
# activerecord-5.1.2/lib/active_record/associations/preloader.rb
def preload(records, associations, preload_scope = nil)
	records       = Array.wrap(records).compact.uniq
	associations  = Array.wrap(associations)
	preload_scope = preload_scope || NULL_RELATION
	
	if records.empty?
	  []
	else
	  # associations is [:contacts]
	  associations.flat_map { |association|
	    preloaders_on association, records, preload_scope
	  }
	end
end

private
    # Loads all the given data into +records+ for the +association+.
    def preloaders_on(association, records, scope)
      case association
      when Hash
        preloaders_for_hash(association, records, scope)
      when Symbol
        preloaders_for_one(association, records, scope)
      when String
        preloaders_for_one(association.to_sym, records, scope)
      else
        raise ArgumentError, "#{association.inspect} was not recognized for preload"
      end
    end
    
    def preloaders_for_one(association, records, scope)
      grouped_records(association, records).flat_map do |reflection, klasses|
        klasses.map do |rhs_klass, rs|
          loader = preloader_for(reflection, rs, rhs_klass).new(rhs_klass, rs, reflection, scope)
          loader.run self
          loader
        end
      end
    end
```
# 未完待续

----------
作者 [@iholen](https://github.com/iholen)

2018 年 08月 31日
