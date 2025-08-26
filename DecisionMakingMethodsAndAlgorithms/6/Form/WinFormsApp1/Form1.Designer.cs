namespace WinFormsApp1
{
    partial class Form1
    {
        /// <summary>
        ///  Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        ///  Clean up any resources being used.
        /// </summary>
        /// <param name="disposing">true if managed resources should be disposed; otherwise, false.</param>
        protected override void Dispose(bool disposing)
        {
            if (disposing && (components != null))
            {
                components.Dispose();
            }
            base.Dispose(disposing);
        }

        #region Windows Form Designer generated code

        /// <summary>
        ///  Required method for Designer support - do not modify
        ///  the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            textBox1 = new TextBox();
            button1 = new Button();
            numericUpDown1 = new NumericUpDown();
            panel1 = new Panel();
            button2 = new Button();
            ((System.ComponentModel.ISupportInitialize)numericUpDown1).BeginInit();
            panel1.SuspendLayout();
            SuspendLayout();
            // 
            // textBox1
            // 
            textBox1.BorderStyle = BorderStyle.FixedSingle;
            textBox1.Font = new Font("Segoe UI", 13.8F, FontStyle.Regular, GraphicsUnit.Point, 204);
            textBox1.Location = new Point(0, 0);
            textBox1.Multiline = true;
            textBox1.Name = "textBox1";
            textBox1.ScrollBars = ScrollBars.Both;
            textBox1.Size = new Size(362, 307);
            textBox1.TabIndex = 0;
            textBox1.WordWrap = false;
            // 
            // button1
            // 
            button1.Font = new Font("Segoe UI", 10.8F, FontStyle.Regular, GraphicsUnit.Point, 204);
            button1.Location = new Point(147, 313);
            button1.Name = "button1";
            button1.Size = new Size(170, 43);
            button1.TabIndex = 1;
            button1.Text = "Calculate for min";
            button1.UseVisualStyleBackColor = true;
            button1.Click += button1_Click;
            // 
            // numericUpDown1
            // 
            numericUpDown1.Font = new Font("Segoe UI", 16.2F, FontStyle.Regular, GraphicsUnit.Point, 204);
            numericUpDown1.Location = new Point(38, 340);
            numericUpDown1.Maximum = new decimal(new int[] { 14, 0, 0, 0 });
            numericUpDown1.Name = "numericUpDown1";
            numericUpDown1.Size = new Size(71, 43);
            numericUpDown1.TabIndex = 2;
            numericUpDown1.Value = new decimal(new int[] { 4, 0, 0, 0 });
            numericUpDown1.ValueChanged += numericUpDown1_ValueChanged;
            // 
            // panel1
            // 
            panel1.Anchor = AnchorStyles.Right;
            panel1.Controls.Add(button2);
            panel1.Controls.Add(textBox1);
            panel1.Controls.Add(button1);
            panel1.Controls.Add(numericUpDown1);
            panel1.Location = new Point(896, 12);
            panel1.Name = "panel1";
            panel1.Size = new Size(365, 408);
            panel1.TabIndex = 3;
            // 
            // button2
            // 
            button2.Font = new Font("Segoe UI", 10.8F, FontStyle.Regular, GraphicsUnit.Point, 204);
            button2.Location = new Point(147, 367);
            button2.Name = "button2";
            button2.Size = new Size(170, 38);
            button2.TabIndex = 3;
            button2.Text = "Calculate for max";
            button2.UseVisualStyleBackColor = true;
            button2.Click += button2_Click;
            // 
            // Form1
            // 
            AutoScaleDimensions = new SizeF(8F, 20F);
            AutoScaleMode = AutoScaleMode.Font;
            ClientSize = new Size(1273, 495);
            Controls.Add(panel1);
            DoubleBuffered = true;
            Name = "Form1";
            Text = "Form1";
            Paint += Form1_Paint;
            Resize += Form1_Resize;
            ((System.ComponentModel.ISupportInitialize)numericUpDown1).EndInit();
            panel1.ResumeLayout(false);
            panel1.PerformLayout();
            ResumeLayout(false);
        }

        #endregion

        private TextBox textBox1;
        private Button button1;
        private NumericUpDown numericUpDown1;
        private Panel panel1;
        private Button button2;
    }
}
