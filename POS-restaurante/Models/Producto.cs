namespace POS_restaurante.Models
{
    public class Producto
    {
        public int? Id { get; set; }
        public string? Nombre { get; set; } = string.Empty;
        public string? Descripcion { get; set; } // Permite nulos
        public decimal? Precio { get; set; }
        public int? IdTipoProducto { get; set; }
        public int? IdEstacion { get; set; }
    }
}
