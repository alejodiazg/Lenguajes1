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
      if @fst.empty? and @last.empty? then
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
    
  end

  def intersection_RightInfinite other
    puts("In right infinite")
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
    
  end

  def intersection_AllReals other
    self
  end

  def intersection_Empty other
    EMPTY
  end

  def union other
    #chequeo si hay intercepcion
    #raise
    #llamo a la funcion partinente segun el tipo
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
      if @fst.empty? and @last.empty? then
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
    
  end

  def intersection_RightInfinite other
    
  end

  def intersection_LeftInfinite other
    
  end

  def intersection_AllReals other
    self
  end

  def intersection_Empty other
    EMPTY
  end

  def union other
    #chequeo si hay intercepcion
    #raise
    #llamo a la funcion partinente segun el tipo
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
      if @fst.empty? and @last.empty? then
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
    
  end

  def intersection_RightInfinite other
    
  end

  def intersection_LeftInfinite other
    
  end

  def intersection_AllReals other
    self
  end

  def intersection_Empty other
    EMPTY
  end

  def union other
    #chequeo si hay intercepcion
    #raise
    #llamo a la funcion partinente segun el tipo
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