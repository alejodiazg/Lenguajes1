require 'singleton'

#Clase que sirve para representar la noción de un intervalo de
#números flotantes.
class Interval
  attr_accessor :fst, :last, :fst_i, :last_i

  def initialize fst, last, fst_i, last_i
    @fst   = fst
    @last  = last
    @fst_i = fst_i
    @lasti = last_i
  end

end

class Literal < Interval

  def initialize first, fst_include, last1, last_include
    @fst    = first
    @last   = last1
    @fst_i  = fst_include
    @last_i = last_include
  end

  def to_s
      str = " "
      if not (@fst and @last) then
        str = str + '∅'
      else
        if @fst_i then
          str = str + '['
        else
          str = str + '('
        end
        str = str + @fst.to_s + ',' + @last.to_s
        if @last_i
          str = str + ']'
        else
          str = str + ')'
        end
      end
      str
  end

  def intersection other
    #llamo al metodo segun el tipo
    method_name = "intersection_#{other.class}"
    self.send method_name , other
  end

  def intersection_Literal other
    if(other.fst <= @fst && @fst <= other.last)
      #quiere decir que li limite izquiedo esta entre los limites del other
      limite_izq = @fst
      fst_include = @fst_include

      if other.fst == @fst #si mi limite es igual al primero del otro
        fst_include =  other.fst_i && @fst_i
      end
      if other.last == @fst #si el inicial es igual al final de other
        fst_include =  other.last_i && @fst_i 
        if not fst_include #quire decir que ambos eran abierto por lo que no coinciden
          return EMPTY
        end
      end

      limite_der = @last
      last_include =  @last_i

      if @last = other.last
        last_include = @other.last_i && @last_i
      else
        limite_der = [@last , other.last].min
        if(limite_der == @other.last)
          last_include = other.last_i
        end
      end

      return Literal.new(limite_izq , fst_include , limite_der , last_include)
    end

    if (other.fst <= @last && @last <= other.last)
      #si no se cumple esto entonces 
      return other.intersection_Literal(self)
    end

    EMPTY
  end

  def intersection_RightInfinite other
    
    if @last > other.fst
      #ya se que el limite derecho va a ser m last
      #tengo que ver cual es el maximo entre los dos limites izquierdos

      fst_include = false
      maximo = [other.fst , @fst].max
      if(other.fst = maximo)
        fst_include = other.fst == @fst ? other.fst_i && @fst_i : other.fst_i
      else
        fst_include = @fst_i
      end

      #creo el nuevo literal que voy a devolver
      return Literal.new(maximo , fst_include , @last , @last_i)

    elsif @last == other.fst
      #revisar si ambos son cerrados
      if(@last_i && other.fst_i)

        fst_include = false
        maximo = [other.fst , @fst].max
        if(other.fst = maximo)
          fst_include = other.fst == @fst ? other.fst_i && @fst_i : other.fst_i
        else
          fst_include = @fst_i
        end

        #creo el nuevo literal que voy a devolver
        return Literal.new(maximo , fst_include , @last , @last_i)
      end
    end

    EMPTY
  end

  def intersection_LeftInfinite other
    if @fst < other.last
      #mantengo mi limite izquierdo
      last_include = false
      minimo = [other.last , @last].min
      if(other.last = minimo)
        last_include = other.last == @last ? other.last_i && @last_i : other.last_i
      else
        last_include = @last_i
      end
      return Literal.new(@fst , @fst_i , minimo , last_include)

    elsif @fst == other.last
      #reviso si ambos son intervalos cerrados
      if(@fst_i && other.last_i)
        #si ambos son cerrados entonces tengo que la interseccion es el intervalo a x a x cerrado
        return Literal.new(@fst , true , @fst , true)
      end
    end
    EMPTY
  end

  def intersection_AllReals other
    self
  end

  def intersection_Empty other
    EMPTY
  end

  def union other
    if intersection(other) == EMPTY
      raise 'No existe una interseccion entre los dos rangos'
    end
    method_name = "union_#{other.class}"
    self.send method_name , other
  end

  def union_Literal other
    limite_izq = @fst
    first_include = @fst_i

    limite_der = @last
    last_include = @last_i

    if(other.fst < limite_izq)
      limite_izq = other.fst
      first_include = other.fst_i
    elsif other.fst == limite_izq
      first_include = first_include || other.fst_i
    end

    if(other.last > limite_der)
      limite_der = other.last
      last_include = other.last_i
    elsif other.last == limite_der
      last_include = other.last_i || @last_i
    end

    Literal.new(limite_izq , first_include , limite_der , last_include)      
  end

  def union_RightInfinite other
    limite_izq = @fst
    first_include = @fst_i

    if(other.fst < limite_izq)
      limite_izq = other.fst
      first_include = other.fst_i
    elsif other.fst == limite_izq
      first_include = first_include || other.fst_i
    end

    RightInfinite.new(limite_izq , first_include)
  end

  def union_LeftInfinite other
    limite_der = @last
    last_include = @last_i

    if(other.last > limite_der)
      limite_der = other.last
      last_include = other.last_i
    elsif other.last == limite_der
      last_include = other.last_i || @last_i
    end

    LeftInfinite.new(limite_der , last_include)   
  end

  def union_AllReals other
    other
  end

  def union_Empty other
    self
  end
end

class RightInfinite < Interval

  def initialize first, fst_include
    @fst    = first
    @last   = "infinite"
    @fst_i  = fst_include
    @last_i = false
  end

  def to_s
    str = " "
      if not (@fst) then
        str = str + '∅'
      else
        if @fst_i then
          str = str + '['
        else
          str = str + '('
        end
        str = str + @fst.to_s + ',' + @last.to_s
        if @last
          str = str + '+∞)'
        else
          false
        end
      end
      str
  end

  def intersection other
    #llamo al metodo segun el tipo
    method_name = "intersection_#{other.class}"
    self.send method_name , other
  end

  def intersection_Literal other
    other.intersection_RightInfinite(self)
  end

  def intersection_RightInfinite other
    first_include = @fst_i
    limite_izq = @fst
    if @fst == other.fst
      first_include = @fst_i && other.fst_i
    elsif @fst < other.fst
      limite_izq = other.fst
      first_include = other.fst_i
    end

    RightInfinite.new(limite_izq , first_include)
  end

  def intersection_LeftInfinite other
    limite_izq = other.last
    first_include = other.fst_i

    limite_der = @fst
    last_include = @last_i

    if(other.last == @fst)
      if not (first_include && last_include)
        return EMPTY
      end
    elsif other.last < @fst
      return EMPTY      
    end
    
    Literal.new(limite_der , first_include , limite_izq , last_include)
  end

  def intersection_AllReals other
    self
  end

  def intersection_Empty other
    EMPTY
  end

  def union other
    if intersection(other) == EMPTY
      raise 'No existe una interseccion entre los dos rangos'
    end
    method_name = "union_#{other.class}"
    self.send method_name , other
  end

  def union_Literal other
    other.union_RightInfinite(self)
  end

  def union_RightInfinite other
    limite_izq = @fst
    first_include = @fst_i

    if(other.fst < limite_izq)
      limite_izq = other.fst
      first_include = other.fst_i
    elsif other.fst == limite_izq
      first_include = first_include || other.fst_i
    end

    RightInfinite.new(limite_izq , first_include)    
  end

  def union_LeftInfinite other
    ALLREALS
  end

  def union_AllReals other
    other
  end

  def union_Empty other
    self
  end
end 

class LeftInfinite < Interval

  def initialize last1, last_include
    @fst    = "infinite"
    @last   = last1
    @fst_i  = false
    @last_i = last_include
  end

  def to_s
    str = " "
      if not(@fst and @last) then
        str = str + '∅'
      else
        if @fst then
          str = str + '(-∞'
        else
          false
        end
        str = str + @fst.to_s + ',' + @last.to_s
        if @last_i
          str = str + ']'
        else
          str = str + ')'
        end
      end
      str
  end

  def intersection other
    #llamo al metodo segun el tipo
    method_name = "intersection_#{other.class}"
    self.send method_name , other
  end

  def intersection_Literal other
    other.intersection_LeftInfinite(self)
  end

  def intersection_RightInfinite other
    other.intersection_LeftInfinite(self)
  end

  def intersection_LeftInfinite other
    last_include = @last_i
    limite_der = @last
    if @last == other.last
      last_include = @last_i && other.last_i
    elsif @last > other.last
      limite_der= other.last
      last_include = other.last_i
    end

    LeftInfinite.new(limite_der , last_include)    
  end

  def intersection_AllReals other
    self
  end

  def intersection_Empty other
    EMPTY
  end

  def union other
    method_name = "union_#{other.class}"
    self.send method_name , other
  end

  def union_Literal other
    if intersection(other) == EMPTY
      raise 'No existe una interseccion entre los dos rangos'
    end
  end

  def union_RightInfinite other
    ALLREALS
  end

  def union_LeftInfinite other

    limite_der = @last
    last_include = @last_i

    if(other.last > limite_der)
      limite_der = other.last
      last_include = other.last_i
    elsif other.last == limite_der
      last_include = other.last_i || @last_i
    end

    LeftInfinite.new(limite_der , last_include) 

  end

  def union_AllReals other
    other
  end

  def union_Empty other
    self
  end
end 

class AllReals < Interval
  include Singleton
  def initialize
    @fst    = "infinite"
    @last   = "infinite"
    @fst_i  = false
    @last_i = false
  end

  def to_s
    str = '(-∞,+∞)'
    str
  end

  #deberia devolver este (el singleton)
  def union other
    ALLREALS
  end

  def intersection other
    other
  end

end 

class Empty < Interval
  include Singleton
  def initialize
    @fst    = "none"
    @last   = "none"
    @fst_i  = false
    @last_i = false
  end

  def to_s
    str = "∅"
      str
  end

  def union other
    other
  end

  def intersection other
    EMPTY
  end
end 

#SINGLETONS
EMPTY = Empty.instance
ALLREALS = AllReals.instance


#AQUI VIENE LA PARTE DE INTERACCION CON EL USUARIO
class Values
  attr_accessor :name, :interval
  def initialize name, interval
    @name = name
    @interval = interval
  end
end

class Console

  def eval string
    #calls by precedence
    result = split_union(string)
    
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
    instance_variable_set("@#{name}", value)
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
      first.interval = first.interval.union(last.interval)
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
      first.interval = first.interval.intersection(last.interval)
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
      
      #DESCOMENTAR 
      last = RightInfinite.new(last.to_i , false)
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
      
      #DESCOMENTAR 
      last = RightInfinite.new(last.to_i , true)
      return Values.new(first , last)
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
      
      #DESCOMENTAR 
      last = LeftInfinite.new(last.to_i , false)
      return Values.new(first , last)
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
      
      #DESCOMENTAR 
      last = LeftInfinite.new(last.to_i , true)
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
              puts(result.name + " in" + result.interval.to_s) #faltaria imprimir la representacion en strings del intervalo
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

          input = input.delete("\n")
          result = split(input , '|')
          if not result.nil?
            first = stripSpaces(result.first)
            second = stripSpaces(result.last)
            fst_int = instance_variable_get("@#{first}")
            scd_int = instance_variable_get("@#{second}")

            if(fst_int && scd_int)
              puts("hago la union entre dos")
              puts fst_int.union(scd_int).to_s
            else
              puts("una de las variables no fue creada previamente")
            end 
            
          next
        end

        input = input.delete("\n")
          result = split(input , '&')
          if not result.nil?
            first = stripSpaces(result.first)
            second = stripSpaces(result.last)
            fst_int = instance_variable_get("@#{first}")
            scd_int = instance_variable_get("@#{second}")
            
            if(fst_int && scd_int)
              puts("hago la interseccion entre dos")
              puts fst_int.intersection(scd_int).to_s
            else
              puts("una de las variables no fue creada previamente")
            end 
          next
        end

        puts "Error leyendo la linea"
        end

    rescue => err
        puts "Exception: #{err}"
        err
    end
  end
end

console = Console.new()
console.main()