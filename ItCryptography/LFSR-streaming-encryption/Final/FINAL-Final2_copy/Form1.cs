using ConsoleApp1;
using System.Collections;

namespace WinFormsApp1
{
    public partial class Form1 : Form
    {
        public Form1()
        {
            InitializeComponent();
        }

        private void btnGenKey_Click(object sender, EventArgs e)
        {
            Calculates.sourceFileName = txtBoxFilePath.Text;
            if (File.Exists(Calculates.sourceFileName))
            {
                if (CheckData.CheckP(txtBoxPolynom.Text, ref Calculates.plnmlLst, ref Calculates.regLen))
                {
                    if (CheckData.checkReg(txtBoxStartReg.Text, Calculates.regLen))
                    {
                        Calculates.regState = String.Copy(txtBoxStartReg.Text);
                        Calculates.GenKey();

                        char[] outpKey = new char[Calculates.copyCount * 8];
                        int lastInd = Calculates.fBitLen - 1;
                        for (int i = 0; i < Calculates.copyCount * 8; i++)
                        {
                            outpKey[i] = Calculates.bitKey[lastInd - i] ? '1' : '0';
                        }
                        txtBoxGenKey.Text = new string(outpKey);
                        String outpIter = new String(outpKey, 0, Calculates.regLen);
                        String allIter = String.Empty;
                        for(int i = Calculates.regLen; i < Calculates.iterNum + Calculates.regLen - 1; i++)
                        {
                            allIter += outpIter + Environment.NewLine;
                            outpIter += outpKey[i];
                        }
                        txtBoxKeyIter.Text = allIter;
                        radBtnEncr.Checked = true;
                        btnMakeCalc.Enabled = true;
                    }
                    else
                    {
                        txtBoxStartReg.Text = "Incorrect";
                        btnMakeCalc.Enabled = false;
                    }
                }
                else
                {
                    txtBoxPolynom.Text = "Incorrect";
                    btnMakeCalc.Enabled = false;
                }
            }
            else
            {
                txtBoxGenKey.Text = "There is no file with that name";
                btnMakeCalc.Enabled = false;
            }
        }

        private void btnMakeCalc_Click(object sender, EventArgs e)
        {
            if (File.Exists(Calculates.sourceFileName))
            {
                long lenFSource = new FileInfo(Calculates.sourceFileName).Length;
                if (lenFSource == Calculates.fLen)
                {
                    Calculates.CryptAlg();
                    char[] outpData = new char[Calculates.copyCount * 8];
                    StrFromBits(Calculates.sourceFBitContent, outpData);
                    txtBoxSourceFile.Text = new string(outpData);
                    //DEBUG
                    //for (int i = 0; i < outpData) ;
                    //DEBUG
                    StrFromBits(Calculates.resFBitContent, outpData);
                    txtBoxResFile.Text = new string(outpData);
                }
                else
                {
                    txtBoxResFile.Text = "Error";
                }
            }
            else
            {
                txtBoxResFile.Text = "Error";
            }
        }

        void StrFromBits(BitArray bArr, char[] chrStr)
        {
            for (int i = 0; i < Calculates.copyCount * 8; i++)
            {
                chrStr[i] = bArr[Calculates.copyCount * 8 - i - 1] ? '1' : '0';
            }
        }

        private void btnFileBrowse_Click(object sender, EventArgs e)
        {
            string filePath = string.Empty;
            string fileContent = string.Empty;

            using (OpenFileDialog openFileDialog = new OpenFileDialog())
            {
                openFileDialog.InitialDirectory = "D:\\Asus Tuf Gaming A15\\Different\\Ó÷¸áà\\ÒÈ\\2\\Files";
                openFileDialog.Filter = "All files (*.*)|*.*";

                if (openFileDialog.ShowDialog() == DialogResult.OK)
                {
                    txtBoxFilePath.Text = String.Copy(openFileDialog.FileName);
                }

            }
        }

        //private void txtBoxFilePath_Leave(object sender, EventArgs e)
        //{

        //}

        private void radBtnEncr_CheckedChanged(object sender, EventArgs e)
        {
            Calculates.resFileName = String.Copy(Calculates.encrRes);
        }

        private void radBtnDecr_CheckedChanged(object sender, EventArgs e)
        {
            Calculates.resFileName = String.Copy(Calculates.decrRes);
        }

        //private void pnlSourceFields_Paint(object sender, PaintEventArgs e)
        //{

        //}

        //private void txtBoxStartReg_TextChanged(object sender, EventArgs e)
        //{

        //}

        private void txtBoxFilePath_TextChanged(object sender, EventArgs e)
        {
            Calculates.sourceFileName = String.Copy(txtBoxFilePath.Text);
        }

        //private void lblPolynom_Click(object sender, EventArgs e)
        //{

        //}

        //private void label1_Click(object sender, EventArgs e)
        //{

        //}

        //private void Form1_Load(object sender, EventArgs e)
        //{

        //}
    }
}
