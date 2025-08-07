namespace POS_restaurante.Repository
{
    public interface IRepositorio<T> where T : class
    {

        IEnumerable<T> GetAll();
        T search(object id);
        string add(T item);
        string update(T item);
        //string delete(object id);

    }

    
}
