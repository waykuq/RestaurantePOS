namespace POS_restaurante.Models
{
    public class Comanda
    {
        public int? Id { get; set; }
        public DateTime? FechaHora { get; set; }
        public DateTime? FechaHoraListo { get; set; }
        public DateTime? FechaHoraAnulacion { get; set; }
        public string? EstadoPreparacion { get; set; } 
        public int? IdEmpleadoMesero { get; set; }
        public int? IdMesa { get; set; }
        public string? Estado { get; set; } = string.Empty;
    }
}
