module Folds
	def null?
		if(length > 0)
			return false
		end
		true
	end

	def foldr1 &b
		e = foldr(nil) {|x , s| x}
		foldr(e) {|x, s| b.call(x , s)}
	end

	def length
		foldr(0) {|_ , s| s + 1}
	end

	def all &b
		foldr(true) {|x , s| b.call(x) && s}
	end
	def any &b
		foldr(false) {|x , s| b.call(x) || s}
	end
	def to_arr
		foldr([]) {|x , s| s.unshift(x)}
	end
	def elem? to_find
		any {|x| x == to_find}
	end
end

class Array
	include Folds
	def foldr e, &b
		# Su código aquí
		if self.empty?
			e
		else
			self.reverse_each {|i| e = b.call(i , e)}
			e
		end
	end
end

class Rose
	include Folds
	attr_accessor :elem, :children
	def initialize elem, children = []
		@elem = elem
		@children = children
	end
	def add elem
		@children.push elem
		self
	end
	def foldr e, &b
		c  =  e
		@children.reverse_each do |child|
			c = child.foldr(c) {|y , z| b.call(y , z)}
		end
		b.call(@elem , c)
	end
end

class Rose
	def avg
		total = foldr([0 , 0]) {|x , s| [s[0] + 1 , s[1] + x]}
		total[1].to_f / total[0]
	end
end