module Folds
	def length
		foldr(0) {|_ , s| s + 1}
	end
end

class Array
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
		# Su código aquí
		#puts "Aqui"
		
		#puts other
		#puts b
		#puts "End Aqui"

		c  =  e
		@children.reverse_each do |child|
			c = child.foldr(c) {|y , z| b.call(y , z)}
		end
		
		#other = @children.foldr(e) {|x , s| b.call( (x.foldr(e) &b) , s)}
		#other = @children.foldr(e) {|x , s| b.call( (x.foldr(e) {|y , z| y + z}) , s)}
		#other = @children.foldr(e) {|x , s| b.call( (x.foldr(e) {|y , z| b.call(y , z)}) , s)}
		b.call(@elem , c)
	end
end


