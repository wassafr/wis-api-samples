using System.Text.Json.Serialization;

namespace Wassa.InnovationServices
{
    public class WatermarkResponse : Response
    {
        [JsonPropertyName("output_image_url")]
        public string outputImageUrl { get; set; }
    }
}