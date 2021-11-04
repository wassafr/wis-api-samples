using System.Runtime.Serialization;

namespace Wassa.InnovationServices {
    public enum JobStatus
    {
        [EnumMember(Value = "Unknown Status")]
        UNKNOWN,
        [EnumMember(Value = "Sent")]
        SENT,
        [EnumMember(Value = "Started")]
        STARTED,
        [EnumMember(Value = "Succeeded")]
        SUCCEEDED,
        [EnumMember(Value = "Failed")]
        FAILED,
        [EnumMember(Value = "Retried")]
        RETRIED,
        [EnumMember(Value = "Revoked")]
        REVOKED
    }
}