using System.Text.Json.Serialization;

namespace Wassa.InnovationServices
{
    public class Identity
    {
        [JsonPropertyName("identity_id")]
        public string identityId { get; set; }
        public double score { get; set; }
    }

    public class IdentitySearchResponse : Response
    {
        public Identity[] results { get; set; }
    }
}