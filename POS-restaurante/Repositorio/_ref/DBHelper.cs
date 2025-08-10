using Microsoft.Data.SqlClient;
//using Microsoft.Extensions.Configuration;
//using POS_restaurante.Models;
using System.Data;
using System.Reflection;

namespace POS_restaurante.Repositorio._ref
{
    public class DBHelper: IDBHelper
    {        
        private readonly string? _cad_cn;

        public DBHelper(IConfiguration iconfig)
        {
            _cad_cn = iconfig.GetConnectionString("cadena")
                      ?? throw new ArgumentNullException(nameof(iconfig), "La cadena de conexion no puede ser nula.");
        }

        // Prepara el comando SQL y llena los parámetros
        private void LlenarParametros(SqlCommand cmd,
                          params object[] valoresParametros)
        {
            int indice = 0;
            SqlCommandBuilder.DeriveParameters(cmd);
            // recorrer cada parámetro y asignarle su valor
            foreach (SqlParameter prm in cmd.Parameters)
            {
                // si el nombre del parámetro es diferente a
                // "@RETURN_VALUE", entonces le asignaremos el elemento
                // correspondiente del array de valores (según indice)
                if (prm.ParameterName != "@RETURN_VALUE")
                {
                    prm.Value = valoresParametros[indice];
                    indice++;
                }
            }
        }

        // Método para el CRUD (Insertar, Actualizar y "Eliminar")
        public int EjecutarSP(string nombreSP, 
                          params object[] valoresParametros)
        {
            int temp;
            using (SqlConnection cnx = new SqlConnection(_cad_cn))
            {
                cnx.Open();
                SqlCommand cmd = new SqlCommand(nombreSP, cnx);
                cmd.CommandType = CommandType.StoredProcedure;
                
                if (valoresParametros.Length > 0)
                    LlenarParametros(cmd, valoresParametros);
                
                temp = cmd.ExecuteNonQuery() > 0 ?
                            1 :
                            0;
            }
            return temp;
        }

        // Método devuelve un DataTable para cualquier consulta, listado, etc (select)
        public DataTable EjecutarSPDataTable(string nombreSP,
                          params object[] valoresParametros)
        { 
            DataTable Tabla = new DataTable();
            using (SqlDataAdapter adap = new SqlDataAdapter(nombreSP, _cad_cn))
            { 
                adap.SelectCommand.Connection.Open();
                adap.SelectCommand.CommandType = CommandType.StoredProcedure;
                //
                if (valoresParametros.Length > 0)
                    LlenarParametros(adap.SelectCommand, valoresParametros);
                // poblar el datatable
                adap.Fill(Tabla);
            }
            //
            return Tabla;
        }

        // Método para listar entidades a partir de un SP (select)
        public List<T> ListarEntidades<T>(string nombreProcedimiento, params object[] valoresParametros) where T : class, new()
        {
            var lista = new List<T>();

            using (var cnx = new SqlConnection(_cad_cn))
            {
                using (var cmd = new SqlCommand(nombreProcedimiento, cnx))
                {
                    cmd.CommandType = CommandType.StoredProcedure;
                    if (valoresParametros.Length > 0)
                        LlenarParametros(cmd, valoresParametros);

                    cnx.Open();

                    using (SqlDataReader reader = cmd.ExecuteReader())
                    {   
                        if (!reader.HasRows) 
                            return lista;

                        // Set con los nombres de las columnas para búsquedas rápidas
                        var columns = Enumerable.Range(0, reader.FieldCount).Select(reader.GetName).ToHashSet(StringComparer.OrdinalIgnoreCase);
                        // Set con los nombres de las propiedades de la entidad
                        var properties = typeof(T).GetProperties(BindingFlags.Public | BindingFlags.Instance);

                        while (reader.Read()) 
                        {
                            var entidad = new T(); 

                            foreach (var prop in properties)
                            {
                                // Mapeo: Si existe una columna con el mismo nombre que la propiedad y no es nula
                                if (columns.Contains(prop.Name) && !reader.IsDBNull(reader.GetOrdinal(prop.Name)))
                                {
                                    prop.SetValue(entidad, reader[prop.Name]);
                                }
                            }
                            lista.Add(entidad);
                        }
                    }
                }
            }
            return lista;
        }

        // Método para ejecutar un SP y devolver un valor
        public object RetornaValorEscalar(string nombreSP,
                          params object[] valoresParametros)
        {
            using (SqlConnection cnx = new SqlConnection(_cad_cn))
            {                
                SqlCommand cmd = new SqlCommand(nombreSP, cnx);
                cmd.CommandType = CommandType.StoredProcedure;
                
                if (valoresParametros.Length > 0)
                    LlenarParametros(cmd, valoresParametros);
                
                cnx.Open();
                object rpta = cmd.ExecuteScalar();
                
                return rpta;
            }
        }

    } 
}