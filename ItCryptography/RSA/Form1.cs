namespace IT_RSA_Lab
{
    public partial class Form1 : Form
    {
        bool pFilled = false;
        bool qFilled = false;
        bool dFilled = false;
        bool encryptAction = false;
        const string mainPath = "D:\\Asus Tuf Gaming A15\\Different\\Ó÷¸áà\\ÒÈ\\3\\Files";
        const string encrPath = "\\Encrypted";
        const string decrPath = "\\Decrypted";
        string currPath;
        public Form1()
        {
            InitializeComponent();




        }

        private void txtBoxP_TextChanged(object sender, EventArgs e)
        {
            //if(Int32.TryParse(txtBoxP.Text))
            pFilled = true;
            int strLen = txtBoxP.Text.Length;
            if (strLen == 0)
            {
                pFilled = false;
            }
            else
            {
                for (int i = 0; i < strLen; i++)
                {
                    if (txtBoxP.Text[i] < '0' || txtBoxP.Text[i] > '9')
                    {
                        i = strLen;
                        pFilled = false;
                    }
                }
            }
            if (pFilled && qFilled)
            {
                btnCalcFromPQ.Enabled = true;
            }
            else
            {
                btnCalcFromPQ.Enabled = false;
            }
        }

        private void txtBoxQ_TextChanged(object sender, EventArgs e)
        {
            qFilled = true;
            int strLen = txtBoxQ.Text.Length;
            if (strLen == 0)
            {
                qFilled = false;
            }
            else
            {
                for (int i = 0; i < strLen; i++)
                {
                    if (txtBoxQ.Text[i] < '0' || txtBoxQ.Text[i] > '9')
                    {
                        i = strLen;
                        qFilled = false;
                    }
                }
            }
            if (qFilled && pFilled)
            {
                btnCalcFromPQ.Enabled = true;
            }
            else
            {
                btnCalcFromPQ.Enabled = false;
            }
        }

        private void txtBoxD_TextChanged(object sender, EventArgs e)
        {
            dFilled = true;
            int strLen = txtBoxD.Text.Length;
            if (strLen == 0)
            {
                dFilled = false;
            }
            else
            {
                for (int i = 0; i < strLen; i++)
                {
                    if (txtBoxD.Text[i] < '0' || txtBoxD.Text[i] > '9')
                    {
                        i = strLen;
                        dFilled = false;
                    }
                }
            }
            if (dFilled)
            {
                btnCalcFromD.Enabled = true;
            }
            else
            {
                btnCalcFromD.Enabled = false;
            }
        }

        private void btnCalcFromPQ_Click(object sender, EventArgs e)
        {
            int p = convrtToInt(txtBoxP.Text);
            int q = convrtToInt(txtBoxQ.Text);
            if (RSALogic.initNumbers(p, q))
            {
                txtBoxR.Text = Convert.ToString(RSALogic.rNum);
                txtBoxEulerF.Text = Convert.ToString(RSALogic.fEuler);
                toolStripStatusLabel3.Text = "";
            }
            else
            {
                toolStripStatusLabel3.Text = RSALogic.messageStr;
            }

        }

        private void btnCalcFromD_Click(object sender, EventArgs e)
        {
            int d = convrtToInt(txtBoxD.Text);
            if (RSALogic.initKeys(d))
            {
                txtBoxE.Text = Convert.ToString(RSALogic.publicKey);
                rdBtnEncrypt.Enabled = true;
                rdBtnDecrypt.Enabled = true;
                toolStripStatusLabel3.Text = "";
            }
            else
            {
                toolStripStatusLabel3.Text = RSALogic.messageStr;
            }
        }

        int convrtToInt(string txtNum)
        {
            int res = 0;
            int strLen = txtNum.Length;
            int decPlace = 1;
            for (int i = strLen - 1; i >= 0; i--)
            {
                res += (txtNum[i] - '0') * decPlace;
                decPlace *= 10;
            }
            return res;
        }

        private void button1_Click(object sender, EventArgs e)
        {
            using (OpenFileDialog openFileDialog = new OpenFileDialog())
            {
                openFileDialog.InitialDirectory = mainPath;
                openFileDialog.Filter = "All files (*.*)|*.*";

                if (openFileDialog.ShowDialog() == DialogResult.OK)
                {
                    txtBoxFilePath.Text = String.Copy(openFileDialog.FileName);
                }

            }
        }

        private void rdBtnEncrypt_CheckedChanged(object sender, EventArgs e)
        {
            btnCrypt.Text = "Encrypt";
            btnCrypt.Enabled = true;
            encryptAction = true;
        }

        private void rdBtnDecrypt_CheckedChanged(object sender, EventArgs e)
        {
            btnCrypt.Text = "Decrypt";
            btnCrypt.Enabled = true;
            encryptAction = false;
        }

        private void btnCrypt_Click(object sender, EventArgs e)
        {
            currPath = txtBoxFilePath.Text;
            string fileName = "";
            string cryptNumbers = "";
            int maxOutpSize = 250;
            for (int i = currPath.Length - 1; i >= 0; i--)
            {
                if (currPath[i] == '\\')
                {
                    fileName = currPath.Substring(i);
                    i = -1;
                }
            }
            if (encryptAction)
            {
                if (RSALogic.encrypt(currPath, mainPath + encrPath + fileName))
                {
                    cryptNumbers += "Numbers of plaintext:" + Environment.NewLine;
                    int size = RSALogic.plainBuf.Length < maxOutpSize ? RSALogic.plainBuf.Length : maxOutpSize;
                    for (int i = 0; i < size; i++)
                    {
                        cryptNumbers += RSALogic.plainBuf[i];
                        cryptNumbers += "\t";
                    }
                    txtBoxPlaintext.Text = cryptNumbers;
                    cryptNumbers = "Numbers of ciphertext:" + Environment.NewLine;
                    for (int i = 0; i < size; i++)
                    {
                        cryptNumbers += RSALogic.encrBuf[i];
                        cryptNumbers += "\t";
                    }
                    txtBoxCiphertext.Text = cryptNumbers;
                }
                else
                {
                    toolStripStatusLabel3.Text = RSALogic.messageStr;
                }
            }
            else
            {
                if (RSALogic.decrypt(currPath, mainPath + decrPath + fileName))
                {
                    cryptNumbers += "Numbers of ciphertext:" + Environment.NewLine;
                    int size = RSALogic.plainBuf.Length < maxOutpSize ? RSALogic.plainBuf.Length : maxOutpSize;
                    for (int i = 0; i < size; i++)
                    {
                        cryptNumbers += RSALogic.encrBuf[i];
                        cryptNumbers += "\t";
                    }
                    txtBoxPlaintext.Text = cryptNumbers;
                    cryptNumbers = "Numbers of plaintext:" + Environment.NewLine;
                    for (int i = 0; i < size; i++)
                    {
                        cryptNumbers += RSALogic.plainBuf[i];
                        cryptNumbers += "\t";
                    }
                    txtBoxCiphertext.Text = cryptNumbers;
                }
                else
                {
                    toolStripStatusLabel3.Text = RSALogic.messageStr;
                }
            }
        }

        private void textBox1_TextChanged(object sender, EventArgs e)
        {

        }
    }
}