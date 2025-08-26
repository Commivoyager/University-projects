package com.epam.rd.autotasks.snail;

import java.util.Scanner;
public class Snail
{
    public static void main(String[] args)
    {
        //Write a program that reads a,b and h (line by lyne in this order) and prints
        //the number of days for which the snail reach the top of the tree.
        //a - feet that snail travels up each day, b - feet that slides down each night, h - height of the tree
        Scanner in = new Scanner(System.in);
        int a = in.nextInt();
        int b = in.nextInt();
        int h = in.nextInt();
        if(a<=b){
            if(a >= h){
                System.out.print(1);
            }
            else{
            System.out.print("Impossible");
            }
        }
        else{
            int dayPath = a-b;
            int dayCount = (h - a) / dayPath;
            int wayRest = h % dayPath + 1;
            if(wayRest > 0){
                dayCount++;
            }
            System.out.print(dayCount);
        }
    }
}
