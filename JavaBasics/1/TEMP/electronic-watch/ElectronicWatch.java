package com.epam.rd.autotasks.meetautocode;

import java.util.Scanner;

public class ElectronicWatch {
    private static final int DIV_COUNT = 60;
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        int seconds = scanner.nextInt();

        int watchSec = seconds % DIV_COUNT;
        int watchMin = seconds / DIV_COUNT;
        int watchHour = watchMin / DIV_COUNT;
        watchMin %= DIV_COUNT;

        System.out.printf("%d:%02d:%02d", watchHour, watchMin, watchSec);

    }
}
