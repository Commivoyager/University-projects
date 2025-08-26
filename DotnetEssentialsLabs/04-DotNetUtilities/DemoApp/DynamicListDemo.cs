using DynamicCollections;
namespace DemoApp
{
    internal static class DynamicListDemo
    {
        public static void DemoFunc()
        {
            // Создаём список строк
            var list = new DynamicList<string>();

            Console.WriteLine("Добавляем элементы...");
            list.Add("Alice");
            list.Add("Bob");
            list.Add("Charlie");
            list.Add("Diana");

            // Проверяем Count и индексатор
            Console.WriteLine($"Count после добавления: {list.Count}");
            Console.WriteLine($"Элемент с индексом 2: {list.Items[2]}"); // Charlie
            list.Items[2] = "Mike";
            Console.WriteLine($"Элемент с индексом 2 после изменение на значение Mike: {list.Items[2]}"); // Charlie


            // Перебираем через foreach (IEnumerable<T>)
            Console.WriteLine("Все элементы списка:");
            foreach (var name in list)
            {
                Console.WriteLine($" - {name}");
            }

            // Удаляем элемент по значению
            Console.WriteLine("Удаляем 'Bob'...");
            bool removed = list.Remove("Bob");
            Console.WriteLine($"Удаление прошло успешно: {removed}");
            Console.WriteLine($"Count после удаления: {list.Count}");

            // Удаляем элемент по индексу
            Console.WriteLine("Удаляем элемент с индексом 1...");
            list.RemoveAt(1); // Charlie (Mike)
            Console.WriteLine($"Count после RemoveAt: {list.Count}");

            // Снова выводим текущие элементы
            Console.WriteLine("Текущие элементы списка:");
            for (int i = 0; i < list.Count; i++)
            {
                Console.WriteLine($"[{i}] = {list.Items[i]}");
            }

            // Очищаем
            Console.WriteLine("Очищаем массив...");
            list.Clear();
            Console.WriteLine($"Count после Clear: {list.Count}");




            // Массив чисел
            // Создаём список строк
            var listInt = new DynamicList<int>();
            Console.WriteLine("\n\nСоздаём новый массив с целочисленными значениями");

            Console.WriteLine("Добавляем элементы...");
            for(int i = 0; i < 500; i++)
            {
                listInt.Add(i);
            }

            // Проверяем Count и индексатор
            Console.WriteLine($"Count после добавления: {listInt.Count}");
            Console.WriteLine($"Элемент с индексом 50: {listInt.Items[50]}"); // 50
            listInt.Items[100] = 0;
            Console.WriteLine($"Элемент с индексом 100 после изменение на значение 0: {listInt.Items[100]}"); // 0


            // Удаляем элемент по значению
            Console.WriteLine("Удаляем число 200...");
            bool removedInt = listInt.Remove(200);
            Console.WriteLine($"Удаление прошло успешно: {removedInt}");
            Console.WriteLine($"Count после удаления: {listInt.Count}");

            // Удаляем элемент по индексу
            Console.WriteLine("Удаляем элемент с индексом 300...");
            listInt.RemoveAt(300);
            Console.WriteLine($"Count после RemoveAt: {listInt.Count}");

            // Удаляем 450 последних элементов
            Console.WriteLine("Удаляем 450 последних элементов...");
            for (int i = 0; i < 450; i++)
            {
                listInt.Remove();
            }

            // Перебираем через foreach (IEnumerable<T>)
            Console.WriteLine("Все элементы списка:");
            foreach (var num in listInt)
            {
                Console.WriteLine(num);
            }

            // Очищаем
            Console.WriteLine("Очищаем массив...");
            listInt.Clear();
            Console.WriteLine($"Count после Clear: {listInt.Count}");


            // Перебираем через foreach пустой массив (IEnumerable<T>)
            Console.WriteLine("Все элементы списка:");
            foreach (var num in listInt)
            {
                Console.WriteLine(num);
            }

            listInt.Add(123);
            Console.WriteLine($"Count после добавления значения в пустой массив: {listInt.Count}");
            Console.WriteLine("Все элементы списка:");
            foreach (var num in listInt)
            {
                Console.WriteLine(num);
            }
        }
    }
}
