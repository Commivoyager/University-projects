package com.epam.rd.autotasks.arrays;

import java.util.Arrays;

public class SumOfPrevious {

    public static void main(String[] args) {
        int[] array = new int[]{1, -1, 0, 4, 6, 10, 15, 25};

        System.out.println(Arrays.toString(getSumCheckArray(array)));
    }

    public static boolean[] getSumCheckArray(int[] array){

        //put your code here
        boolean[] resArr = new boolean[array.length];
        for(int i = 2; i < array.length; i++){
            resArr[i] = array[i] == array[i-1]+array[i-2];
        }
        return resArr;
        //throw new UnsupportedOperationException();
    }
}
