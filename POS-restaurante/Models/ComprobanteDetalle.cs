namespace POS_restaurante.Models
{
    public class ComprobanteDetalle
    {
        public int Id { get; set; }
        public int IdComprobante { get; set; }
        public int IdProducto { get; set; }
        public decimal Cantidad { get; set; }
        public decimal PrecioUnitario { get; set; }
    }
}
