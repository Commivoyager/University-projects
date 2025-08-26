using Metr2;
using System.Windows.Forms;
using Metrology1;

namespace Metrology1
{
    public partial class Form1 : Form
    {
        string mainCode;
        public Form1()
        {
            InitializeComponent();

            tableLayoutPanel1.RowCount = 0;
            tableLayoutPanel1.RowStyles.Clear();
            tableLayoutPanel1.AutoScroll = true;

            tableLayoutPanel2.RowCount = 0;
            tableLayoutPanel2.RowStyles.Clear();
            tableLayoutPanel2.AutoScroll = true;

            tableLayoutPanel1.RowCount = tableLayoutPanel1.RowCount + 1;
            tableLayoutPanel1.Controls.Add(new Label() { Text = "Operands" }, 0, 0);
            tableLayoutPanel1.Controls.Add(new Label() { Text = "No" }, 1, 0);

            tableLayoutPanel2.RowCount = tableLayoutPanel2.RowCount + 1;
            tableLayoutPanel2.Controls.Add(new Label() { Text = "Operators" }, 0, 0);
            tableLayoutPanel2.Controls.Add(new Label() { Text = "No" }, 1, 0);
        }

        private void button2_Click(object sender, EventArgs e)
        {
            Analyzator.OutMetricsTable(tableLayoutPanel1, tableLayoutPanel2);
            Analyzator.OutpMetr(label1);
        }

        private void button1_Click(object sender, EventArgs e)
        {
            OpenFileDialog openFileDialog = new OpenFileDialog();
            openFileDialog.Title = "Выберите файл";
            openFileDialog.Filter = "Все файлы (*.*)|*.*";
            openFileDialog.InitialDirectory = @"..\..\..\Files";
            string selectedFilePath = "";
            // Открытие диалогового окна и проверка, был ли выбран файл
            if (openFileDialog.ShowDialog() == DialogResult.OK)
            {
                // Получение пути к выбранному файлу
                selectedFilePath = openFileDialog.FileName;
            }
            CodeLexer.inputFilePath = selectedFilePath;
            mainCode = File.ReadAllText(selectedFilePath);
            textBox1.Text = mainCode;
        }

    }
}
