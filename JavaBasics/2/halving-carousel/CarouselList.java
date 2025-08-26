package com.epam.rd.autotasks;

public class CarouselList {
    private static class Node{
        int val;
        Node next;
        public Node(int v){ ///
            val = v;
            next = null;
        }
    }

    //private Node head;
    private Node currNode;

    public CarouselList(){
        currNode = null;
    }

    public boolean isNtEmpty(){
        return currNode != null;
    }

    public int getVal(){
        if(currNode != null){
            return currNode.val;
        }else{
            return -1;
        }
    }

    public void replaceVal(int newVal){
        currNode.val = newVal;
    }

    /*public void addToCurr(int addVal){
        currNode.val += addVal;
    }*/

    public void moveNext(){
        if(currNode != null){
            currNode = currNode.next;
        }
    }
    public void addEl(int val){
        if(currNode != null){
            Node nextNode = new Node(val);
            nextNode.next = currNode.next;
            currNode.next = nextNode;
            currNode = currNode.next;
        }else{
            currNode = new Node(val);
            currNode.next = currNode;
        }
    }

    public void removeEl(){
        if(currNode != currNode.next){
            Node prev = currNode.next;
            while(prev.next != currNode){
                prev = prev.next;
            }
            prev.next = currNode.next;
            currNode = prev.next;
//            currNode.next = currNode.next.next;
        }else{
            currNode = null;
        }
    }

    /*public void removeNextEl(){
        if(currNode != currNode.next){
            currNode.next = currNode.next.next;
        }else{
            currNode = null;
        }
    }*/


}
