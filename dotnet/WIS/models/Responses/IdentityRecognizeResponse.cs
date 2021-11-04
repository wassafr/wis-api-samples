using System.Text.Json.Serialization;

namespace Wassa.InnovationServices
{
    public class IdentityRecognition
    {
        [JsonPropertyName("identity_id")]
        public string identityId { get; set; }
        public double score { get; set; }
        public bool recognition { get; set; }
    }

    public class IdentityRecognizeResponse : Response
    {
        public IdentityRecognition results { get; set; }
    }
}