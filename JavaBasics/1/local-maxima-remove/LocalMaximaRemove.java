package com.epam.rd.autotasks.arrays;

import java.util.Arrays;

public class LocalMaximaRemove {

    public static void main(String[] args) {
        int[] array = new int[]{18, 1, 3, 6, 7, -5};

        System.out.println(Arrays.toString(removeLocalMaxima(array)));
    }

    public static int[] removeLocalMaxima(int[] array){
        //put your code here
        int sourceLen = array.length;
        int[] tempArr = new int[sourceLen];
        int resInd = 0;
        int checkInd = 0;
        if(array[checkInd] <= array[checkInd+1]){
            tempArr[resInd++] = array[checkInd];
            checkInd += 1;
        } else{
            tempArr[resInd++] = array[checkInd + 1];
            checkInd += 2;
        }
        while(checkInd < sourceLen-1){
            if(array[checkInd]<=array[checkInd-1] || array[checkInd] <= array[checkInd+1]){
                tempArr[resInd++] = array[checkInd];
                checkInd += 1;
            } else{
                tempArr[resInd++] = array[checkInd + 1];
                checkInd += 2;
            }
        }
        if(checkInd < sourceLen && array[sourceLen-1]<=array[sourceLen-2]){
            tempArr[resInd++] = array[sourceLen-1];
        }

        return Arrays.copyOf(tempArr, resInd);
//        throw new UnsupportedOperationException();
    }
}
