namespace POS_restaurante.Repositorio._ref
{
    public interface ICrud<T> where T : class
    {
        IEnumerable<T> Listar();
        T? BuscarPorId(object id);
        string agregar(T item);
        string actualizar(T item);
        string eliminar(object id);
    }    
}
