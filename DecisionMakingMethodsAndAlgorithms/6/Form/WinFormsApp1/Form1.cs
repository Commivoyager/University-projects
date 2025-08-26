using System.Windows.Forms;
using static System.Windows.Forms.VisualStyles.VisualStyleElement;

namespace WinFormsApp1
{
    public partial class Form1 : Form
    {
        bool isPaint = false;
        int n;
        public Form1()
        {
            InitializeComponent();

        }

        private void Form1_Paint(object sender, PaintEventArgs e)
        {
            if (isPaint)
            {
                Class1 cl = new Class1();
                textBox1.Text += cl.mainFunc(e.Graphics, DisplayRectangle.Height, n, Class2.distTable);
            }

        }

        private void Form1_Resize(object sender, EventArgs e)
        {

        }

        private void button1_Click(object sender, EventArgs e)
        {
            n = (int)numericUpDown1.Value;
            Class2.genMatr(n);
            textBox1.Clear();
            textBox1.Text = Class2.distTableStr;
            isPaint = true;
            Refresh();
        }

        private void numericUpDown1_ValueChanged(object sender, EventArgs e)
        {

        }

        private void button2_Click(object sender, EventArgs e)
        {
            //n = (int)numericUpDown1.Value;
            //Class2.genMatr(n);
            Class2.GenMatrForMax(n);
            textBox1.Clear();
            textBox1.Text = Class2.distTableStr;
            isPaint = true;
            Refresh();
        }
    }
}
