using Metr2;
using Microsoft.VisualBasic.Logging;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace Metrology1
{
    internal static class Analyzator
    {
        static List<CodeToken>? operands;
        static List<CodeToken>? operators;
        static int OprndDict, OprtrDict;
        static int OprndCnt, OprtrCnt;
        static int ProgrDict;
        static int ProgrLen;
        static int ProgrVol;
        static string Delimiter = Environment.NewLine + "================================================================================" + Environment.NewLine;
        const string outpPath = @"..\..\..\Files\Result.txt";
        public static void OutMetricsTable(TableLayoutPanel outPanel1, TableLayoutPanel outPanel2)
        {
            CodeLexer.Lex();
            (operands, operators) = CodeParser.ParseCode();
            
            foreach (CodeToken tkn in operands)
            {
                outPanel1.RowCount = outPanel1.RowCount + 1;
                outPanel1.RowStyles.Add(new RowStyle(SizeType.Percent, 50F));
                outPanel1.Controls.Add(new Label() { Text = tkn.Value, AutoSize = true }, 0, outPanel1.RowCount - 1);
                outPanel1.Controls.Add(new Label() { Text = tkn.Count.ToString(), AutoSize = true }, 1, outPanel1.RowCount - 1);
            }
            foreach (CodeToken tkn in operators)
            {
                outPanel2.RowCount = outPanel2.RowCount + 1;
                outPanel2.RowStyles.Add(new RowStyle(SizeType.Percent, 50F));
                outPanel2.Controls.Add(new Label() { Text = tkn.Value, AutoSize = true }, 0, outPanel2.RowCount - 1);
                outPanel2.Controls.Add(new Label() { Text = tkn.Count.ToString(), AutoSize = true }, 1, outPanel2.RowCount - 1);
            }

        }
        public static void OutpMetr(Label output)
        {
            CalcMetr();
            string str = "";
            str += $"Dictionary of operands: {OprndDict}" + Environment.NewLine;
            str += $"Dictionary of operators: {OprtrDict}" + Environment.NewLine;
            str += $"The total number of operands in the program: {OprndCnt}" + Environment.NewLine;
            str += $"The total number of operators in the program: {OprtrCnt}" + Environment.NewLine;
            str += $"The dictionary of the program: {ProgrDict}" + Environment.NewLine;
            str += $"The length of the program: {ProgrLen}" + Environment.NewLine;
            str += $"The scope of the program: {ProgrVol} " + Environment.NewLine + Environment.NewLine + Environment.NewLine;

            output.Text = str;
        }
        static void CalcMetr()
        {
            OprndDict = operands.Count;
            OprtrDict = operators.Count;
            OprndCnt = 0;
            OprtrCnt = 0;
            for(int i = 0; i < OprndDict; i++)
            {
                OprndCnt += operands[i].Count;
            }
            for(int j = 0; j < OprtrDict; j++)
            {
                OprtrCnt += operators[j].Count;
            }
            ProgrDict = OprndDict + OprtrDict;
            ProgrLen = OprndCnt + OprtrCnt;
            double lgrfm = Math.Log(ProgrDict) / Math.Log(2);
            ProgrVol = (int)Math.Ceiling((ProgrLen * lgrfm));
        }
    }
}
