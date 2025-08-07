namespace POS_restaurante.Models
{
    public class ProductoTipo
    {
        public int Id { get; set; }
        public string Nombre { get; set; } = string.Empty;
        public int IdGrupoProducto { get; set; }
    }
}
