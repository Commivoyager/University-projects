using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace Checkers
{
    public partial class AuthForm : Form
    {
        Controller controller;
        public string message = "";
        public AuthForm(Controller cntrl)
        {
            InitializeComponent();
            this.controller = cntrl;
        }

        public void showMessage(string messType)
        {
            MessageBox.Show(message, messType, MessageBoxButtons.OK, MessageBoxIcon.Information);
        }

        private void btnRegistrate_Click(object sender, EventArgs e)
        {
            if(controller.Authorize(txtBoxLogin.Text, txtBoxPassword.Text, Controller.RegCode))
            {
                controller.userLogin = txtBoxLogin.Text;
                controller.userF.lblGreet.Text = $"Hello, {controller.userLogin}";

            }
            else
            {
                showMessage(message);
            }

        }

        private void btnLogin_Click(object sender, EventArgs e)
        {
            if(controller.Authorize(txtBoxLogin.Text, txtBoxPassword.Text, Controller.AuthCode))
            {
                controller.userLogin = txtBoxLogin.Text;
                controller.userF.lblGreet.Text = $"Hello, {controller.userLogin}";

            }
            else
            {
                showMessage(message);
            }
        }


    }
}
