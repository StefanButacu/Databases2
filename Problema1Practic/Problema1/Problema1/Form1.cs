using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace Problema1
{

    public partial class Form1 : Form
    {
        string connectionString = @"Server=DESKTOP-6RT73G3\SQLEXPRESS;Initial Catalog=P32022;Integrated Security=true;";

        DataSet dataSet = new DataSet();
        SqlDataAdapter dataAdapterParent = new SqlDataAdapter();
        SqlDataAdapter dataAdapterChild = new SqlDataAdapter();
        private BindingSource bindingSourceChild = new BindingSource();
        private BindingSource bindingSourceParent = new BindingSource();

        public Form1()
        {

            InitializeComponent();
        }


        private void Form1_Load(object sender, EventArgs e)
        {
              try
             {
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Open();
                String sqlSelectParent = "SELECT * FROM Producatori";
                String sqlSelectChild = "SELECT * FROM Biscuiti";

                SqlCommand selectParent = new SqlCommand(sqlSelectParent, connection);
                dataAdapterParent.SelectCommand = selectParent;

                SqlCommand selectChild = new SqlCommand(sqlSelectChild, connection);
                dataAdapterChild.SelectCommand = selectChild;

                dataAdapterParent.Fill(dataSet, "producatori");
                dataAdapterChild.Fill(dataSet, "biscutiti");

                DataColumn pk = dataSet.Tables["producatori"].Columns["cod_p"];
                DataColumn fk = dataSet.Tables["biscutiti"].Columns["cod_p"];

                DataRelation relation = new DataRelation("fk_Parent_child", pk, fk);


                dataSet.Relations.Add(relation);
                bindingSourceParent.DataSource = dataSet.Tables["producatori"];
                dataGridViewProducator.DataSource = bindingSourceParent;

                bindingSourceChild.DataSource = bindingSourceParent;
                bindingSourceChild.DataMember = "fk_Parent_child";

                dataGridViewBiscutiti.DataSource = bindingSourceChild;

                dataGridViewBiscutiti.Columns["cod_b"].ReadOnly = true;
                dataGridViewProducator.Columns["cod_p"].ReadOnly = true;


            }
            
        }
        catch (Exception ex) {
            MessageBox.Show(ex.Message);
        }
            

        }

        private void button1_Click(object sender, EventArgs e)
        {
            try
             {
            using (SqlConnection connection = new SqlConnection(connectionString))
            {
                connection.Open();

                dataAdapterChild.SelectCommand = new SqlCommand("SELECT * FROM Biscuiti", connection);
                SqlCommandBuilder commandBuilder = new SqlCommandBuilder(dataAdapterChild);
                dataAdapterChild.InsertCommand = commandBuilder.GetInsertCommand();
                dataAdapterChild.UpdateCommand = commandBuilder.GetUpdateCommand();
                dataAdapterChild.DeleteCommand = commandBuilder.GetDeleteCommand();
                dataAdapterChild.Update(dataSet, "biscutiti");

                dataSet.Tables["biscutiti"].Clear();
                dataAdapterChild.Fill(dataSet, "biscutiti");


            }
        }
           catch (Exception ex)
           {

               MessageBox.Show(ex.Message);
           }
        
    
        }
    }
}