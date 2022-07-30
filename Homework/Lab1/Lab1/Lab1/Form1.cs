using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.Windows.Forms;

namespace Lab1
{
    public partial class Form1 : Form
    {
        //string connectionStream = @"Server=DESKTOP-6RT73G3\SQLEXPRESS;Initial Catalog=PartajareAbonamente;Integrated Security=true;";
        public void MethodA(int tryNumber = 0)
        {
            Console.WriteLine("Method A: TryNumber" + tryNumber);
            if (tryNumber == 10)
            {
                Console.WriteLine("Method A Aborted after 10 calls");
                return;
            }
            Thread.Sleep(1000);
            using (SqlConnection connection = new SqlConnection(connectionStream))
            {
                connection.Open();
                //... // 1.  create a command object identifying the stored procedure
                SqlCommand cmd = new SqlCommand("deadlock_first", connection);

                // 2. set the command object so it knows to execute a stored procedure
                cmd.CommandType = CommandType.StoredProcedure;

                try
                {
                    Console.WriteLine("Prepare to execute deadlock_first stored procedure");
                    int rowAffected = cmd.ExecuteNonQuery();
                    Console.WriteLine("Finish to execute deadlock_first stored procedure");

                }
                catch (SqlException ex) when( ex.Number == 1205)
                {
                    Console.WriteLine("Deadlock at deadlock_first stored procedure, executing MethodA again");
                    MethodA(tryNumber + 1);
                }
                
            }
        }
        

        public  void MethodB(int tryNumber = 0)
        {
            Console.WriteLine("Method B: TryNumber" + tryNumber);
            if (tryNumber == 10)
            {
                Console.WriteLine("Method B Aborted after 10 calls");
                return;
            }
            Thread.Sleep(1000);
            using (SqlConnection connection = new SqlConnection(connectionStream))
            {
                
                //do something
                connection.Open();
                //... // 1.  create a command object identifying the stored procedure
                SqlCommand cmd = new SqlCommand("deadlock_second", connection);

                // 2. set the command object so it knows to execute a stored procedure
                cmd.CommandType = CommandType.StoredProcedure;
                try
                {
                    Console.WriteLine("Prepare to execute deadlock_second stored procedure");
                    int rowAffected = cmd.ExecuteNonQuery();
                    Console.WriteLine("Finish to execute deadlock_second stored procedure");

                }
                catch (SqlException ex) when( ex.Number == 1205)
                {
                    Console.WriteLine("Deadlock at deadlock_second stored procedure, executing MethodB again");
                    MethodB(tryNumber+1);
                }
            }
        
        }

        
        string connectionStream = ConfigurationManager.ConnectionStrings["db"].ConnectionString;
        DataSet dataSet = new DataSet();
        SqlDataAdapter dataAdapterParent = new SqlDataAdapter();
        SqlDataAdapter dataAdapterChild = new SqlDataAdapter();
        string tableParent = ConfigurationManager.AppSettings["TableParent"];
        string tableChild = ConfigurationManager.AppSettings["TableChild"];
        string foreignKey = ConfigurationManager.AppSettings["ForeignKey"];
        private BindingSource bindingSourceChild = new BindingSource();
        private BindingSource bindingSourceParent = new BindingSource();

        private SqlCommandBuilder commandBuilder;
        public Form1()
        {
            // Thread thread2 = new Thread(MethodB);
            Thread thread1 = new Thread(() => MethodA(1));
            thread1.Start();

            // thread2.Start();
            Thread thread2 = new Thread(() => MethodB(1));
            thread2.Start();
            // MethodB(1);
            InitializeComponent();
        }

        private void Form1_Load(object sender, EventArgs e)
        {
            try
            {
                using (SqlConnection connection = new SqlConnection(connectionStream))
                {
                    connection.Open();
                    string sqlParentQuery = $"SELECT * FROM {tableParent};";
                    SqlCommand sqlParentView = new SqlCommand(sqlParentQuery, connection);

                    string sqlChildQuey = $"SELECT * FROM {tableChild};";
                    SqlCommand sqlChildView = new SqlCommand(sqlChildQuey, connection);

                    dataAdapterParent.SelectCommand = sqlParentView;
                    dataAdapterChild.SelectCommand = sqlChildView;

                    dataAdapterParent.Fill(dataSet, tableParent);
                    dataAdapterChild.Fill(dataSet, tableChild);
                    DataColumn pk = dataSet.Tables[tableParent].Columns[foreignKey];
                    DataColumn fk = dataSet.Tables[tableChild].Columns[foreignKey];
                    DataRelation relation = new DataRelation("fk_Parent_child", pk, fk);
                    dataSet.Relations.Add(relation);
                    bindingSourceParent.DataSource = dataSet.Tables[tableParent];
                    dataGridViewParent.DataSource = bindingSourceParent;

                    bindingSourceChild.DataSource = bindingSourceParent;
                    bindingSourceChild.DataMember = "fk_Parent_child";

                    dataGridViewChild.DataSource = bindingSourceChild;

                    dataGridViewChild.Columns[0].ReadOnly = true;
                    dataGridViewParent.Columns[0].ReadOnly = true;

                    labelParent.Text = tableParent;
                    labelChild.Text = tableChild;
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
                using (SqlConnection connection = new SqlConnection(connectionStream))
                {
                    connection.Open();

                    dataAdapterChild.SelectCommand = new SqlCommand($"SELECT * FROM {tableChild}", connection);
                    commandBuilder = new SqlCommandBuilder(dataAdapterChild);
                    dataAdapterChild.InsertCommand = commandBuilder.GetInsertCommand();
                    dataAdapterChild.UpdateCommand = commandBuilder.GetUpdateCommand();
                    dataAdapterChild.Update(dataSet, tableChild);

                    dataSet.Tables[tableChild].Clear();
                    dataAdapterChild.Fill(dataSet, tableChild);


                }
            }
            catch (Exception ex)
            {

                MessageBox.Show(ex.Message);
            }
        }

        private void dataGridViewChild_UserDeletedRow(object sender, DataGridViewRowEventArgs e)
        {
            try
            {
                using (SqlConnection connection = new SqlConnection(connectionStream))
                {
                    connection.Open();
                    dataAdapterChild.SelectCommand = new SqlCommand($"SELECT * FROM {tableChild}", connection);
                    commandBuilder = new SqlCommandBuilder(dataAdapterChild);
                    dataAdapterChild.DeleteCommand = commandBuilder.GetDeleteCommand();
                    dataAdapterChild.Update(dataSet, tableChild);
                }
            }
            catch (Exception ex)
            {

                MessageBox.Show(ex.Message);
            }
        }
    }
}

