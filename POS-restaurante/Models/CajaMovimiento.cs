namespace POS_restaurante.Models
{
    public class CajaMovimiento
    {
        public int? Id { get; set; }
        public DateTime? FechaHora { get; set; }
        public decimal? Cantidad { get; set; }
        public int? IdCaja { get; set; }
        public int? IdTipoMovimiento { get; set; }
        public int? IdTipoPago { get; set; }
        public int? IdEmpleado { get; set; }
        public int? IdComprobante { get; set; } // Permite nulos
    }
}
