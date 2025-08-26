package com.epam.rd.autotasks.meetautocode;

import java.util.Scanner;

public class ElectronicWatch {
    private static final int SEC_IN_MIN = 60;
    private static final int MIN_IN_HOUR = 60;
    private static final int HOURS_IN_DAY = 24;
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        int seconds = scanner.nextInt();

        int watchSec = seconds % SEC_IN_MIN;
        int watchMin = seconds / SEC_IN_MIN;
        int watchHour = watchMin / MIN_IN_HOUR % HOURS_IN_DAY;
        watchMin %= MIN_IN_HOUR;

        System.out.printf("%d:%02d:%02d", watchHour, watchMin, watchSec);

    }
}
