namespace Wassa.InnovationServices
{
    public class Error
    {
        public int statusCode { get; set; }
        public string error { get; set; } = null;
        public string message { get; set; } = null;
    }
}