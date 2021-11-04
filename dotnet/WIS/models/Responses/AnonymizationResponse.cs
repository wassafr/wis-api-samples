using System.Text.Json.Serialization;

namespace Wassa.InnovationServices
{
    public class AnonymizationResponse : Response
    {
        [JsonPropertyName("output_media")]
        public string outputMedia { get; set; }
        [JsonPropertyName("output_json")]
        public string outputJson { get; set; }
    }
}