using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;
using System.Data.SqlClient;

namespace Lab1
{
    public partial class Form1 : Form
    {
        string connectionStream = @"Server=DESKTOP-6RT73G3\SQLEXPRESS;Initial Catalog=Lab1222-1SGBD;Integrated Security=true;";
        DataSet dataSet = new DataSet();
        SqlDataAdapter adapter = new SqlDataAdapter();
        /// fiecare tabela cu  datasetul  si dataapadterul la mai multe :D
        public Form1()
        {
            InitializeComponent();
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            try
            {
                using (SqlConnection connection= new SqlConnection(connectionStream)) {
                    connection.Open();
                    MessageBox.Show(connection.State.ToString());
                    adapter.SelectCommand = new SqlCommand("SELECT * FROM Sali;", connection);
                    adapter.Fill(dataSet, "Sali");
                    dataGridView1.DataSource = dataSet.Tables["Sali"];
                }
            }
            catch (Exception ex) {
                MessageBox.Show(ex.Message);
            }
        }

        private void Form1_DoubleClick(object sender, EventArgs e)
        {
            MessageBox.Show("Hello world");
        }

        private void buttonRefresh_Click(object sender, EventArgs e)
        {

            try
            {
                using (SqlConnection connection = new SqlConnection(connectionStream))
                {
                    adapter.SelectCommand.Connection = connection;
                    dataSet.Tables["Sali"].Clear();
                    adapter.Fill(dataSet, "Sali");

                
                }
            }
            catch (Exception ex)
            {
                MessageBox.Show(ex.Message);
            }
        }
    }
}
