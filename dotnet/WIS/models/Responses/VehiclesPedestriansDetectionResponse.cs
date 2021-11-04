using System.Collections.Generic;
using System.Text.Json.Serialization;

namespace Wassa.InnovationServices
{
    public class VPDObjectCounting
    {
        public int pedestrian { get; set; }
        public int bicycle { get; set; }
        public int car { get; set; }
        public int motorcycle { get; set; }
        public int bus { get; set; }
        public int truck { get; set; }
    }

    public class VPDObject
    {
        public string className { get; set; }
        public double score { get; set; }
        public Point[] box { get; set; }
    }

    public class VehiclesPedestriansDetectionResponse : Response
    {
        [JsonPropertyName("object_counting")]
        public VPDObjectCounting objectCounting { get; set; }
        public List<VPDObject> objects { get; set; }
    }
}