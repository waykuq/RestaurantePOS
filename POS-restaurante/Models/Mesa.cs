namespace POS_restaurante.Models
{
    public class Mesa
    {
        public int Id { get; set; }
        public string Nombre { get; set; } = string.Empty;
        public string Estado { get; set; } = string.Empty; // "Libre", "Ocupada"
    }
}
