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
            pnlSourceFields = new Panel();
            btnFileBrowse = new Button();
            txtBoxFilePath = new TextBox();
            lblFilePath = new Label();
            txtBoxPolynom = new TextBox();
            txtBoxStartReg = new TextBox();
            lblPolynom = new Label();
            lblStartReg = new Label();
            pnlMakeCalc = new Panel();
            radBtnDecr = new RadioButton();
            radBtnEncr = new RadioButton();
            btnMakeCalc = new Button();
            pnlGenKey = new Panel();
            btnGenKey = new Button();
            txtBoxGenKey = new TextBox();
            lblGenKey = new Label();
            pnlResFields = new Panel();
            label2 = new Label();
            label1 = new Label();
            txtBoxSourceFile = new TextBox();
            txtBoxResFile = new TextBox();
            pnlKeyIter = new Panel();
            txtBoxKeyIter = new TextBox();
            pnlSourceFields.SuspendLayout();
            pnlMakeCalc.SuspendLayout();
            pnlGenKey.SuspendLayout();
            pnlResFields.SuspendLayout();
            pnlKeyIter.SuspendLayout();
            SuspendLayout();
            // 
            // pnlSourceFields
            // 
            pnlSourceFields.Controls.Add(btnFileBrowse);
            pnlSourceFields.Controls.Add(txtBoxFilePath);
            pnlSourceFields.Controls.Add(lblFilePath);
            pnlSourceFields.Controls.Add(txtBoxPolynom);
            pnlSourceFields.Controls.Add(txtBoxStartReg);
            pnlSourceFields.Controls.Add(lblPolynom);
            pnlSourceFields.Controls.Add(lblStartReg);
            pnlSourceFields.Location = new Point(2, 3);
            pnlSourceFields.Name = "pnlSourceFields";
            pnlSourceFields.Size = new Size(739, 154);
            pnlSourceFields.TabIndex = 0;
            // 
            // btnFileBrowse
            // 
            btnFileBrowse.Location = new Point(604, 118);
            btnFileBrowse.Name = "btnFileBrowse";
            btnFileBrowse.Size = new Size(98, 31);
            btnFileBrowse.TabIndex = 11;
            btnFileBrowse.Text = "browse...";
            btnFileBrowse.UseVisualStyleBackColor = true;
            btnFileBrowse.Click += btnFileBrowse_Click;
            // 
            // txtBoxFilePath
            // 
            txtBoxFilePath.Location = new Point(250, 122);
            txtBoxFilePath.Name = "txtBoxFilePath";
            txtBoxFilePath.Size = new Size(348, 27);
            txtBoxFilePath.TabIndex = 10;
            txtBoxFilePath.Text = "D:\\\\Asus Tuf Gaming A15\\\\Different\\\\Учёба\\\\ТИ\\\\2\\\\Files\\\\SourceFiles\\\\Text.txt";
            txtBoxFilePath.TextChanged += txtBoxFilePath_TextChanged;
            // 
            // lblFilePath
            // 
            lblFilePath.AutoSize = true;
            lblFilePath.Font = new Font("Segoe UI", 12F, FontStyle.Regular, GraphicsUnit.Point, 204);
            lblFilePath.Location = new Point(17, 118);
            lblFilePath.Name = "lblFilePath";
            lblFilePath.Size = new Size(227, 28);
            lblFilePath.TabIndex = 9;
            lblFilePath.Text = "Enter the path to the file:";
            // 
            // txtBoxPolynom
            // 
            txtBoxPolynom.Location = new Point(354, 70);
            txtBoxPolynom.Name = "txtBoxPolynom";
            txtBoxPolynom.Size = new Size(348, 27);
            txtBoxPolynom.TabIndex = 4;
            txtBoxPolynom.Text = "x^33+x^13+1";
            // 
            // txtBoxStartReg
            // 
            txtBoxStartReg.Location = new Point(354, 26);
            txtBoxStartReg.Name = "txtBoxStartReg";
            txtBoxStartReg.Size = new Size(348, 27);
            txtBoxStartReg.TabIndex = 3;
            txtBoxStartReg.Text = "111111111111111111111111111111111";
            // 
            // lblPolynom
            // 
            lblPolynom.AutoSize = true;
            lblPolynom.Font = new Font("Segoe UI", 12F, FontStyle.Regular, GraphicsUnit.Point, 204);
            lblPolynom.Location = new Point(17, 66);
            lblPolynom.Name = "lblPolynom";
            lblPolynom.Size = new Size(322, 28);
            lblPolynom.TabIndex = 1;
            lblPolynom.Text = "Enter the characteristic polynomial: ";
            // 
            // lblStartReg
            // 
            lblStartReg.AutoSize = true;
            lblStartReg.Font = new Font("Segoe UI", 12F, FontStyle.Regular, GraphicsUnit.Point, 204);
            lblStartReg.Location = new Point(17, 22);
            lblStartReg.Name = "lblStartReg";
            lblStartReg.Size = new Size(321, 28);
            lblStartReg.TabIndex = 0;
            lblStartReg.Text = "Enter the initial state of the register:";
            // 
            // pnlMakeCalc
            // 
            pnlMakeCalc.Controls.Add(radBtnDecr);
            pnlMakeCalc.Controls.Add(radBtnEncr);
            pnlMakeCalc.Controls.Add(btnMakeCalc);
            pnlMakeCalc.Location = new Point(310, 10);
            pnlMakeCalc.Name = "pnlMakeCalc";
            pnlMakeCalc.Size = new Size(392, 34);
            pnlMakeCalc.TabIndex = 12;
            // 
            // radBtnDecr
            // 
            radBtnDecr.AutoSize = true;
            radBtnDecr.Font = new Font("Segoe UI", 10.8F, FontStyle.Regular, GraphicsUnit.Point, 204);
            radBtnDecr.Location = new Point(124, 2);
            radBtnDecr.Name = "radBtnDecr";
            radBtnDecr.Size = new Size(95, 29);
            radBtnDecr.TabIndex = 1;
            radBtnDecr.Text = "Decrypt";
            radBtnDecr.UseVisualStyleBackColor = true;
            radBtnDecr.CheckedChanged += radBtnDecr_CheckedChanged;
            // 
            // radBtnEncr
            // 
            radBtnEncr.AutoSize = true;
            radBtnEncr.Font = new Font("Segoe UI", 10.8F, FontStyle.Regular, GraphicsUnit.Point, 204);
            radBtnEncr.Location = new Point(26, 2);
            radBtnEncr.Name = "radBtnEncr";
            radBtnEncr.Size = new Size(92, 29);
            radBtnEncr.TabIndex = 0;
            radBtnEncr.Text = "Encrypt";
            radBtnEncr.UseVisualStyleBackColor = true;
            radBtnEncr.CheckedChanged += radBtnEncr_CheckedChanged;
            // 
            // btnMakeCalc
            // 
            btnMakeCalc.Font = new Font("Segoe UI", 10.8F, FontStyle.Regular, GraphicsUnit.Point, 204);
            btnMakeCalc.Location = new Point(223, 0);
            btnMakeCalc.Name = "btnMakeCalc";
            btnMakeCalc.Size = new Size(166, 32);
            btnMakeCalc.TabIndex = 7;
            btnMakeCalc.Text = "Make a calculation";
            btnMakeCalc.UseVisualStyleBackColor = true;
            btnMakeCalc.Click += btnMakeCalc_Click;
            // 
            // pnlGenKey
            // 
            pnlGenKey.Controls.Add(pnlMakeCalc);
            pnlGenKey.Controls.Add(btnGenKey);
            pnlGenKey.Controls.Add(txtBoxGenKey);
            pnlGenKey.Controls.Add(lblGenKey);
            pnlGenKey.Location = new Point(2, 158);
            pnlGenKey.Name = "pnlGenKey";
            pnlGenKey.Size = new Size(739, 204);
            pnlGenKey.TabIndex = 8;
            // 
            // btnGenKey
            // 
            btnGenKey.Font = new Font("Segoe UI", 10.8F);
            btnGenKey.Location = new Point(163, 9);
            btnGenKey.Name = "btnGenKey";
            btnGenKey.Size = new Size(141, 35);
            btnGenKey.TabIndex = 11;
            btnGenKey.Text = "Generate a key";
            btnGenKey.TextAlign = ContentAlignment.TopCenter;
            btnGenKey.UseVisualStyleBackColor = true;
            btnGenKey.Click += btnGenKey_Click;
            // 
            // txtBoxGenKey
            // 
            txtBoxGenKey.BorderStyle = BorderStyle.FixedSingle;
            txtBoxGenKey.Font = new Font("Segoe UI", 12F, FontStyle.Regular, GraphicsUnit.Point, 204);
            txtBoxGenKey.Location = new Point(14, 47);
            txtBoxGenKey.Multiline = true;
            txtBoxGenKey.Name = "txtBoxGenKey";
            txtBoxGenKey.ScrollBars = ScrollBars.Vertical;
            txtBoxGenKey.Size = new Size(688, 151);
            txtBoxGenKey.TabIndex = 10;
            // 
            // lblGenKey
            // 
            lblGenKey.AutoSize = true;
            lblGenKey.Font = new Font("Segoe UI", 12F, FontStyle.Regular, GraphicsUnit.Point, 204);
            lblGenKey.Location = new Point(17, 10);
            lblGenKey.Name = "lblGenKey";
            lblGenKey.Size = new Size(142, 28);
            lblGenKey.TabIndex = 9;
            lblGenKey.Text = "Generated key:";
            // 
            // pnlResFields
            // 
            pnlResFields.Controls.Add(label2);
            pnlResFields.Controls.Add(label1);
            pnlResFields.Controls.Add(txtBoxSourceFile);
            pnlResFields.Controls.Add(txtBoxResFile);
            pnlResFields.Location = new Point(2, 362);
            pnlResFields.Name = "pnlResFields";
            pnlResFields.Size = new Size(739, 370);
            pnlResFields.TabIndex = 1;
            // 
            // label2
            // 
            label2.Anchor = AnchorStyles.Bottom | AnchorStyles.Left;
            label2.AutoSize = true;
            label2.Font = new Font("Segoe UI", 12F, FontStyle.Regular, GraphicsUnit.Point, 204);
            label2.Location = new Point(14, 179);
            label2.Name = "label2";
            label2.Size = new Size(104, 28);
            label2.TabIndex = 11;
            label2.Text = "Encrypted:";
            // 
            // label1
            // 
            label1.AutoSize = true;
            label1.Font = new Font("Segoe UI", 12F, FontStyle.Regular, GraphicsUnit.Point, 204);
            label1.Location = new Point(14, 0);
            label1.Name = "label1";
            label1.Size = new Size(91, 28);
            label1.TabIndex = 10;
            label1.Text = "Plaintext:";
            // 
            // txtBoxSourceFile
            // 
            txtBoxSourceFile.BorderStyle = BorderStyle.FixedSingle;
            txtBoxSourceFile.Font = new Font("Segoe UI", 12F, FontStyle.Regular, GraphicsUnit.Point, 204);
            txtBoxSourceFile.Location = new Point(14, 31);
            txtBoxSourceFile.Multiline = true;
            txtBoxSourceFile.Name = "txtBoxSourceFile";
            txtBoxSourceFile.ScrollBars = ScrollBars.Vertical;
            txtBoxSourceFile.Size = new Size(688, 145);
            txtBoxSourceFile.TabIndex = 3;
            // 
            // txtBoxResFile
            // 
            txtBoxResFile.Anchor = AnchorStyles.Bottom | AnchorStyles.Left;
            txtBoxResFile.BorderStyle = BorderStyle.FixedSingle;
            txtBoxResFile.Font = new Font("Segoe UI", 12F, FontStyle.Regular, GraphicsUnit.Point, 204);
            txtBoxResFile.Location = new Point(14, 210);
            txtBoxResFile.Multiline = true;
            txtBoxResFile.Name = "txtBoxResFile";
            txtBoxResFile.ScrollBars = ScrollBars.Vertical;
            txtBoxResFile.Size = new Size(688, 157);
            txtBoxResFile.TabIndex = 4;
            // 
            // pnlKeyIter
            // 
            pnlKeyIter.Controls.Add(txtBoxKeyIter);
            pnlKeyIter.Location = new Point(2, 738);
            pnlKeyIter.Name = "pnlKeyIter";
            pnlKeyIter.Size = new Size(739, 217);
            pnlKeyIter.TabIndex = 9;
            // 
            // txtBoxKeyIter
            // 
            txtBoxKeyIter.Location = new Point(14, 3);
            txtBoxKeyIter.Multiline = true;
            txtBoxKeyIter.Name = "txtBoxKeyIter";
            txtBoxKeyIter.ScrollBars = ScrollBars.Vertical;
            txtBoxKeyIter.Size = new Size(688, 211);
            txtBoxKeyIter.TabIndex = 0;
            // 
            // Form1
            // 
            AutoScaleDimensions = new SizeF(8F, 20F);
            AutoScaleMode = AutoScaleMode.Font;
            ClientSize = new Size(744, 962);
            Controls.Add(pnlKeyIter);
            Controls.Add(pnlGenKey);
            Controls.Add(pnlResFields);
            Controls.Add(pnlSourceFields);
            Name = "Form1";
            Text = "Form1";
            pnlSourceFields.ResumeLayout(false);
            pnlSourceFields.PerformLayout();
            pnlMakeCalc.ResumeLayout(false);
            pnlMakeCalc.PerformLayout();
            pnlGenKey.ResumeLayout(false);
            pnlGenKey.PerformLayout();
            pnlResFields.ResumeLayout(false);
            pnlResFields.PerformLayout();
            pnlKeyIter.ResumeLayout(false);
            pnlKeyIter.PerformLayout();
            ResumeLayout(false);
        }

        #endregion

        private Panel pnlSourceFields;
        private Label lblStartReg;
        private TextBox txtBoxStartReg;
        private Label lblPolynom;
        private Panel pnlResFields;
        private TextBox txtBoxResFile;
        private TextBox txtBoxSourceFile;
        private TextBox txtBoxPolynom;
        private Panel pnlGenKey;
        private Button btnGenKey;
        private TextBox txtBoxGenKey;
        private Label lblGenKey;
        private Button btnMakeCalc;
        private Label lblFilePath;
        private Button btnFileBrowse;
        private TextBox txtBoxFilePath;
        private Panel pnlMakeCalc;
        private RadioButton radBtnDecr;
        private RadioButton radBtnEncr;
        private Panel pnlKeyIter;
        private TextBox txtBoxKeyIter;
        private Label label1;
        private Label label2;
    }
}
