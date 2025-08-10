namespace POS_restaurante.Repositorio._ref
{
    public abstract class CrudBase<T> : ICrud<T> where T : class, new()
    {        
        protected readonly IDBHelper _dbHelper;

        // El constructor de la clase base recibe la dependencia.
        protected CrudBase(IDBHelper dbHelper)
        {
            _dbHelper = dbHelper;
        }

        // 'virtual' para que las clases hijas puedan sobreescribirlo si es necesario.
        public virtual IEnumerable<T> Listar()
        {
            // Este método llama a un procedimiento almacenado "usp_[NombreDeLaClase]_Listar"
            string nombreProcedimiento = $"usp_{typeof(T).Name}_Listar";
            return _dbHelper.ListarEntidades<T>(nombreProcedimiento);
        }

        public virtual T? BuscarPorId(object id)
        {
            string nombreProcedimiento = $"usp_{typeof(T).Name}_ObtenerPorId";
            return _dbHelper.ListarEntidades<T>(nombreProcedimiento, id).FirstOrDefault();
        }

        public virtual string agregar(T item)
        {
            try
            {
                string nombreProcedimiento = $"usp_{typeof(T).Name}_Crear";

                // Omite la propiedad 'Id' porque es generada por la base de datos
                var parametros = typeof(T).GetProperties()
                                          .Where(p => p.Name != "Id")
                                          .Select(p => p.GetValue(item))
                                          .ToArray();

                return _dbHelper.EjecutarSP(nombreProcedimiento, parametros) > 0 ?
                    $"{typeof(T).Name} agregado correctamente" :
                    $"No se puedo agregar {typeof(T).Name}";
            }
            catch (Exception ex)
            {                
                return $"Error al agregar {typeof(T).Name}: {ex.Message}";
            }
        }

        public virtual string actualizar(T item)
        {
            try
            {
                string nombreProcedimiento = $"usp_{typeof(T).Name}_Actualizar";

                // Uso de reflexión para obtener los valores. Para actualizar, el 'Id' debe ser el primer parámetro.
                var propiedades = typeof(T).GetProperties();
                var idProp = propiedades.FirstOrDefault(p => p.Name == "Id");

                if (idProp == null)                
                    throw new InvalidOperationException($"La entidad {typeof(T).Name} debe tener una propiedad 'Id'.");
                

                // Construcción de la lista de parámetros en el orden correcto
                var listaParametros = new List<object>();
                listaParametros.Add(idProp.GetValue(item));

                var otrosParametros = propiedades.Where(p => p.Name != "Id")
                                                 .Select(p => p.GetValue(item));

                listaParametros.AddRange(otrosParametros);

                return _dbHelper.EjecutarSP(nombreProcedimiento, listaParametros.ToArray()) > 0 ?
                    $"{typeof(T).Name} actualizado correctamente" :
                    $"No se puedo actualizar {typeof(T).Name}";
            }
            catch (Exception ex)
            {
                return $"Error al actualizar {typeof(T).Name}: {ex.Message}";
            }
        }

        public virtual string eliminar(object id)
        {
            try
            {
                string nombreProcedimiento = $"usp_{typeof(T).Name}_Eliminar";                
                
                return _dbHelper.EjecutarSP(nombreProcedimiento, id) > 0 ?
                    $"{typeof(T).Name} eliminado correctamente."  :
                    $"No se puedo eliminar {typeof(T).Name}";
            }
            catch (Exception ex)
            {
                return $"Error al eliminar {typeof(T).Name}: {ex.Message}";
            }
        }
    }
}


