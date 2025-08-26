### Demonstrating of key concepts in .NET development
- Reflection-based inspection of .NET assemblies, including loading EXE/DLL files and listing public types sorted by namespace and name.
- A buffered logging system (`LogBuffer`) that asynchronously writes batches of messages to a file based on size or time thresholds.
- A static method `Parallel.WaitAll` that executes multiple delegates concurrently using the thread pool and waits for all to complete.

### Task
Задача 5.
Реализовать консольную программу на языке C#, которая:
- принимает в параметре командной строки путь к сборке .NET
(EXE- или DLL-файлу);
- загружает указанную сборку в память;
- выводит на экран полные имена всех public-типов данных этой
сборки, упорядоченные по пространству имен (namespace) и по
имени.

Задача 6.
Создать класс на языке C#, который:
Создать класс LogBuffer, который:
- представляет собой журнал строковых сообщений;
- предоставляет метод public void Add(string item);
- буферизирует добавляемые одиночные сообщения и записывает
их пачками в конец текстового файла на диске;
- периодически выполняет запись накопленных сообщений, когда
их количество достигает заданного предела;
- периодически выполняет запись накопленных сообщений по
истечение заданного интервала времени (вне зависимости от
наполнения буфера);
- выполняет запись накопленных сообщений асинхронно с
добавлением сообщений в буфер;

Задача 7.
Создать на языке C# статический метод класса Parallel.WaitAll,
который:
- принимает в параметрах массив делегатов;
- выполняет все указанные делегаты параллельно с помощью пула
потоков;
- дожидается окончания выполнения всех делегатов.
Реализовать простейший пример использования метода
Parallel.WaitAll.