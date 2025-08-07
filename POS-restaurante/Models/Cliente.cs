namespace POS_restaurante.Models
{
    public class Cliente
    {
        public int Id { get; set; }
        public string Nombre { get; set; } = string.Empty;
        public string DniRuc { get; set; } = string.Empty;
        public string? Correo { get; set; }
        public string? Telefono { get; set; }
        public string Tipo { get; set; } = string.Empty; // "Persona" o "Empresa"
    }
}
