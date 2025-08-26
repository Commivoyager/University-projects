using System.Drawing.Drawing2D;
namespace OOP1
{
    public partial class MainForm : Form
    {
        //Объект игрового поля
        DrawField drawField;

        //Координаты левой верхней
        //и правой нижней точек игрового
        //поля
        int fieldX1 = 0;
        int fieldY1 = 0;
        int fieldX2 = 1000;
        int fieldY2 = 900;
        //Толщина обводки игрового поля
        int borderTh = 10;

        public MainForm()
        {
            InitializeComponent();
            fieldX2 = DisplayRectangle.Width;
            fieldY2 = DisplayRectangle.Height;

            //Создание объекта игрового поля и всех объектов фигур
            ObjectsGen.GenObjects(ref drawField, fieldX1, fieldY1, fieldX2, fieldY2, borderTh);
        }

        private void MainForm_Paint(object sender, PaintEventArgs e)
        {
            //Отрисовка игрового поля и всех фигур
            Graphics g = e.Graphics;
            g.TranslateTransform(DisplayRectangle.Width, DisplayRectangle.Height);
            g.RotateTransform(180);
            g.Clear(Color.FromArgb(255, 255, 255));
            drawField.Draw(g);
            for (int i = 0; i < drawField.fieldObjects.Length; i++)
            {
                (drawField.fieldObjects[i]).Draw(g);
            }
            g.ResetTransform();
        }

        private void MainForm_Resize(object sender, EventArgs e)
        {
            Refresh();
        }
    }
}
