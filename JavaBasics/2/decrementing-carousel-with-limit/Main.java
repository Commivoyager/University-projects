package com.epam.rd.autotasks;

public class Main {
    public static void main(String[] args) {
        // Создаем карусель с определенной вместимостью
        DecrementingCarouselWithLimitedRun carousel = new DecrementingCarouselWithLimitedRun(5, 4);

        // Добавляем несколько элементов в карусель
        System.out.println("Adding 5 elements: ");
        System.out.println(carousel.addElement(3)); // true
        System.out.println(carousel.addElement(5)); // true
        System.out.println(carousel.addElement(2)); // true
        System.out.println(carousel.addElement(8)); // true
        System.out.println(carousel.addElement(1)); // true

        // Попробуем добавить элемент после того, как заполнили карусель
        System.out.println(carousel.addElement(6)); // false (карусель полная)

        // Начинаем выполнение карусели
        CarouselLimitedRun run = (CarouselLimitedRun)carousel.run();

        if (run != null) {
            System.out.println("Carousel Run started:");
            // Пока карусель не завершена, печатаем каждый элемент
            while (!run.isFinished()) {
                System.out.println(run.next()); // Выводим текущий элемент
            }
        }

        // Попробуем запустить карусель повторно, что должно вернуть null
        System.out.println("Trying to run carousel again: ");
        System.out.println(carousel.run()); // null, так как карусель уже в режиме выполнения
    }
}
