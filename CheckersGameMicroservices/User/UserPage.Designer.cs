namespace Checkers
{
    partial class UserPage
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
            lblGreet = new Label();
            btnPlay = new Button();
            txtBoxGameInf = new TextBox();
            btnGetInfo = new Button();
            SuspendLayout();
            // 
            // lblGreet
            // 
            lblGreet.AutoSize = true;
            lblGreet.Font = new Font("Segoe UI", 25.8000011F, FontStyle.Bold, GraphicsUnit.Point, 204);
            lblGreet.Location = new Point(12, 9);
            lblGreet.Name = "lblGreet";
            lblGreet.Size = new Size(160, 60);
            lblGreet.TabIndex = 0;
            lblGreet.Text = "Hello, ";
            lblGreet.Click += lblGreet_Click;
            // 
            // btnPlay
            // 
            btnPlay.Font = new Font("Segoe UI", 16.2F, FontStyle.Regular, GraphicsUnit.Point, 204);
            btnPlay.Location = new Point(268, 478);
            btnPlay.Name = "btnPlay";
            btnPlay.Size = new Size(160, 52);
            btnPlay.TabIndex = 1;
            btnPlay.Text = "Играть";
            btnPlay.UseVisualStyleBackColor = true;
            btnPlay.Click += btnPlay_Click;
            // 
            // txtBoxGameInf
            // 
            txtBoxGameInf.Location = new Point(12, 82);
            txtBoxGameInf.Multiline = true;
            txtBoxGameInf.Name = "txtBoxGameInf";
            txtBoxGameInf.ScrollBars = ScrollBars.Both;
            txtBoxGameInf.Size = new Size(416, 372);
            txtBoxGameInf.TabIndex = 2;
            // 
            // btnGetInfo
            // 
            btnGetInfo.Font = new Font("Segoe UI", 16.2F, FontStyle.Regular, GraphicsUnit.Point, 204);
            btnGetInfo.Location = new Point(12, 478);
            btnGetInfo.Name = "btnGetInfo";
            btnGetInfo.Size = new Size(160, 52);
            btnGetInfo.TabIndex = 3;
            btnGetInfo.Text = "Мои игры";
            btnGetInfo.UseVisualStyleBackColor = true;
            btnGetInfo.Click += btnGetInfo_Click;
            // 
            // UserPage
            // 
            AutoScaleDimensions = new SizeF(8F, 20F);
            AutoScaleMode = AutoScaleMode.Font;
            BackColor = SystemColors.ActiveCaption;
            ClientSize = new Size(450, 542);
            Controls.Add(btnGetInfo);
            Controls.Add(txtBoxGameInf);
            Controls.Add(btnPlay);
            Controls.Add(lblGreet);
            Name = "UserPage";
            Text = "UserPage";
            FormClosing += UserPage_FormClosing;
            Load += UserPage_Load;
            ResumeLayout(false);
            PerformLayout();
        }

        #endregion
        private Button btnPlay;
        private TextBox txtBoxGameInf;
        public Button btnGetInfo;
        public Label lblGreet;
    }
}