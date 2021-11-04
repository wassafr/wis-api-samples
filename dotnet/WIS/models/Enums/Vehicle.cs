using System.Runtime.Serialization;

namespace Wassa.InnovationServices {
    public enum Vehicle
    {
        [EnumMember(Value = "pedestrian")]
        pedestrian,
        [EnumMember(Value = "car")]
        car,
        [EnumMember(Value = "truck")]
        truck,
        [EnumMember(Value = "bus")]
        bus,
        [EnumMember(Value = "motorcycle")]
        motorcycle,
        [EnumMember(Value = "bicycle")]
        bicycle
    }
}