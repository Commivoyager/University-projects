package com.epam.rd.autotasks;

import java.util.Scanner;

public class Average {
    public static void main(String[] args) {
        Scanner scanner = new Scanner(System.in);
        // Use Scanner methods to read input
        int readNum = scanner.nextInt();
        int numSum = 0;
        int numCount = 0;
        while(readNum != 0){
            numSum += readNum;
            numCount++;
            readNum = scanner.nextInt();
        }
        System.out.print(numSum/numCount);
    }

}