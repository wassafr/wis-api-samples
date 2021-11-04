using System.Text.Json.Serialization;

namespace Wassa.InnovationServices
{
    public class FaceAttribute
    {
        public string name { get; set; }
        public dynamic value { get; set; }
        public double confidence { get; set; }
    }

    public class Face
    {
        public double confidence { get; set; }
        public Box box { get; set; }
        public FaceAttribute[] attributes { get; set; }
    }

    public class FacesAttributesResponse : Response
    {
        [JsonPropertyName("faces_counting")]
        public int facesCounting { get; set; }
        public Face[] faces { get; set; }
    }
}