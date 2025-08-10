using System.Data;

namespace POS_restaurante.Repositorio._ref
{
    public interface IDBHelper
    {
        int EjecutarSP(string nombreSP, params object[] valoresParametros);

        DataTable EjecutarSPDataTable(string nombreSP, params object[] valoresParametros);

        List<T> ListarEntidades<T>(string nombreProcedimiento, params object[] valoresParametros) where T : class, new();

        object RetornaValorEscalar(string nombreSP, params object[] valoresParametros);

    }
}
