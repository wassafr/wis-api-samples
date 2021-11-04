using System.Text.Json.Serialization;

namespace Wassa.InnovationServices
{
    public class SoilingResult
    {
        public double dust { get; set; }
        public double dirt { get; set; }
        public double gravel { get; set; }
        public double clod { get; set; }
    }

    public class SoilingResponse : Response
    {
        [JsonPropertyName("result_soiling")]
        public SoilingResult soilingResult { get; set; }
    }
}