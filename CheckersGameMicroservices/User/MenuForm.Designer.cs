namespace Checkers
{
    partial class MenuForm
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
            lblGame = new Label();
            pictureBoxLogo = new PictureBox();
            btnPlay = new Button();
            btnSettings = new Button();
            pnlIP = new Panel();
            lblIP = new Label();
            txtBoxIP = new TextBox();
            btnApply = new Button();
            pnlPort = new Panel();
            numUpDownPort = new NumericUpDown();
            lblPort = new Label();
            pnlMode = new Panel();
            lblMode = new Label();
            radBtnModeAuto = new RadioButton();
            radBtnModeManual = new RadioButton();
            pnlSettings = new Panel();
            btnExit = new Button();
            ((System.ComponentModel.ISupportInitialize)pictureBoxLogo).BeginInit();
            pnlIP.SuspendLayout();
            pnlPort.SuspendLayout();
            ((System.ComponentModel.ISupportInitialize)numUpDownPort).BeginInit();
            pnlMode.SuspendLayout();
            pnlSettings.SuspendLayout();
            SuspendLayout();
            // 
            // lblGame
            // 
            lblGame.AutoSize = true;
            lblGame.Font = new Font("Segoe UI Black", 36F, FontStyle.Bold, GraphicsUnit.Point, 204);
            lblGame.Location = new Point(103, 23);
            lblGame.Name = "lblGame";
            lblGame.Size = new Size(299, 81);
            lblGame.TabIndex = 5;
            lblGame.Text = "Checkers";
            // 
            // pictureBoxLogo
            // 
            pictureBoxLogo.Location = new Point(66, 43);
            pictureBoxLogo.Name = "pictureBoxLogo";
            pictureBoxLogo.Size = new Size(50, 50);
            pictureBoxLogo.TabIndex = 8;
            pictureBoxLogo.TabStop = false;
            // 
            // btnPlay
            // 
            btnPlay.Anchor = AnchorStyles.Top;
            btnPlay.Font = new Font("Segoe UI", 18F, FontStyle.Regular, GraphicsUnit.Point, 204);
            btnPlay.ImageAlign = ContentAlignment.TopCenter;
            btnPlay.Location = new Point(17, 130);
            btnPlay.Name = "btnPlay";
            btnPlay.Size = new Size(449, 52);
            btnPlay.TabIndex = 12;
            btnPlay.Text = "Начать игру";
            btnPlay.TextAlign = ContentAlignment.TopCenter;
            btnPlay.UseVisualStyleBackColor = true;
            btnPlay.Click += btnPlay_Click;
            // 
            // btnSettings
            // 
            btnSettings.Anchor = AnchorStyles.Top;
            btnSettings.Font = new Font("Segoe UI", 18F, FontStyle.Regular, GraphicsUnit.Point, 204);
            btnSettings.ImageAlign = ContentAlignment.TopCenter;
            btnSettings.Location = new Point(17, 199);
            btnSettings.Name = "btnSettings";
            btnSettings.Size = new Size(449, 52);
            btnSettings.TabIndex = 14;
            btnSettings.Text = "Настройка соединения";
            btnSettings.TextAlign = ContentAlignment.TopCenter;
            btnSettings.UseVisualStyleBackColor = true;
            btnSettings.Click += btnSettings_Click;
            // 
            // pnlIP
            // 
            pnlIP.Controls.Add(lblIP);
            pnlIP.Controls.Add(txtBoxIP);
            pnlIP.Location = new Point(3, 0);
            pnlIP.Name = "pnlIP";
            pnlIP.Size = new Size(255, 45);
            pnlIP.TabIndex = 17;
            // 
            // lblIP
            // 
            lblIP.AutoSize = true;
            lblIP.Font = new Font("Segoe UI", 13.8F, FontStyle.Regular, GraphicsUnit.Point, 204);
            lblIP.Location = new Point(3, 6);
            lblIP.Name = "lblIP";
            lblIP.Size = new Size(104, 31);
            lblIP.TabIndex = 2;
            lblIP.Text = "IP-адрес";
            // 
            // txtBoxIP
            // 
            txtBoxIP.Enabled = false;
            txtBoxIP.Font = new Font("Segoe UI", 13.8F, FontStyle.Regular, GraphicsUnit.Point, 204);
            txtBoxIP.Location = new Point(111, 3);
            txtBoxIP.Name = "txtBoxIP";
            txtBoxIP.Size = new Size(127, 38);
            txtBoxIP.TabIndex = 1;
            txtBoxIP.Text = "127.0.0.1";
            // 
            // btnApply
            // 
            btnApply.Font = new Font("Segoe UI", 18F, FontStyle.Regular, GraphicsUnit.Point, 204);
            btnApply.ImageAlign = ContentAlignment.TopCenter;
            btnApply.Location = new Point(0, 144);
            btnApply.Name = "btnApply";
            btnApply.Size = new Size(449, 52);
            btnApply.TabIndex = 16;
            btnApply.Text = "Применить настройки";
            btnApply.TextAlign = ContentAlignment.TopCenter;
            btnApply.UseVisualStyleBackColor = true;
            btnApply.Click += btnApply_Click;
            // 
            // pnlPort
            // 
            pnlPort.Controls.Add(numUpDownPort);
            pnlPort.Controls.Add(lblPort);
            pnlPort.Location = new Point(3, 63);
            pnlPort.Name = "pnlPort";
            pnlPort.Size = new Size(255, 50);
            pnlPort.TabIndex = 15;
            // 
            // numUpDownPort
            // 
            numUpDownPort.Enabled = false;
            numUpDownPort.Font = new Font("Segoe UI", 13.8F, FontStyle.Regular, GraphicsUnit.Point, 204);
            numUpDownPort.Location = new Point(111, 5);
            numUpDownPort.Maximum = new decimal(new int[] { 65536, 0, 0, 0 });
            numUpDownPort.Name = "numUpDownPort";
            numUpDownPort.Size = new Size(127, 38);
            numUpDownPort.TabIndex = 3;
            numUpDownPort.Value = new decimal(new int[] { 5555, 0, 0, 0 });
            // 
            // lblPort
            // 
            lblPort.AutoSize = true;
            lblPort.Font = new Font("Segoe UI", 13.8F, FontStyle.Regular, GraphicsUnit.Point, 204);
            lblPort.Location = new Point(15, 7);
            lblPort.Name = "lblPort";
            lblPort.Size = new Size(66, 31);
            lblPort.TabIndex = 2;
            lblPort.Text = "Порт";
            // 
            // pnlMode
            // 
            pnlMode.Controls.Add(lblMode);
            pnlMode.Controls.Add(radBtnModeAuto);
            pnlMode.Controls.Add(radBtnModeManual);
            pnlMode.Location = new Point(285, 0);
            pnlMode.Name = "pnlMode";
            pnlMode.Size = new Size(152, 95);
            pnlMode.TabIndex = 14;
            // 
            // lblMode
            // 
            lblMode.AutoSize = true;
            lblMode.Font = new Font("Segoe UI", 12F, FontStyle.Regular, GraphicsUnit.Point, 204);
            lblMode.Location = new Point(35, 6);
            lblMode.Name = "lblMode";
            lblMode.Size = new Size(74, 28);
            lblMode.TabIndex = 10;
            lblMode.Text = "Режим";
            // 
            // radBtnModeAuto
            // 
            radBtnModeAuto.AutoSize = true;
            radBtnModeAuto.Checked = true;
            radBtnModeAuto.Location = new Point(4, 40);
            radBtnModeAuto.Name = "radBtnModeAuto";
            radBtnModeAuto.Size = new Size(145, 24);
            radBtnModeAuto.TabIndex = 9;
            radBtnModeAuto.TabStop = true;
            radBtnModeAuto.Text = "Автоматический";
            radBtnModeAuto.UseVisualStyleBackColor = true;
            radBtnModeAuto.CheckedChanged += radBtnModeAuto_CheckedChanged;
            // 
            // radBtnModeManual
            // 
            radBtnModeManual.AutoSize = true;
            radBtnModeManual.Location = new Point(3, 70);
            radBtnModeManual.Name = "radBtnModeManual";
            radBtnModeManual.Size = new Size(80, 24);
            radBtnModeManual.TabIndex = 0;
            radBtnModeManual.Text = "Ручной";
            radBtnModeManual.UseVisualStyleBackColor = true;
            radBtnModeManual.CheckedChanged += radBtnModeManual_CheckedChanged;
            // 
            // pnlSettings
            // 
            pnlSettings.Controls.Add(btnApply);
            pnlSettings.Controls.Add(pnlMode);
            pnlSettings.Controls.Add(pnlPort);
            pnlSettings.Controls.Add(pnlIP);
            pnlSettings.Location = new Point(17, 273);
            pnlSettings.Name = "pnlSettings";
            pnlSettings.Size = new Size(449, 217);
            pnlSettings.TabIndex = 18;
            pnlSettings.Visible = false;
            // 
            // btnExit
            // 
            btnExit.Anchor = AnchorStyles.Bottom;
            btnExit.Font = new Font("Segoe UI", 18F, FontStyle.Regular, GraphicsUnit.Point, 204);
            btnExit.ImageAlign = ContentAlignment.TopCenter;
            btnExit.Location = new Point(17, 269);
            btnExit.Name = "btnExit";
            btnExit.Size = new Size(449, 52);
            btnExit.TabIndex = 20;
            btnExit.Text = "Выйти";
            btnExit.TextAlign = ContentAlignment.TopCenter;
            btnExit.UseVisualStyleBackColor = true;
            btnExit.Click += btnExit_Click_1;
            // 
            // MenuForm
            // 
            AutoScaleDimensions = new SizeF(8F, 20F);
            AutoScaleMode = AutoScaleMode.Font;
            BackColor = SystemColors.ActiveCaption;
            ClientSize = new Size(483, 333);
            Controls.Add(btnExit);
            Controls.Add(btnSettings);
            Controls.Add(pnlSettings);
            Controls.Add(btnPlay);
            Controls.Add(pictureBoxLogo);
            Controls.Add(lblGame);
            Name = "MenuForm";
            StartPosition = FormStartPosition.Manual;
            Text = "Menu";
            ((System.ComponentModel.ISupportInitialize)pictureBoxLogo).EndInit();
            pnlIP.ResumeLayout(false);
            pnlIP.PerformLayout();
            pnlPort.ResumeLayout(false);
            pnlPort.PerformLayout();
            ((System.ComponentModel.ISupportInitialize)numUpDownPort).EndInit();
            pnlMode.ResumeLayout(false);
            pnlMode.PerformLayout();
            pnlSettings.ResumeLayout(false);
            ResumeLayout(false);
            PerformLayout();
        }

        #endregion
        private Label lblGame;
        private PictureBox pictureBoxLogo;
        private Button btnPlay;
        private Button btnSettings;
        private Panel pnlIP;
        private Label lblIP;
        private TextBox txtBoxIP;
        private Button btnApply;
        private Panel pnlPort;
        private NumericUpDown numUpDownPort;
        private Label lblPort;
        private Panel pnlMode;
        private Label lblMode;
        private RadioButton radBtnModeAuto;
        private RadioButton radBtnModeManual;
        private Panel pnlSettings;
        private Button btnExit;
        private Button button1;
    }
}