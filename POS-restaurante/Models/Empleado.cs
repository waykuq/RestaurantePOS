namespace POS_restaurante.Models
{
    public class Empleado
    {
        public int? Id { get; set; }
        public string? Nombre { get; set; } = string.Empty;
        public string? Dni { get; set; } = string.Empty;
        public string? Usuario { get; set; } = string.Empty;
        public string? PasswordHash { get; set; } = string.Empty; 
        public int? IdTipoEmpleado { get; set; }
    }
}
