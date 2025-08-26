# This is analyzed ruby code from the Internet



=begin
Это многострочный комментарий
=end
# Константы
PI = 3.14159
$global_var = "Это глобальная переменная"
class ExampleClass
  @@class_var = "Это переменная класса"
  attr_accessor :instance_var
  public
  def initialize(value)
    @instance_var = value # Переменная экземпляра
  end
  def self.class_method
    puts "Это метод класса"
  end
  def instance_method
    puts "Это метод экземпляра"
  end
  def method_with_super
    super if defined?(super)
  end
end
module ExampleModule
  def module_method
    puts "Это метод модуля"
  end
end
class AnotherClass
  include ExampleModule
end
a = 10
b = 5
sum = a + b
difference = a - b
product = a * b
quotient = a / b
remainder = a % b
power = a ** b
logical_and = true && false
logical_or = true || false
bitwise_and = a & b
bitwise_or = a | b
bitwise_xor = a ^ b
bitwise_not = ~a
bitwise_shift_left = a << 1
bitwise_shift_right = a >> 1

if a > b
  puts "a больше b"
elsif a < b
  puts "a меньше b"
else
  puts "a равно b"
end
max = a > b ? a : b

while a > 0
  puts a
  a -= 1
end
until b == 0
  puts b
  b -= 1
end
for i in 1..5
  puts i
end
# Блоки и лямбды (итератор, в к-ый передаётся блок кода)
3.times { puts "Hello" } 
my_lambda = lambda { |x| x * 2 }
puts my_lambda.call(5)
begin
  raise "Ошибка!"
# происходит сохранение объекта исключения в e
rescue => e
  puts "Поймано исключение: #{e.message}"
ensure
  puts "Это выполняется в любом случае"
end
range_inclusive = (1..5)
range_exclusive = (1...5)
symbol = :my_symbol
double_quoted = "Это строка"
single_quoted = 'Это строка'
percent_quoted = %q[Это строка]
array = [1, 2, 3, 4, 5]
# Цепочки методов
result = array.map { |x| x * 2 }.select { |x| x > 5 } 
x = 10
x += 5
x -= 3
x *= 2
x /= 4
condition = true
puts condition ? "True" : "False"
if a > 0 && b > 0
  puts "Оба положительные"
end
def example_method(*args, **kwargs)
  puts "Аргументы: #{args}"
  puts "Ключевые аргументы: #{kwargs}"
end
example_method(1, 2, 3)
integer_literal = 42
float_literal = 3.14
binary_literal = 0b1010
octal_literal = 0o52
hex_literal = 0x2A
def add(x, y)
  x + y
end
puts add(2, 3) 

puts 1 + 2
puts 3 - 1
puts 2 * 3
puts 4 / 2
puts 5 % 2
puts 2 ** 3
puts 1 & 1
puts 1 | 0
puts 1 ^ 0
puts 2 << 1
puts 4 >> 1
puts 1 == 1
puts 1 != 2
puts 1 === 1
puts 1 <=> 2
puts 1 < 2
puts 2 <= 2
puts 3 > 2
puts 3 >= 2
puts defined?(a)
BEGIN
{
  puts "Это выполняется перед всем остальным"
}
END
{
  puts "Это выполняется после всего остального"
}
