class Values
	attr_accessor :name, :interval
	def initialize name, interval
		@name = name
		@interval = interval
	end
end

class Console
	def initialize
		@precedence = [] #ver si logro arreglar esto para limpiar el codigo de eval
	end

	def eval string
		#calls by precedence
		result = split_union(string)
		#ver si puedo cambiar esto a un ciclo que ejecute por precedencia
		if not result.nil?
			return result
		end

		result = split_intersect(string)
		if not result.nil?
			return result
		end

		result = split_gt (string)
		if not result.nil?
			return result
		end

		result = split_get(string)
		if not result.nil?
			return result
		end

		result = split_lt(string)
		if not result.nil?
			return result
		end

		result = split_let(string)
		if not result.nil?
			return result
		end

	end

	def stripSpaces string
		string.gsub(/\s+/, "")
	end

	def setVar name , value
		#if instance_variable_get("@#{name}")
		#	puts "variable @#{name} ya existe"
		#else
		puts "variable @#{name} creada"
		instance_variable_set("@#{name}", value) #aqui creo el tipo de variable
		#end
	end

	#split deberia devolver el nombre de la variable que se crea en la linea si no sirve devuelve nulo
	def split string , symbol
		result = string.partition(symbol)
		if result.first == string
			return nil
		else
			return result
		end
	end

	def split_union string
		result = split(string , '|')
		if(result)
			#print(result.first)
			#print(" OR ")
			#puts(result.last)
			first = eval(result.first) 
			last = eval(result.last)
			if not (first.name == last.name)
				return  nil
			end
			#first = first.interval.union(last.interval)
			return first
		else
			return nil
		end
	end

	def split_intersect string
		result = split(string , '&')
		if(result)
			#print(result.first)
			#print(" AND ")
			#puts(result.last)
			first = eval(result.first) 
			last = eval(result.last)
			if not (first.name == last.name)
				return  nil
			end
			#first = first.interval.interssection(last.interval)
			return first
		else
			return nil
		end
	end

	#greater than
	def split_gt string
		result = split(string , '>')
		if(result)
			#print(result.first)
			#print(" GREATER THAN ")
			#puts(result.last)
			first = stripSpaces(result.first)
			last = stripSpaces(result.last)
			
			return Values.new(first , last) #cambair este last por la creacion de la isntacion de la clase pertinente
		else
			return nil
		end
	end

	#greatet or equal than
	def split_get string
		result = split(string , '>=')	
		if(result)
			#print(result.first)
			#print(" GREATER OR EQUAL ")
			#puts(result.last)
			first = stripSpaces(result.first)
			last = stripSpaces(result.last)
			
			return Values.new(first , last) #cambair este last por la creacion de la isntacion de la clase pertinente
		else
			return nil
		end		
	end

	#lower than
	def split_lt string
		result = split(string , '<')
		if(result)
			#print(result.first)
			#print(" LOWER THAN ")
			#puts(result.last)
			first = stripSpaces(result.first)
			last = stripSpaces(result.last)
			
			return Values.new(first , last) #cambair este last por la creacion de la isntacion de la clase pertinente
		else
			return nil
		end		
	end

	#lower or equal than
	def split_let string
		result = split(string , '<=')
		if(result)
			#print(result.first)
			#print(" LOWER equal THAN ")
			#puts(result.last)
			first = stripSpaces(result.first)
			last = stripSpacesr(result.last)
			
			return Values.new(first , last) #cambair este last por la creacion de la isntacion de la clase pertinente
		else
			return nil
		end				
	end

	def main
		file_name = './test.txt'
		counter = 0
		begin
	    	file = File.new(file_name, "r")
		    while (line = file.gets)
		    	#borrar esto luego
		        puts "#{counter}: #{line}"
		        counter = counter + 1
		        #verdadero codigo
		        result = eval(line)
		        if(result.nil?)
		        	puts("error parsing the line")
		        else
		        	setVar(result.name , result.interval)
		        	puts(result.name + " in") #faltaria imprimir la representacion en strings del intervalo
		        end
		    end
		    file.close

		    #Aqui va el ciclo de iteraccion con el usuario
		    while true
		    	puts "Su expression (exit para salir del programa)"
		    	input = gets
		    	if input.eql?("exit\n")
		    		puts "Cerrando el programa"
		    		exit
		    	end
		    end

		rescue => err
		    puts "Exception: #{err}"
		    err
		end
	end
end

console = Console.new()
console.main()