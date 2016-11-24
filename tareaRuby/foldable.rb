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
		puts "Aqui"
		
		#puts other
		puts b
		puts "End Aqui"
		
		other = @children.foldr(e) {|x , s| b.call( (x.foldr(e) &b) , s)}
		b.call(@elem , other) #@children.foldr(0) {|x , s| x.elem + s})
	end
end
