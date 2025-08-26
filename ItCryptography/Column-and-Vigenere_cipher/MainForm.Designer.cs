namespace WinFormsApp1
{
    partial class MainForm
    {
        /// <summary>
        /// Required designer variable.
        /// </summary>
        private System.ComponentModel.IContainer components = null;

        /// <summary>
        /// Clean up any resources being used.
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
        /// Required method for Designer support - do not modify
        /// the contents of this method with the code editor.
        /// </summary>
        private void InitializeComponent()
        {
            pnlCriphAlg = new Panel();
            radBtnVigenere = new RadioButton();
            radBtnColumn = new RadioButton();
            lblAlg = new Label();
            pnlAct = new Panel();
            radBtnDecrypt = new RadioButton();
            radBtnCripher = new RadioButton();
            lblAct = new Label();
            pnlKey1 = new Panel();
            lblKey1 = new Label();
            txtBoxKey1 = new TextBox();
            pnlKey2 = new Panel();
            lblKey2 = new Label();
            txtBoxKey2 = new TextBox();
            btnStart = new Button();
            statusStrip1 = new StatusStrip();
            toolStripStatusLabel1 = new ToolStripStatusLabel();
            panel1 = new Panel();
            btnFPath = new Button();
            txtBoxFPath = new TextBox();
            lblFPath = new Label();
            pnlText = new Panel();
            txtBoxResText = new TextBox();
            txtBoxProcText = new TextBox();
            txtBoxVigenerKey = new TextBox();
            pnlCriphAlg.SuspendLayout();
            pnlAct.SuspendLayout();
            pnlKey1.SuspendLayout();
            pnlKey2.SuspendLayout();
            statusStrip1.SuspendLayout();
            panel1.SuspendLayout();
            pnlText.SuspendLayout();
            SuspendLayout();
            // 
            // pnlCriphAlg
            // 
            pnlCriphAlg.Controls.Add(radBtnVigenere);
            pnlCriphAlg.Controls.Add(radBtnColumn);
            pnlCriphAlg.Controls.Add(lblAlg);
            pnlCriphAlg.Location = new Point(12, 12);
            pnlCriphAlg.Name = "pnlCriphAlg";
            pnlCriphAlg.Size = new Size(183, 122);
            pnlCriphAlg.TabIndex = 0;
            // 
            // radBtnVigenere
            // 
            radBtnVigenere.AutoSize = true;
            radBtnVigenere.Font = new Font("Segoe UI", 12F, FontStyle.Regular, GraphicsUnit.Point, 204);
            radBtnVigenere.Location = new Point(14, 90);
            radBtnVigenere.Name = "radBtnVigenere";
            radBtnVigenere.Size = new Size(125, 32);
            radBtnVigenere.TabIndex = 2;
            radBtnVigenere.Text = "Виженера";
            radBtnVigenere.UseVisualStyleBackColor = true;
            radBtnVigenere.CheckedChanged += radBtnVigenere_CheckedChanged;
            // 
            // radBtnColumn
            // 
            radBtnColumn.AutoSize = true;
            radBtnColumn.Font = new Font("Segoe UI", 12F, FontStyle.Regular, GraphicsUnit.Point, 204);
            radBtnColumn.Location = new Point(14, 49);
            radBtnColumn.Name = "radBtnColumn";
            radBtnColumn.Size = new Size(149, 32);
            radBtnColumn.TabIndex = 1;
            radBtnColumn.Text = "Столбцовый";
            radBtnColumn.UseVisualStyleBackColor = true;
            radBtnColumn.CheckedChanged += radBtnColumn_CheckedChanged;
            // 
            // lblAlg
            // 
            lblAlg.AutoSize = true;
            lblAlg.Font = new Font("Segoe UI", 13.8F, FontStyle.Regular, GraphicsUnit.Point, 204);
            lblAlg.Location = new Point(14, 15);
            lblAlg.Name = "lblAlg";
            lblAlg.Size = new Size(115, 31);
            lblAlg.TabIndex = 0;
            lblAlg.Text = "Алгоритм";
            // 
            // pnlAct
            // 
            pnlAct.Controls.Add(radBtnDecrypt);
            pnlAct.Controls.Add(radBtnCripher);
            pnlAct.Controls.Add(lblAct);
            pnlAct.Location = new Point(201, 12);
            pnlAct.Name = "pnlAct";
            pnlAct.Size = new Size(199, 122);
            pnlAct.TabIndex = 2;
            // 
            // radBtnDecrypt
            // 
            radBtnDecrypt.AutoSize = true;
            radBtnDecrypt.Font = new Font("Segoe UI", 12F, FontStyle.Regular, GraphicsUnit.Point, 204);
            radBtnDecrypt.Location = new Point(14, 90);
            radBtnDecrypt.Name = "radBtnDecrypt";
            radBtnDecrypt.Size = new Size(178, 32);
            radBtnDecrypt.TabIndex = 3;
            radBtnDecrypt.Text = "Дешифрование";
            radBtnDecrypt.UseVisualStyleBackColor = true;
            radBtnDecrypt.CheckedChanged += radioButton3_CheckedChanged;
            // 
            // radBtnCripher
            // 
            radBtnCripher.AutoSize = true;
            radBtnCripher.Font = new Font("Segoe UI", 12F, FontStyle.Regular, GraphicsUnit.Point, 204);
            radBtnCripher.Location = new Point(14, 49);
            radBtnCripher.Name = "radBtnCripher";
            radBtnCripher.Size = new Size(157, 32);
            radBtnCripher.TabIndex = 2;
            radBtnCripher.Text = "Шифрование";
            radBtnCripher.UseVisualStyleBackColor = true;
            radBtnCripher.CheckedChanged += radBtnCripher_CheckedChanged;
            // 
            // lblAct
            // 
            lblAct.AutoSize = true;
            lblAct.Font = new Font("Segoe UI", 13.8F, FontStyle.Regular, GraphicsUnit.Point, 204);
            lblAct.Location = new Point(14, 15);
            lblAct.Name = "lblAct";
            lblAct.Size = new Size(112, 31);
            lblAct.TabIndex = 1;
            lblAct.Text = "Действие";
            // 
            // pnlKey1
            // 
            pnlKey1.Controls.Add(lblKey1);
            pnlKey1.Controls.Add(txtBoxKey1);
            pnlKey1.Location = new Point(12, 140);
            pnlKey1.Name = "pnlKey1";
            pnlKey1.Size = new Size(404, 67);
            pnlKey1.TabIndex = 5;
            // 
            // lblKey1
            // 
            lblKey1.AutoSize = true;
            lblKey1.Font = new Font("Segoe UI", 12F, FontStyle.Regular, GraphicsUnit.Point, 204);
            lblKey1.Location = new Point(14, 0);
            lblKey1.Name = "lblKey1";
            lblKey1.Size = new Size(66, 28);
            lblKey1.TabIndex = 6;
            lblKey1.Text = "Ключ:";
            // 
            // txtBoxKey1
            // 
            txtBoxKey1.BorderStyle = BorderStyle.FixedSingle;
            txtBoxKey1.Location = new Point(14, 31);
            txtBoxKey1.Name = "txtBoxKey1";
            txtBoxKey1.Size = new Size(362, 27);
            txtBoxKey1.TabIndex = 4;
            txtBoxKey1.Text = "Првет";
            txtBoxKey1.TextChanged += txtBoxKey1_TextChanged;
            // 
            // pnlKey2
            // 
            pnlKey2.Controls.Add(lblKey2);
            pnlKey2.Controls.Add(txtBoxKey2);
            pnlKey2.Location = new Point(12, 213);
            pnlKey2.Name = "pnlKey2";
            pnlKey2.Size = new Size(404, 67);
            pnlKey2.TabIndex = 6;
            pnlKey2.Visible = false;
            // 
            // lblKey2
            // 
            lblKey2.AutoSize = true;
            lblKey2.Font = new Font("Segoe UI", 12F, FontStyle.Regular, GraphicsUnit.Point, 204);
            lblKey2.Location = new Point(14, -1);
            lblKey2.Name = "lblKey2";
            lblKey2.Size = new Size(112, 28);
            lblKey2.TabIndex = 9;
            lblKey2.Text = "2-ой ключ:";
            // 
            // txtBoxKey2
            // 
            txtBoxKey2.BorderStyle = BorderStyle.FixedSingle;
            txtBoxKey2.Location = new Point(14, 30);
            txtBoxKey2.Name = "txtBoxKey2";
            txtBoxKey2.Size = new Size(383, 27);
            txtBoxKey2.TabIndex = 8;
            txtBoxKey2.Text = "Мир";
            // 
            // btnStart
            // 
            btnStart.Location = new Point(141, 375);
            btnStart.Name = "btnStart";
            btnStart.Size = new Size(131, 29);
            btnStart.TabIndex = 7;
            btnStart.Text = "Начать";
            btnStart.UseVisualStyleBackColor = true;
            btnStart.Click += btnStart_Click;
            // 
            // statusStrip1
            // 
            statusStrip1.ImageScalingSize = new Size(20, 20);
            statusStrip1.Items.AddRange(new ToolStripItem[] { toolStripStatusLabel1 });
            statusStrip1.Location = new Point(0, 407);
            statusStrip1.Name = "statusStrip1";
            statusStrip1.Size = new Size(1005, 26);
            statusStrip1.TabIndex = 8;
            statusStrip1.Text = "statusStrip1";
            // 
            // toolStripStatusLabel1
            // 
            toolStripStatusLabel1.Name = "toolStripStatusLabel1";
            toolStripStatusLabel1.Size = new Size(151, 20);
            toolStripStatusLabel1.Text = "toolStripStatusLabel1";
            // 
            // panel1
            // 
            panel1.Controls.Add(btnFPath);
            panel1.Controls.Add(txtBoxFPath);
            panel1.Controls.Add(lblFPath);
            panel1.Location = new Point(12, 317);
            panel1.Name = "panel1";
            panel1.Size = new Size(404, 52);
            panel1.TabIndex = 9;
            // 
            // btnFPath
            // 
            btnFPath.Location = new Point(319, 14);
            btnFPath.Name = "btnFPath";
            btnFPath.Size = new Size(82, 29);
            btnFPath.TabIndex = 10;
            btnFPath.Text = "Найти...";
            btnFPath.UseVisualStyleBackColor = true;
            btnFPath.Click += btnFPath_Click;
            // 
            // txtBoxFPath
            // 
            txtBoxFPath.Location = new Point(84, 16);
            txtBoxFPath.Name = "txtBoxFPath";
            txtBoxFPath.Size = new Size(230, 27);
            txtBoxFPath.TabIndex = 9;
            // 
            // lblFPath
            // 
            lblFPath.AutoSize = true;
            lblFPath.Font = new Font("Segoe UI", 12F, FontStyle.Regular, GraphicsUnit.Point, 204);
            lblFPath.Location = new Point(14, 14);
            lblFPath.Name = "lblFPath";
            lblFPath.Size = new Size(64, 28);
            lblFPath.TabIndex = 7;
            lblFPath.Text = "Файл:";
            // 
            // pnlText
            // 
            pnlText.Controls.Add(txtBoxResText);
            pnlText.Controls.Add(txtBoxProcText);
            pnlText.Location = new Point(423, 12);
            pnlText.Name = "pnlText";
            pnlText.Size = new Size(570, 392);
            pnlText.TabIndex = 10;
            // 
            // txtBoxResText
            // 
            txtBoxResText.BorderStyle = BorderStyle.FixedSingle;
            txtBoxResText.Font = new Font("Segoe UI", 10.2F, FontStyle.Regular, GraphicsUnit.Point, 204);
            txtBoxResText.Location = new Point(3, 205);
            txtBoxResText.Multiline = true;
            txtBoxResText.Name = "txtBoxResText";
            txtBoxResText.ScrollBars = ScrollBars.Vertical;
            txtBoxResText.Size = new Size(564, 180);
            txtBoxResText.TabIndex = 1;
            // 
            // txtBoxProcText
            // 
            txtBoxProcText.BorderStyle = BorderStyle.FixedSingle;
            txtBoxProcText.Font = new Font("Segoe UI", 10.2F, FontStyle.Regular, GraphicsUnit.Point, 204);
            txtBoxProcText.Location = new Point(3, 15);
            txtBoxProcText.Multiline = true;
            txtBoxProcText.Name = "txtBoxProcText";
            txtBoxProcText.ScrollBars = ScrollBars.Vertical;
            txtBoxProcText.Size = new Size(564, 180);
            txtBoxProcText.TabIndex = 0;
            // 
            // txtBoxVigenerKey
            // 
            txtBoxVigenerKey.BorderStyle = BorderStyle.FixedSingle;
            txtBoxVigenerKey.Location = new Point(26, 212);
            txtBoxVigenerKey.Multiline = true;
            txtBoxVigenerKey.Name = "txtBoxVigenerKey";
            txtBoxVigenerKey.ScrollBars = ScrollBars.Vertical;
            txtBoxVigenerKey.Size = new Size(383, 99);
            txtBoxVigenerKey.TabIndex = 11;
            // 
            // MainForm
            // 
            AutoScaleDimensions = new SizeF(8F, 20F);
            AutoScaleMode = AutoScaleMode.Font;
            ClientSize = new Size(1005, 433);
            Controls.Add(txtBoxVigenerKey);
            Controls.Add(pnlText);
            Controls.Add(panel1);
            Controls.Add(statusStrip1);
            Controls.Add(btnStart);
            Controls.Add(pnlKey2);
            Controls.Add(pnlKey1);
            Controls.Add(pnlAct);
            Controls.Add(pnlCriphAlg);
            Name = "MainForm";
            StartPosition = FormStartPosition.CenterScreen;
            Text = "MainForm";
            Load += MainForm_Load;
            pnlCriphAlg.ResumeLayout(false);
            pnlCriphAlg.PerformLayout();
            pnlAct.ResumeLayout(false);
            pnlAct.PerformLayout();
            pnlKey1.ResumeLayout(false);
            pnlKey1.PerformLayout();
            pnlKey2.ResumeLayout(false);
            pnlKey2.PerformLayout();
            statusStrip1.ResumeLayout(false);
            statusStrip1.PerformLayout();
            panel1.ResumeLayout(false);
            panel1.PerformLayout();
            pnlText.ResumeLayout(false);
            pnlText.PerformLayout();
            ResumeLayout(false);
            PerformLayout();
        }

        #endregion

        private Panel pnlCriphAlg;
        private Label lblAlg;
        private RadioButton radBtnVigenere;
        private RadioButton radBtnColumn;
        private Panel pnlAct;
        private Label lblAct;
        private RadioButton radBtnDecrypt;
        private RadioButton radBtnCripher;
        private Panel pnlKey1;
        private Label lblKey1;
        private TextBox txtBoxKey1;
        private Panel pnlKey2;
        private Label lblKey2;
        private TextBox txtBoxKey2;
        private Button btnStart;
        private StatusStrip statusStrip1;
        private ToolStripStatusLabel toolStripStatusLabel1;
        private Panel panel1;
        private Button btnFPath;
        private TextBox txtBoxFPath;
        private Label lblFPath;
        private Panel pnlText;
        private TextBox txtBoxProcText;
        private TextBox txtBoxResText;
        private TextBox txtBoxVigenerKey;
    }
}