## Custom Attribute & Generic Dynamic List

- Custom attribute ExportClass (applicable only to classes) and implements a tool that loads a .NET assembly (EXE or DLL) from a command-line argument, then prints the full names of all public types marked with [ExportClass]

- Implementation of a generic class DynamicList<T> using a raw array to simulate a dynamic list. Includes properties Count, Items, and methods Add, Remove, RemoveAt, Clear, plus support for IEnumerable<T>. A simple usage example is provided

### Task:

Задача 8.
Создать на языке C# пользовательский атрибут с именем
ExportClass, применимый только к классам, и реализовать
консольную программу, которая:
- принимает в параметре командной строки путь к сборке .NET
(EXE- или DLL-файлу);
- загружает указанную сборку в память;
- выводит на экран полные имена всех public-типов данных этой
сборки, помеченные атрибутом ExportClass.

Задача 9.
Создать на языке C# обобщенный (generic-) класс DynamicList<T>,
который:
- реализует динамический массив с помощью обычного массива
T[];
- имеет свойство Count, показывающее количество элементов;
- имеет свойство Items для доступа к элементам по индексу;
- имеет методы Add, Remove, RemoveAt, Clear для соответственно
добавления, удаления, удаления по индексу и удаления всех
элементов;
- реализует интерфейс IEnumerable<T>.
Реализовать простейший пример использования класса
DynamicList<T> на языке C#.