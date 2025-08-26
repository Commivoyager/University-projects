using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using static System.Windows.Forms.VisualStyles.VisualStyleElement;

namespace WinFormsApp1
{
    public partial class MainForm : Form
    {
        string mainPath = "D:\\Asus Tuf Gaming A15\\Different\\Учёба\\ТИ\\1\\Files";
        bool columnCriph;
        bool encrAction;
        //public MessageForm messageForm;
        public MainForm()
        {
            InitializeComponent();
            toolStripStatusLabel1.Text = "";

            //DEBUG
            //int[] a = { 1, 2, 3, };
            //int[] b = a;
            //b[0] = 0;
            //b[0] = a[0];
        }

        private void radBtnColumn_CheckedChanged(object sender, EventArgs e)
        {
            txtBoxVigenerKey.Visible = false;
            pnlKey2.Visible = true;
            columnCriph = true;
            lblKey1.Text = "1-ый ключ:";
        }

        private void radBtnVigenere_CheckedChanged(object sender, EventArgs e)
        {
            pnlKey2.Visible = false;
            txtBoxVigenerKey.Visible = true;
            columnCriph = false;
            lblKey1.Text = "Ключ:";

        }




        private void btnStart_Click(object sender, EventArgs e)
        {
            //В23адVadimи7890./.L<MKL<>LKMNKML<">?mlМкер
            string currPath = txtBoxFPath.Text;
            string fileName = "";
            int outpLen = 400;
            toolStripStatusLabel1.Text = "";
            for (int i = currPath.Length - 1; i >= 0; i--)
            {
                if (currPath[i] == '\\')
                {
                    fileName = currPath.Substring(i);
                    i = -1;
                }
            }
            if (columnCriph)
            {
                if (ColumnMethod.initEncryptor(txtBoxKey1.Text, txtBoxKey2.Text))
                {
                    if (encrAction)
                    {
                        if (!ColumnMethod.encrypt(currPath, mainPath + "\\Encrypted" + fileName))
                        {
                            toolStripStatusLabel1.Text = ColumnMethod.messageStr;
                        }
                        else
                        {
                            if(outpLen > ColumnMethod.charNum)
                            {
                                outpLen = ColumnMethod.charNum;
                            }
                            txtBoxProcText.Text = "Plaintext:" + Environment.NewLine + ColumnMethod.sourceString.Substring(0, outpLen);
                            txtBoxResText.Text = "CipherText:" + Environment.NewLine + new string(ColumnMethod.resText, 0, outpLen);
                        }
                    }
                    else
                    {
                        if (!ColumnMethod.decrypt(currPath, mainPath + "\\Decrypted" + fileName))
                        {
                            toolStripStatusLabel1.Text = ColumnMethod.messageStr;
                        }
                        else
                        {
                            if (outpLen > ColumnMethod.charNum)
                            {
                                outpLen = ColumnMethod.charNum;
                            }
                            txtBoxProcText.Text = "CipherText:" + Environment.NewLine + ColumnMethod.sourceString.Substring(0, outpLen);
                            txtBoxResText.Text = "Plaintext:" + Environment.NewLine + new string(ColumnMethod.resText, 0, outpLen);
                        }
                    }
                }
                else
                {
                    toolStripStatusLabel1.Text = ColumnMethod.messageStr;
                }
            }
            else
            {
                if (VigenereMethod.initEncryptor(txtBoxKey1.Text))
                {
                    string resDir;
                    if (encrAction)
                    {
                        resDir = mainPath + "\\Encrypted";
                    }
                    else
                    {
                        resDir = mainPath + "\\Decrypted";
                    }
                    if (!VigenereMethod.cryptoFunc(currPath, resDir + fileName, encrAction))
                    {
                        toolStripStatusLabel1.Text = VigenereMethod.messageStr;
                    }
                    else
                    {
                        if (outpLen > VigenereMethod.charNum)
                        {
                            outpLen = VigenereMethod.charNum;
                        }
                        txtBoxProcText.Text = "Source text:" + Environment.NewLine + VigenereMethod.procText.Substring(0, outpLen);
                        txtBoxResText.Text = "Result:" + Environment.NewLine + new string(VigenereMethod.resText, 0, outpLen);
                        txtBoxVigenerKey.Text = "Key:" + Environment.NewLine + new string(VigenereMethod.key, 0, VigenereMethod.keyLen);
                    }
                }
                else
                {
                    toolStripStatusLabel1.Text = VigenereMethod.messageStr;
                }
            }
        }

        private void radBtnCripher_CheckedChanged(object sender, EventArgs e)
        {
            encrAction = true;
        }

        private void radioButton3_CheckedChanged(object sender, EventArgs e)
        {
            encrAction = false;
        }

        private void btnFPath_Click(object sender, EventArgs e)
        {
            using (OpenFileDialog openFileDialog = new OpenFileDialog())
            {
                openFileDialog.InitialDirectory = mainPath;
                openFileDialog.Filter = "All files (*.*)|*.*";

                if (openFileDialog.ShowDialog() == DialogResult.OK)
                {
                    txtBoxFPath.Text = String.Copy(openFileDialog.FileName);
                }

            }
        }

        private void txtBoxKey1_TextChanged(object sender, EventArgs e)
        {

        }

        private void MainForm_Load(object sender, EventArgs e)
        {

        }
    }
}