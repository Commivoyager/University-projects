namespace Checkers
{
    partial class AuthForm
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
            lblLogin = new Label();
            lblPassword = new Label();
            txtBoxLogin = new TextBox();
            txtBoxPassword = new TextBox();
            btnRegistrate = new Button();
            btnLogin = new Button();
            SuspendLayout();
            // 
            // lblLogin
            // 
            lblLogin.AutoSize = true;
            lblLogin.Font = new Font("Segoe UI", 16.2F);
            lblLogin.Location = new Point(44, 37);
            lblLogin.Name = "lblLogin";
            lblLogin.Size = new Size(85, 38);
            lblLogin.TabIndex = 0;
            lblLogin.Text = "Login";
            // 
            // lblPassword
            // 
            lblPassword.AutoSize = true;
            lblPassword.Font = new Font("Segoe UI", 16.2F);
            lblPassword.Location = new Point(44, 164);
            lblPassword.Name = "lblPassword";
            lblPassword.Size = new Size(132, 38);
            lblPassword.TabIndex = 1;
            lblPassword.Text = "Password";
            // 
            // txtBoxLogin
            // 
            txtBoxLogin.Font = new Font("Segoe UI", 13.8F);
            txtBoxLogin.Location = new Point(44, 83);
            txtBoxLogin.Name = "txtBoxLogin";
            txtBoxLogin.Size = new Size(389, 38);
            txtBoxLogin.TabIndex = 2;
            // 
            // txtBoxPassword
            // 
            txtBoxPassword.Font = new Font("Segoe UI", 13.8F);
            txtBoxPassword.Location = new Point(44, 215);
            txtBoxPassword.Name = "txtBoxPassword";
            txtBoxPassword.Size = new Size(389, 38);
            txtBoxPassword.TabIndex = 3;
            // 
            // btnRegistrate
            // 
            btnRegistrate.Font = new Font("Segoe UI", 13.8F);
            btnRegistrate.Location = new Point(75, 300);
            btnRegistrate.Name = "btnRegistrate";
            btnRegistrate.Size = new Size(132, 40);
            btnRegistrate.TabIndex = 4;
            btnRegistrate.Text = "Registrate";
            btnRegistrate.UseVisualStyleBackColor = true;
            btnRegistrate.Click += btnRegistrate_Click;
            // 
            // btnLogin
            // 
            btnLogin.Font = new Font("Segoe UI", 13.8F);
            btnLogin.Location = new Point(272, 300);
            btnLogin.Name = "btnLogin";
            btnLogin.Size = new Size(132, 40);
            btnLogin.TabIndex = 5;
            btnLogin.Text = "Login";
            btnLogin.UseVisualStyleBackColor = true;
            btnLogin.Click += btnLogin_Click;
            // 
            // AuthForm
            // 
            AutoScaleDimensions = new SizeF(8F, 20F);
            AutoScaleMode = AutoScaleMode.Font;
            BackColor = SystemColors.ActiveCaption;
            ClientSize = new Size(476, 367);
            Controls.Add(btnLogin);
            Controls.Add(btnRegistrate);
            Controls.Add(txtBoxPassword);
            Controls.Add(txtBoxLogin);
            Controls.Add(lblPassword);
            Controls.Add(lblLogin);
            Name = "AuthForm";
            Text = "AuthForm";
            ResumeLayout(false);
            PerformLayout();
        }

        #endregion

        private Label lblLogin;
        private Label lblPassword;
        private TextBox txtBoxLogin;
        private TextBox txtBoxPassword;
        private Button btnRegistrate;
        private Button btnLogin;
    }
}