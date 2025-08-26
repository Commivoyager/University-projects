package com.epam.rd.autotasks.meetanagent;

import java.util.Scanner;

public class MeetAnAgent {
    final static int PASSWORD = 133976; //You can change pass, but don't change the type

    public static void main(String[] args) {
        //put you code here
        Scanner in = new Scanner(System.in);
        //System.out.print("Enter number: ");
        int inpNum = in.nextInt();
        //System.out.println();
        System.out.print(inpNum == PASSWORD ? "\nHello, Agent" : "\nAccess denied");
        in.close();
    }
}
