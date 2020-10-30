# Takes an array of hashes, and merges them into one big hash

Puppet::Functions.create_function(:'flatten_array_of_hashes_to_hash') do
	# @param [Array[Hash]] in_a The array of hashes to flatten
	# @return [Hash] The resulting flattened hash
	# @example
	#   flatten_array_of_hashes_to_hash([{ a => 1}, { a => 2 }, { b => 3}]) => { a => [ 1, 2 ], b => 3 }
	dispatch :do_flatten do
		required_param 'Array[Hash]', :in_a
		return_type 'Hash'
	end

	def do_flatten(in_a)
		res = {}
		in_a.each do |e|
			e.each do |k, v|
				if res[k] then
					if res[k].is_a?(Array) then
						if v.is_a?(Array) then
							res[k].push(*v)
						else
							res[k] << v
						end
					else
						t_v = res[k]
						res[k] = [ t_v, v ]
					end
				else
					res[k] = v
				end
			end
		end
		return res
	end
end
