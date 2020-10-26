# Ruby complements
class ::Hash
	def deep_merge(second)
		merger = proc { |key, v1, v2| Hash === v1 && Hash === v2 ? v1.merge(v2, &merger) : v2 }
		self.merge(second, &merger)
	end

	def to_struct
		Struct.new(*keys.map(&:to_sym)).new(*values.to_struct)
	end
end

class ::Array
	def to_struct
		map { |value| value.respond_to?(:to_struct) ? value.to_struct : value }
	end
end
