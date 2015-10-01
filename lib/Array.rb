class Array
	def mean
		(reduce(:+).to_f / size).round(0)
	end
end