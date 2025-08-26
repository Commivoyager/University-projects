using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Runtime.CompilerServices;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace Checkers
{
    public partial class MenuForm : Form
    {
        public Controller controller;
        private string logoPath = System.IO.Path.GetFullPath(System.IO.Path.Combine(Environment.CurrentDirectory, @"..\..\..\images\logo.png"));
        public string message = "";

        public MenuForm(Controller cntrl)
        {
            InitializeComponent();
            if (System.IO.File.Exists(logoPath))
            {
                this.pictureBoxLogo.Image = new Bitmap(logoPath);
            }
            this.controller = cntrl;
        }

        private void btnExit_Click(object sender, EventArgs e)
        {

        }

        private void btnSettings_Click(object sender, EventArgs e)
        {
            this.Height += this.pnlSettings.Height;
            pnlSettings.Visible = true;
            btnSettings.Enabled = false;
        }

        private void btnApply_Click(object sender, EventArgs e)
        {
            if (!passConnectData(radBtnModeAuto.Checked))
            {
                MessageBox.Show(message, "Incorrect input", MessageBoxButtons.OK, MessageBoxIcon.Information);
            }
            else
            {
                this.Height -= this.pnlSettings.Height;
                pnlSettings.Visible = false;
                btnSettings.Enabled = true;
            }
        }


        private void btnPlay_Click(object sender, EventArgs e)
        {
            if (!controller.netwCreated)
            {
                // Если происходит нажатие на кнопку начала игры
                // то если не было осуществлено соединение по сети (не открывали настройки соединения)
                // оно осуществляется для локального сервера и стандартного порта
                if (!passConnectData(true))
                {
                    showMessage();
                    return;
                }
            }
            btnSettings.Enabled = false;
            btnPlay.Enabled = false;
            controller.StartAuthorization();
        }

        public void showMessage(string messType = "Incorrect input")
        {
            MessageBox.Show(message, messType, MessageBoxButtons.OK, MessageBoxIcon.Information);
        }

        private bool passConnectData(bool deflt)
        {
            // flag - успешность соединения с серером + создания stream
            bool flag;
            (this.txtBoxIP.Text, this.numUpDownPort.Value, flag) = controller.ProcessConnectData(txtBoxIP.Text, (int)numUpDownPort.Value, deflt);
            return flag;
        }

        private void radBtnModeManual_CheckedChanged(object sender, EventArgs e)
        {
            if (radBtnModeManual.Checked)
            {
                txtBoxIP.Enabled = true;
                numUpDownPort.Enabled = true;
            }
        }

        private void radBtnModeAuto_CheckedChanged(object sender, EventArgs e)
        {
            if (radBtnModeAuto.Checked)
            {
                txtBoxIP.Enabled = false;
                numUpDownPort.Enabled = false;
            }
        }

        private void btnExit_Click_1(object sender, EventArgs e)
        {
            this.Close();
        }
    }
}
