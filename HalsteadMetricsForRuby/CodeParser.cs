using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace Metr2
{
    internal static class CodeParser
    {
        public static string tokensPath = @"..\..\..\Files\tokens";
        const string codePath = @"..\..\..\Files";
        static string[]? tokens;
        static int strCount;
        static string Messg = "";

        const string oprnd = "Operand: ";
        const string oprtr = "Operator: ";
        const string declrtn = "Declaration: ";

        public static (List<CodeToken>?, List<CodeToken>?) ParseCode()
        {
            try
            {
                tokens = File.ReadAllLines(tokensPath);
            }
            catch (Exception ex)
            {
                Messg = ex.Message;
                return (null, null);
            }
            List<CodeToken>? AllTokens = null;
            List<CodeToken>? oprnds = null;
            List<CodeToken>? oprtrs = null;
            List<string> dclrtns = new();
            if (tokens != null)
            {
                strCount = tokens.Length;
                AllTokens = new(strCount / 2);

                for (int i = 0; i < strCount; i++)
                {
                    string curr = tokens[i];
                    (int outp, int nxt) inds = CheckNext(i);
                    switch (curr)
                    {
                        case oprnd:
                            AllTokens.Add(new(tokens[inds.outp], false));
                            break;
                        case oprtr:
                            AllTokens.Add(new(tokens[inds.outp], true));
                            break;
                        case declrtn:
                            dclrtns.Add(tokens[inds.outp]);
                            break;
                        default:
                            break;

                    }
                }


                foreach (string str in dclrtns)
                {
                    Console.WriteLine("Declaration: " + str);
                }

                int tokCount = AllTokens.Count;
                for (int i = 0; i < dclrtns.Count; i++)
                {
                    string curr = dclrtns[i];
                    if (curr.Substring(0, 3) != "def")
                    {
                        dclrtns.RemoveAt(i--);
                    }
                    else
                    {
                        int j = curr.Length - 1;
                        int nameLen = 0;
                        if (curr[j] == ')')
                        {
                            while (j > 0 && curr[j--] != '(') ;
                        }
                        while (j >= 0 && curr[j] != ' ' && curr[j] != '.') { j--; nameLen++; }
                        j++;
                        dclrtns[i] = curr.Substring(j, nameLen);
                    }
                }

                for (int i = 0; i < tokCount; i++)
                {
                    string currToken = AllTokens[i].Value;
                    int tokenLen = currToken.Length;
                    if (tokenLen > 1 && currToken[tokenLen - 1] == '(')
                    {
                        AllTokens[i].Value = currToken.Substring(0, tokenLen - 1);
                        currToken = AllTokens[i].Value;
                    }
                    if (AllTokens[i].IsOprtr)
                    {
                        for (int q = 0; q < currToken.Length; q++)
                        {
                            if (currToken[q] == ' ')
                            {
                                currToken = currToken.Substring(0, q);
                                AllTokens[i].Value = currToken;
                            }
                        }
                    }


                    for (int j = 0; j < dclrtns.Count; j++)
                    {
                        if (currToken == dclrtns[j])
                        {
                            AllTokens[i].IsOprtr = true;
                            int k = i - 1;
                            while (k >= 0)
                            {

                                if (AllTokens[k].IsOprtr)
                                {
                                    if (AllTokens[k].Value == ".")
                                    {
                                        k--;
                                    }
                                    else
                                    {
                                        AllTokens[i].IsOprtr = false;
                                        break;
                                    }

                                }
                                else if (AllTokens[k].Value == "defined?")
                                {
                                    AllTokens[i].IsOprtr = false;
                                    break;
                                }
                                else if (k == i - 1)
                                {
                                    break;
                                }
                                else { k--; }

                            }
                        }
                    }
                }
                oprnds = new List<CodeToken>(tokCount / 2);
                oprtrs = new List<CodeToken>(tokCount / 2);
                if (AllTokens != null)
                {
                    foreach (CodeToken token in AllTokens)
                    {
                        if (token.IsOprtr)
                        {
                            oprtrs.Add(token);
                        }
                        else
                        {
                            oprnds.Add(token);
                        }
                    }


                    for (int i = 0; i < oprtrs.Count; i++)
                    {
                        for (int j = i + 1; j < oprtrs.Count; j++)
                        {
                            if (oprtrs[i].Value == oprtrs[j].Value)
                            {
                                oprtrs[i].incCount();
                                oprtrs.RemoveAt(j--);
                            }
                        }
                    }

                    for (int i = 0; i < oprnds.Count; i++)
                    {
                        for (int j = i + 1; j < oprnds.Count; j++)
                        {
                            if (oprnds[i].Value == oprnds[j].Value)
                            {
                                oprnds[i].incCount();
                                oprnds.RemoveAt(j--);
                            }
                        }
                    }

                    //foreach (CodeToken token in oprtrs)
                    //{
                    //    Console.WriteLine(token.Value + ";\t" + token.Count);
                    //}
                    //foreach (CodeToken token in oprnds)
                    //{
                    //    Console.WriteLine(token.Value + ";\t" + token.Count);
                    //}
                }

            }
            return (oprnds, oprtrs);
        }

        static (int toOutp, int toNext) CheckNext(int currInd)
        {
            int ind = currInd++;
            while (++ind < strCount)
            {
                string nextStr = tokens[ind];
                switch (nextStr)
                {
                    case oprnd:
                    case oprtr:
                    case declrtn:
                        return (currInd, ind);
                    default:
                        break;
                }
            }
            if (currInd >= strCount)
            {
                currInd--;
            }
            return (currInd, --ind);
        }

    }
    public class CodeToken
    {
        public int Count { get; private set; }
        public string Value { get; set; }
        public bool IsOprtr;
        public void incCount() => Count++;
        public CodeToken(string val, bool isOprtr = false)
        {
            Value = val;
            Count = 1;
            IsOprtr = isOprtr;
        }
    }
}
