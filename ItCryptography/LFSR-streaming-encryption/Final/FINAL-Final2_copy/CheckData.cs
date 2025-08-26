namespace WinFormsApp1
{
    internal static class CheckData
    {
        static int regLen = 0;
        public static bool CheckP(string? str, ref List<int> resLst, ref int len)
        {
            List<int> lst = new List<int>();
            Stack<char> st = new Stack<char>();

            if (str == null || str.Length == 0)
            {
                return false;
            }
            byte[,] StateArr = {
                { 0, 0, 0, 0, 0 },
                { 2, 3, 0, 0, 0 },
                { 2, 3, 0, 6, 4 },
                { 0, 0, 5, 6, 0 },
                { 0, 3, 0, 0, 0 },
                { 7, 0, 0, 0, 0 },
                { 2, 3, 0, 0, 0 },
                { 7, 0, 0, 6, 0 } 
            };
            int i = 0;
            byte state = 1;
            char currC = '\0';
            char prevC = '\0';
            while (i < str.Length)
            {
                currC = str[i++];
                if (currC >= '0' && currC <= '9')
                {
                    state = StateArr[state, 0];
                    if (prevC == '^')
                    {
                        st.Push(currC);
                    }
                }
                else
                {
                    prevC = currC;
                    if (currC == 'x')
                    {
                        state = StateArr[state, 1];
                        if (i < str.Length)
                        {
                            if (str[i] != '^')
                            {
                                st.Push('^');
                                st.Push('1');
                            }
                        }
                        else
                        {
                            st.Push('^');
                            st.Push('1');
                        }
                    }
                    else if (currC == '^')
                    {
                        state = StateArr[state, 2];
                        st.Push(currC);
                    }
                    else if (currC == '+' || currC == '-')
                        state = StateArr[state, 3];
                    else if (currC == '*')
                        state = StateArr[state, 4];
                    else
                        return false;
                }
            }
            if (state == 2 || state == 3 || state == 7)
            {
                int j = st.Count;
                while (j > 0)
                {
                    int temp = 0;
                    int count = 1;

                    while ((currC = st.Pop()) != '^')
                    {
                        temp += (int)(currC - '0') * count;
                        count *= 10;
                    }
                    j = st.Count;
                    lst.Add(temp);
                }
                resLst = new List<int>();
                for (int k = 1; k < lst.Count; k++)
                {
                    if (lst[k - 1] >= lst[k])
                    {
                        resLst.Clear();
                        return false;
                    }
                    resLst.Add(lst[k - 1]);
                }
                resLst.Add(lst[lst.Count - 1]);
                len = lst[lst.Count - 1];
                return true;
            }
            return false;
        }

        public static bool checkReg(string ? str, int len)
        {
            if (str == null || str.Length == 0 || str.Length != len)
                return false;
            for(int i = 0; i < str.Length; i++)
            {
                if (str[i] != '0' && str[i] != '1')
                    return false;
            }
            return true;
        }
    }
}
