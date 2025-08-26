namespace IT_RSA_Lab
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
            pnlPQ = new Panel();
            btnCalcFromPQ = new Button();
            txtBoxQ = new TextBox();
            txtBoxP = new TextBox();
            lblQ = new Label();
            lblP = new Label();
            pnlREuler = new Panel();
            txtBoxEulerF = new TextBox();
            txtBoxR = new TextBox();
            lblEulerF = new Label();
            lblR = new Label();
            pnlD = new Panel();
            btnCalcFromD = new Button();
            txtBoxD = new TextBox();
            lblD = new Label();
            pnlE = new Panel();
            txtBoxE = new TextBox();
            lblE = new Label();
            statusStrip1 = new StatusStrip();
            toolStripStatusLabel1 = new ToolStripStatusLabel();
            toolStripStatusLabel2 = new ToolStripStatusLabel();
            toolStripStatusLabel3 = new ToolStripStatusLabel();
            pnlFilePath = new Panel();
            btnBrowse = new Button();
            txtBoxFilePath = new TextBox();
            lblFilePath = new Label();
            pnlCrypt = new Panel();
            btnCrypt = new Button();
            pnlAction = new Panel();
            rdBtnDecrypt = new RadioButton();
            rdBtnEncrypt = new RadioButton();
            pnlPlaintext = new Panel();
            txtBoxPlaintext = new TextBox();
            pnlCiphertext = new Panel();
            txtBoxCiphertext = new TextBox();
            pnlPQ.SuspendLayout();
            pnlREuler.SuspendLayout();
            pnlD.SuspendLayout();
            pnlE.SuspendLayout();
            statusStrip1.SuspendLayout();
            pnlFilePath.SuspendLayout();
            pnlCrypt.SuspendLayout();
            pnlAction.SuspendLayout();
            pnlPlaintext.SuspendLayout();
            pnlCiphertext.SuspendLayout();
            SuspendLayout();
            // 
            // pnlPQ
            // 
            pnlPQ.Controls.Add(btnCalcFromPQ);
            pnlPQ.Controls.Add(txtBoxQ);
            pnlPQ.Controls.Add(txtBoxP);
            pnlPQ.Controls.Add(lblQ);
            pnlPQ.Controls.Add(lblP);
            pnlPQ.Location = new Point(12, 12);
            pnlPQ.Name = "pnlPQ";
            pnlPQ.Size = new Size(231, 201);
            pnlPQ.TabIndex = 0;
            // 
            // btnCalcFromPQ
            // 
            btnCalcFromPQ.Enabled = false;
            btnCalcFromPQ.Font = new Font("Segoe UI", 10.8F, FontStyle.Regular, GraphicsUnit.Point, 204);
            btnCalcFromPQ.Location = new Point(49, 162);
            btnCalcFromPQ.Name = "btnCalcFromPQ";
            btnCalcFromPQ.Size = new Size(122, 31);
            btnCalcFromPQ.TabIndex = 4;
            btnCalcFromPQ.Text = "Calculate";
            btnCalcFromPQ.TextAlign = ContentAlignment.TopCenter;
            btnCalcFromPQ.UseVisualStyleBackColor = true;
            btnCalcFromPQ.Click += btnCalcFromPQ_Click;
            // 
            // txtBoxQ
            // 
            txtBoxQ.BorderStyle = BorderStyle.FixedSingle;
            txtBoxQ.Font = new Font("Segoe UI", 13.8F, FontStyle.Regular, GraphicsUnit.Point, 204);
            txtBoxQ.Location = new Point(15, 118);
            txtBoxQ.Name = "txtBoxQ";
            txtBoxQ.Size = new Size(194, 38);
            txtBoxQ.TabIndex = 3;
            txtBoxQ.TextChanged += txtBoxQ_TextChanged;
            // 
            // txtBoxP
            // 
            txtBoxP.BorderStyle = BorderStyle.FixedSingle;
            txtBoxP.Font = new Font("Segoe UI", 13.8F, FontStyle.Regular, GraphicsUnit.Point, 204);
            txtBoxP.Location = new Point(15, 43);
            txtBoxP.Name = "txtBoxP";
            txtBoxP.Size = new Size(190, 38);
            txtBoxP.TabIndex = 2;
            txtBoxP.TextChanged += txtBoxP_TextChanged;
            // 
            // lblQ
            // 
            lblQ.AutoSize = true;
            lblQ.Font = new Font("Segoe UI", 13.8F, FontStyle.Regular, GraphicsUnit.Point, 204);
            lblQ.Location = new Point(15, 84);
            lblQ.Name = "lblQ";
            lblQ.Size = new Size(92, 31);
            lblQ.TabIndex = 1;
            lblQ.Text = "Enter q:";
            // 
            // lblP
            // 
            lblP.AutoSize = true;
            lblP.Font = new Font("Segoe UI", 13.8F, FontStyle.Regular, GraphicsUnit.Point, 204);
            lblP.Location = new Point(15, 9);
            lblP.Name = "lblP";
            lblP.Size = new Size(92, 31);
            lblP.TabIndex = 0;
            lblP.Text = "Enter p:";
            // 
            // pnlREuler
            // 
            pnlREuler.Controls.Add(txtBoxEulerF);
            pnlREuler.Controls.Add(txtBoxR);
            pnlREuler.Controls.Add(lblEulerF);
            pnlREuler.Controls.Add(lblR);
            pnlREuler.Location = new Point(12, 219);
            pnlREuler.Name = "pnlREuler";
            pnlREuler.Size = new Size(231, 173);
            pnlREuler.TabIndex = 1;
            // 
            // txtBoxEulerF
            // 
            txtBoxEulerF.BorderStyle = BorderStyle.FixedSingle;
            txtBoxEulerF.Font = new Font("Segoe UI", 13.8F, FontStyle.Regular, GraphicsUnit.Point, 204);
            txtBoxEulerF.Location = new Point(15, 128);
            txtBoxEulerF.Name = "txtBoxEulerF";
            txtBoxEulerF.Size = new Size(190, 38);
            txtBoxEulerF.TabIndex = 5;
            // 
            // txtBoxR
            // 
            txtBoxR.BorderStyle = BorderStyle.FixedSingle;
            txtBoxR.Font = new Font("Segoe UI", 13.8F, FontStyle.Regular, GraphicsUnit.Point, 204);
            txtBoxR.Location = new Point(15, 44);
            txtBoxR.Name = "txtBoxR";
            txtBoxR.Size = new Size(190, 38);
            txtBoxR.TabIndex = 4;
            // 
            // lblEulerF
            // 
            lblEulerF.AutoSize = true;
            lblEulerF.Font = new Font("Segoe UI", 13.8F, FontStyle.Regular, GraphicsUnit.Point, 204);
            lblEulerF.Location = new Point(15, 94);
            lblEulerF.Name = "lblEulerF";
            lblEulerF.Size = new Size(160, 31);
            lblEulerF.TabIndex = 2;
            lblEulerF.Text = "Euler function:";
            // 
            // lblR
            // 
            lblR.AutoSize = true;
            lblR.Font = new Font("Segoe UI", 13.8F, FontStyle.Regular, GraphicsUnit.Point, 204);
            lblR.Location = new Point(15, 10);
            lblR.Name = "lblR";
            lblR.Size = new Size(123, 31);
            lblR.TabIndex = 1;
            lblR.Text = "Number r: ";
            // 
            // pnlD
            // 
            pnlD.Controls.Add(btnCalcFromD);
            pnlD.Controls.Add(txtBoxD);
            pnlD.Controls.Add(lblD);
            pnlD.Location = new Point(12, 398);
            pnlD.Name = "pnlD";
            pnlD.Size = new Size(231, 133);
            pnlD.TabIndex = 2;
            // 
            // btnCalcFromD
            // 
            btnCalcFromD.Enabled = false;
            btnCalcFromD.Font = new Font("Segoe UI", 10.8F, FontStyle.Regular, GraphicsUnit.Point, 204);
            btnCalcFromD.Location = new Point(49, 93);
            btnCalcFromD.Name = "btnCalcFromD";
            btnCalcFromD.Size = new Size(122, 31);
            btnCalcFromD.TabIndex = 7;
            btnCalcFromD.Text = "Calculate";
            btnCalcFromD.TextAlign = ContentAlignment.TopCenter;
            btnCalcFromD.UseVisualStyleBackColor = true;
            btnCalcFromD.Click += btnCalcFromD_Click;
            // 
            // txtBoxD
            // 
            txtBoxD.BorderStyle = BorderStyle.FixedSingle;
            txtBoxD.Font = new Font("Segoe UI", 13.8F, FontStyle.Regular, GraphicsUnit.Point, 204);
            txtBoxD.Location = new Point(15, 45);
            txtBoxD.Name = "txtBoxD";
            txtBoxD.Size = new Size(190, 38);
            txtBoxD.TabIndex = 6;
            txtBoxD.TextChanged += txtBoxD_TextChanged;
            // 
            // lblD
            // 
            lblD.AutoSize = true;
            lblD.Font = new Font("Segoe UI", 13.8F, FontStyle.Regular, GraphicsUnit.Point, 204);
            lblD.Location = new Point(11, 11);
            lblD.Name = "lblD";
            lblD.Size = new Size(209, 31);
            lblD.TabIndex = 5;
            lblD.Text = "Enter private key d:";
            // 
            // pnlE
            // 
            pnlE.Controls.Add(txtBoxE);
            pnlE.Controls.Add(lblE);
            pnlE.Location = new Point(12, 537);
            pnlE.Name = "pnlE";
            pnlE.Size = new Size(231, 97);
            pnlE.TabIndex = 3;
            // 
            // txtBoxE
            // 
            txtBoxE.BorderStyle = BorderStyle.FixedSingle;
            txtBoxE.Font = new Font("Segoe UI", 13.8F, FontStyle.Regular, GraphicsUnit.Point, 204);
            txtBoxE.Location = new Point(15, 44);
            txtBoxE.Name = "txtBoxE";
            txtBoxE.Size = new Size(190, 38);
            txtBoxE.TabIndex = 5;
            // 
            // lblE
            // 
            lblE.AutoSize = true;
            lblE.Font = new Font("Segoe UI", 13.8F, FontStyle.Regular, GraphicsUnit.Point, 204);
            lblE.Location = new Point(15, 10);
            lblE.Name = "lblE";
            lblE.Size = new Size(140, 31);
            lblE.TabIndex = 2;
            lblE.Text = "Public key e:";
            // 
            // statusStrip1
            // 
            statusStrip1.ImageScalingSize = new Size(20, 20);
            statusStrip1.Items.AddRange(new ToolStripItem[] { toolStripStatusLabel1, toolStripStatusLabel2, toolStripStatusLabel3 });
            statusStrip1.Location = new Point(0, 645);
            statusStrip1.Name = "statusStrip1";
            statusStrip1.Size = new Size(1172, 26);
            statusStrip1.TabIndex = 4;
            statusStrip1.Text = "statusStrip1";
            // 
            // toolStripStatusLabel1
            // 
            toolStripStatusLabel1.Name = "toolStripStatusLabel1";
            toolStripStatusLabel1.Size = new Size(0, 20);
            // 
            // toolStripStatusLabel2
            // 
            toolStripStatusLabel2.Name = "toolStripStatusLabel2";
            toolStripStatusLabel2.Size = new Size(0, 20);
            // 
            // toolStripStatusLabel3
            // 
            toolStripStatusLabel3.Name = "toolStripStatusLabel3";
            toolStripStatusLabel3.Size = new Size(13, 20);
            toolStripStatusLabel3.Text = " ";
            // 
            // pnlFilePath
            // 
            pnlFilePath.Anchor = AnchorStyles.Bottom | AnchorStyles.Left;
            pnlFilePath.Controls.Add(btnBrowse);
            pnlFilePath.Controls.Add(txtBoxFilePath);
            pnlFilePath.Controls.Add(lblFilePath);
            pnlFilePath.Location = new Point(249, 570);
            pnlFilePath.Name = "pnlFilePath";
            pnlFilePath.Size = new Size(619, 64);
            pnlFilePath.TabIndex = 5;
            // 
            // btnBrowse
            // 
            btnBrowse.Font = new Font("Segoe UI", 10.8F, FontStyle.Regular, GraphicsUnit.Point, 204);
            btnBrowse.Location = new Point(519, 11);
            btnBrowse.Name = "btnBrowse";
            btnBrowse.Size = new Size(93, 38);
            btnBrowse.TabIndex = 8;
            btnBrowse.Text = "Browse...";
            btnBrowse.TextAlign = ContentAlignment.TopCenter;
            btnBrowse.UseVisualStyleBackColor = true;
            btnBrowse.Click += button1_Click;
            // 
            // txtBoxFilePath
            // 
            txtBoxFilePath.BorderStyle = BorderStyle.FixedSingle;
            txtBoxFilePath.Font = new Font("Segoe UI", 13.8F, FontStyle.Regular, GraphicsUnit.Point, 204);
            txtBoxFilePath.Location = new Point(197, 11);
            txtBoxFilePath.Name = "txtBoxFilePath";
            txtBoxFilePath.Size = new Size(316, 38);
            txtBoxFilePath.TabIndex = 6;
            // 
            // lblFilePath
            // 
            lblFilePath.AutoSize = true;
            lblFilePath.Font = new Font("Segoe UI", 13.8F, FontStyle.Regular, GraphicsUnit.Point, 204);
            lblFilePath.Location = new Point(3, 13);
            lblFilePath.Name = "lblFilePath";
            lblFilePath.Size = new Size(188, 31);
            lblFilePath.TabIndex = 3;
            lblFilePath.Text = "Enter path of file:";
            // 
            // pnlCrypt
            // 
            pnlCrypt.Controls.Add(btnCrypt);
            pnlCrypt.Controls.Add(pnlAction);
            pnlCrypt.Location = new Point(874, 570);
            pnlCrypt.Name = "pnlCrypt";
            pnlCrypt.Size = new Size(286, 64);
            pnlCrypt.TabIndex = 6;
            // 
            // btnCrypt
            // 
            btnCrypt.Enabled = false;
            btnCrypt.Font = new Font("Segoe UI", 10.8F, FontStyle.Regular, GraphicsUnit.Point, 204);
            btnCrypt.Location = new Point(3, 13);
            btnCrypt.Name = "btnCrypt";
            btnCrypt.Size = new Size(130, 36);
            btnCrypt.TabIndex = 9;
            btnCrypt.Text = "Select action";
            btnCrypt.TextAlign = ContentAlignment.TopCenter;
            btnCrypt.UseVisualStyleBackColor = true;
            btnCrypt.Click += btnCrypt_Click;
            // 
            // pnlAction
            // 
            pnlAction.Controls.Add(rdBtnDecrypt);
            pnlAction.Controls.Add(rdBtnEncrypt);
            pnlAction.Location = new Point(139, 0);
            pnlAction.Name = "pnlAction";
            pnlAction.Size = new Size(93, 64);
            pnlAction.TabIndex = 1;
            // 
            // rdBtnDecrypt
            // 
            rdBtnDecrypt.AutoSize = true;
            rdBtnDecrypt.Enabled = false;
            rdBtnDecrypt.Location = new Point(7, 35);
            rdBtnDecrypt.Name = "rdBtnDecrypt";
            rdBtnDecrypt.Size = new Size(82, 24);
            rdBtnDecrypt.TabIndex = 1;
            rdBtnDecrypt.TabStop = true;
            rdBtnDecrypt.Text = "Decrypt";
            rdBtnDecrypt.UseVisualStyleBackColor = true;
            rdBtnDecrypt.CheckedChanged += rdBtnDecrypt_CheckedChanged;
            // 
            // rdBtnEncrypt
            // 
            rdBtnEncrypt.AutoSize = true;
            rdBtnEncrypt.Enabled = false;
            rdBtnEncrypt.Location = new Point(7, 7);
            rdBtnEncrypt.Name = "rdBtnEncrypt";
            rdBtnEncrypt.Size = new Size(79, 24);
            rdBtnEncrypt.TabIndex = 0;
            rdBtnEncrypt.TabStop = true;
            rdBtnEncrypt.Text = "Encrypt";
            rdBtnEncrypt.UseVisualStyleBackColor = true;
            rdBtnEncrypt.CheckedChanged += rdBtnEncrypt_CheckedChanged;
            // 
            // pnlPlaintext
            // 
            pnlPlaintext.Controls.Add(txtBoxPlaintext);
            pnlPlaintext.Location = new Point(257, 12);
            pnlPlaintext.Name = "pnlPlaintext";
            pnlPlaintext.Size = new Size(903, 268);
            pnlPlaintext.TabIndex = 7;
            // 
            // txtBoxPlaintext
            // 
            txtBoxPlaintext.BorderStyle = BorderStyle.FixedSingle;
            txtBoxPlaintext.Location = new Point(3, 9);
            txtBoxPlaintext.Multiline = true;
            txtBoxPlaintext.Name = "txtBoxPlaintext";
            txtBoxPlaintext.ScrollBars = ScrollBars.Vertical;
            txtBoxPlaintext.Size = new Size(892, 256);
            txtBoxPlaintext.TabIndex = 0;
            txtBoxPlaintext.TextChanged += textBox1_TextChanged;
            // 
            // pnlCiphertext
            // 
            pnlCiphertext.Controls.Add(txtBoxCiphertext);
            pnlCiphertext.Location = new Point(257, 286);
            pnlCiphertext.Name = "pnlCiphertext";
            pnlCiphertext.Size = new Size(903, 268);
            pnlCiphertext.TabIndex = 8;
            // 
            // txtBoxCiphertext
            // 
            txtBoxCiphertext.BorderStyle = BorderStyle.FixedSingle;
            txtBoxCiphertext.Location = new Point(3, 9);
            txtBoxCiphertext.Multiline = true;
            txtBoxCiphertext.Name = "txtBoxCiphertext";
            txtBoxCiphertext.ScrollBars = ScrollBars.Vertical;
            txtBoxCiphertext.Size = new Size(892, 256);
            txtBoxCiphertext.TabIndex = 1;
            // 
            // Form1
            // 
            AutoScaleDimensions = new SizeF(8F, 20F);
            AutoScaleMode = AutoScaleMode.Font;
            ClientSize = new Size(1172, 671);
            Controls.Add(pnlCiphertext);
            Controls.Add(pnlPlaintext);
            Controls.Add(pnlCrypt);
            Controls.Add(pnlFilePath);
            Controls.Add(statusStrip1);
            Controls.Add(pnlE);
            Controls.Add(pnlD);
            Controls.Add(pnlREuler);
            Controls.Add(pnlPQ);
            Name = "Form1";
            Text = "Form1";
            pnlPQ.ResumeLayout(false);
            pnlPQ.PerformLayout();
            pnlREuler.ResumeLayout(false);
            pnlREuler.PerformLayout();
            pnlD.ResumeLayout(false);
            pnlD.PerformLayout();
            pnlE.ResumeLayout(false);
            pnlE.PerformLayout();
            statusStrip1.ResumeLayout(false);
            statusStrip1.PerformLayout();
            pnlFilePath.ResumeLayout(false);
            pnlFilePath.PerformLayout();
            pnlCrypt.ResumeLayout(false);
            pnlAction.ResumeLayout(false);
            pnlAction.PerformLayout();
            pnlPlaintext.ResumeLayout(false);
            pnlPlaintext.PerformLayout();
            pnlCiphertext.ResumeLayout(false);
            pnlCiphertext.PerformLayout();
            ResumeLayout(false);
            PerformLayout();
        }

        #endregion

        private Panel pnlPQ;
        private Label lblQ;
        private Label lblP;
        private TextBox txtBoxQ;
        private TextBox txtBoxP;
        private Panel pnlREuler;
        private Label lblEulerF;
        private Label lblR;
        private TextBox txtBoxR;
        private TextBox txtBoxEulerF;
        private Button btnCalcFromPQ;
        private Panel pnlD;
        private Button btnCalcFromD;
        private TextBox txtBoxD;
        private Label lblD;
        private Panel pnlE;
        private TextBox txtBoxE;
        private Label lblE;
        private StatusStrip statusStrip1;
        private ToolStripStatusLabel toolStripStatusLabel1;
        private ToolStripStatusLabel toolStripStatusLabel2;
        private ToolStripStatusLabel toolStripStatusLabel3;
        private Panel pnlFilePath;
        private Button btnBrowse;
        private TextBox txtBoxFilePath;
        private Label lblFilePath;
        private Panel pnlCrypt;
        private Button btnCrypt;
        private Panel pnlAction;
        private RadioButton rdBtnDecrypt;
        private RadioButton rdBtnEncrypt;
        private Panel pnlPlaintext;
        private TextBox txtBoxPlaintext;
        private Panel pnlCiphertext;
        private TextBox txtBoxCiphertext;
    }
}
