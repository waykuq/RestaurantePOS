using POS_restaurante.Models;
using POS_restaurante.Repositorio._ref;

namespace POS_restaurante.Repositorio.impl
{
    public class ClienteDAO : CrudBase<Cliente>, ICliente
    {
        public ClienteDAO(IDBHelper dbHelper) : base(dbHelper)
        {
        }

        // Ejemplo de sobreescritura de un método específico
        // Fíjense como le paso los parámetros al método del DBHelper
        // También pueden usar SqlClient directamente si es necesario

        //public string GrabarVenta(string cod_cli, decimal total,
        //    List<Carrito> listaCarrito)
        //{
        //    string resultado = "";
        //    try
        //    {
        //        // grabar en la cabecera de venta: PA_GRABAR_VENTAS_CAB_CC
        //        string num_vta = DBHelper.RetornaValorEscalar(
        //                "PA_GRABAR_VENTAS_CAB_CC", cod_cli, total).ToString();

        //        // grabar en la detalle de venta: PA_GRABAR_VENTAS_DETA_CC
        //        foreach (Carrito item in listaCarrito)
        //        {
        //            DBHelper.EjecutarSP("PA_GRABAR_VENTAS_DETA_CC", num_vta,
        //                       item.Codigo, item.Cantidad, item.Precio);
        //        }
        //        /*
        //        listaCarrito.ForEach(
        //            x => DBHelper.EjecutarSP("PA_GRABAR_VENTAS_DETA_CC",
        //                num_vta, x.Codigo, x.Cantidad, x.Precio));
        //        */
        //        resultado = $"La venta {num_vta} se realizó correctamente";
        //        return resultado;
        //    }
        //    catch (Exception ex)
        //    {
        //        throw new Exception(ex.Message);
        //    }
        //}
    }
}

