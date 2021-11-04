using System.Text.Json.Serialization;

namespace Wassa.InnovationServices
{
    public class IdentityResponse : Response
    {
        [JsonPropertyName("identity_id")]
        public string identityId { get; set; }
    }
}