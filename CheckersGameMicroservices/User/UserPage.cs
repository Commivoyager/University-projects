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
    public partial class UserPage : Form
    {
        public Controller controller;
        public UserPage(Controller cntrl)
        {
            controller = cntrl;
            InitializeComponent();
        }

        private void btnPlay_Click(object sender, EventArgs e)
        {
            controller.userF.Hide();
            controller.startGame();
        }

        private void btnGetInfo_Click(object sender, EventArgs e)
        {
            txtBoxGameInf.Text = controller.getGamesInf();
        }

        private void UserPage_Load(object sender, EventArgs e)
        {

        }

        private void UserPage_FormClosing(object sender, FormClosingEventArgs e)
        {
            controller.menuF.Close();
        }

        private void lblGreet_Click(object sender, EventArgs e)
        {

        }
    }
}
