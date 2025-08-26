package com.epam.rd.autotasks;

import java.util.Arrays;

class CycleSwap {
    static void cycleSwap(int[] array) {

        System.out.println(Arrays.toString(array));
        System.out.println("default");
        int len;
        if(array == null|| array.length == 0)
            return;
        len = array.length;
        //int[] tempArr = new int[len];
        //System.arraycopy(tempArr, 1, array, 0, len-1);
        //tempArr[len-1] = array[0];
        //System.arraycopy(tempArr, 0, array, 0, len);
        int cycleEl = array[len-1];
        System.arraycopy(array, 0, array, 1, len-1);
        array[0] = cycleEl;

        System.out.println(Arrays.toString(array));
    }

    static void cycleSwap(int[] array, int shift) {

        System.out.println(Arrays.toString(array));
        System.out.println(shift);

        int len;
        if(array == null || array.length == 0)
            return;
        len = array.length;
        int[] tempArr = new int[len];
        int cyclePos = len - shift;
        System.arraycopy(array, cyclePos, tempArr, 0, shift);
        System.arraycopy(array, 0, tempArr, shift, cyclePos);
        System.arraycopy(tempArr, 0, array, 0, len);

        System.out.println(Arrays.toString(array));

    }
}
