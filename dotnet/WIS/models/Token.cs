namespace Wassa.InnovationServices
{
    public class Token
    {
        public string token { get; set; } = null;
        public int expireTime { get; set; }
        public string refreshToken { get; set; } = null;
    }
}