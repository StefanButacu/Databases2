namespace Problema1
{
    partial class Form1
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
            this.dataGridViewProducator = new System.Windows.Forms.DataGridView();
            this.dataGridViewBiscutiti = new System.Windows.Forms.DataGridView();
            this.btnApplyChanges = new System.Windows.Forms.Button();
            ((System.ComponentModel.ISupportInitialize)(this.dataGridViewProducator)).BeginInit();
            ((System.ComponentModel.ISupportInitialize)(this.dataGridViewBiscutiti)).BeginInit();
            this.SuspendLayout();
            // 
            // dataGridViewProducator
            // 
            this.dataGridViewProducator.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dataGridViewProducator.Location = new System.Drawing.Point(12, 73);
            this.dataGridViewProducator.Name = "dataGridViewProducator";
            this.dataGridViewProducator.RowHeadersWidth = 51;
            this.dataGridViewProducator.RowTemplate.Height = 24;
            this.dataGridViewProducator.Size = new System.Drawing.Size(523, 336);
            this.dataGridViewProducator.TabIndex = 0;
            // 
            // dataGridViewBiscutiti
            // 
            this.dataGridViewBiscutiti.ColumnHeadersHeightSizeMode = System.Windows.Forms.DataGridViewColumnHeadersHeightSizeMode.AutoSize;
            this.dataGridViewBiscutiti.Location = new System.Drawing.Point(551, 88);
            this.dataGridViewBiscutiti.Name = "dataGridViewBiscutiti";
            this.dataGridViewBiscutiti.RowHeadersWidth = 51;
            this.dataGridViewBiscutiti.RowTemplate.Height = 24;
            this.dataGridViewBiscutiti.Size = new System.Drawing.Size(702, 248);
            this.dataGridViewBiscutiti.TabIndex = 1;
            // 
            // btnApplyChanges
            // 
            this.btnApplyChanges.Location = new System.Drawing.Point(915, 357);
            this.btnApplyChanges.Name = "btnApplyChanges";
            this.btnApplyChanges.Size = new System.Drawing.Size(75, 52);
            this.btnApplyChanges.TabIndex = 2;
            this.btnApplyChanges.Text = "Apply";
            this.btnApplyChanges.UseVisualStyleBackColor = true;
            this.btnApplyChanges.Click += new System.EventHandler(this.button1_Click);
            // 
            // Form1
            // 
            this.AutoScaleDimensions = new System.Drawing.SizeF(8F, 16F);
            this.AutoScaleMode = System.Windows.Forms.AutoScaleMode.Font;
            this.ClientSize = new System.Drawing.Size(1309, 450);
            this.Controls.Add(this.btnApplyChanges);
            this.Controls.Add(this.dataGridViewBiscutiti);
            this.Controls.Add(this.dataGridViewProducator);
            this.Name = "Form1";
            this.Text = "Form1";
            this.Load += new System.EventHandler(this.Form1_Load);
            ((System.ComponentModel.ISupportInitialize)(this.dataGridViewProducator)).EndInit();
            ((System.ComponentModel.ISupportInitialize)(this.dataGridViewBiscutiti)).EndInit();
            this.ResumeLayout(false);

        }

        #endregion

        private System.Windows.Forms.DataGridView dataGridViewProducator;
        private System.Windows.Forms.DataGridView dataGridViewBiscutiti;
        private System.Windows.Forms.Button btnApplyChanges;
    }
}