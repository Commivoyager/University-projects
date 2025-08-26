package com.epam.rd.autotasks.sequence;
import java.util.Scanner;

public class FindMaxInSeq {
    public static int max() {

        // Put your code here

        Scanner in = new Scanner(System.in);
        int arrSize = 20;
        int[] arr = new int[arrSize];
        int lastInd = 0;
        int readEl = in.nextInt();
        // int maxEl = readEl;
        while(readEl != 0){
            // if(maxEl < readEl){
            //    maxEl = readEl;
            // }
            if(lastInd == arr.length){
                arrSize += arrSize;
                int[] tempArr = new int[arrSize];
                System.arraycopy(arr, 0, tempArr, 0, lastInd);
                arr = tempArr;
            }
            arr[lastInd++] = readEl;
            readEl = in.nextInt();
        }


        int elInd = 0;
        int maxEl = arr[elInd++];
        int arrLen = arr.length;
        while(elInd < arrLen && arr[elInd] != 0){
            if(maxEl < arr[elInd]){
                maxEl = arr[elInd];
            }
            elInd++;
        }

        System.out.print(maxEl);

        return maxEl;
    }

    public static void main(String[] args) {



        System.out.println("Test your code here!\n");


        // Get a result of your code
       // System.out.print(max(arr));

    }
}
