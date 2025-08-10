namespace POS_restaurante.Models
{
    public class Comprobante
    {
        public int Id { get; set; }
        public string Numero { get; set; } = string.Empty;
        public DateTime FechaHora { get; set; }
        public decimal Igv { get; set; }
        public decimal Total { get; set; }
        public int IdTipoComprobante { get; set; }
        public int IdCliente { get; set; }
        public int IdEmpleadoCajero { get; set; }
        public int? IdComanda { get; set; } // Permite nulos
    }
}

