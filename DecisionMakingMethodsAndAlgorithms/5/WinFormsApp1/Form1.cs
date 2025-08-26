namespace WinFormsApp1
{
    public partial class Form1 : Form
    {
        FuncCalc func = new FuncCalc();
        public Form1()
        {
            func.Calc();
            func.RandP();
            InitializeComponent();
        }

        private void Form1_Paint(object sender, PaintEventArgs e)
        {
            func.drawFunc(e.Graphics, e.ClipRectangle.Width, e.ClipRectangle.Height);
        }
    }
}
