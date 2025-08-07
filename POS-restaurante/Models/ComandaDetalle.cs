namespace POS_restaurante.Models
{
    public class ComandaDetalle
    {
        public int Id { get; set; }
        public int IdComanda { get; set; }
        public int IdProducto { get; set; }
        public decimal Cantidad { get; set; }
        public string? Nota { get; set; }
    }
}
