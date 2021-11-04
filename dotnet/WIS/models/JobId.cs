using System;

namespace Wassa.InnovationServices
{
    public class JobId 
    {
        public JobId(string jobid)
        {
            if(jobid == null)
                throw new ArgumentNullException("job id should not be null");
            this.jobid = jobid;
        }
        public string jobid {get;set;}

        public static implicit operator string(JobId jobid) => jobid.jobid;
        public static implicit operator JobId(string jobid) => new JobId(jobid);
       
    }
    public class CongestionJobId : JobId {
        public CongestionJobId(string jobid) :base(jobid){}
        public static implicit operator CongestionJobId(string jobid) => new CongestionJobId(jobid);
    }
    public class SoilingJobId : JobId {
        public SoilingJobId(string jobid) :base(jobid){}
        public static implicit operator SoilingJobId(string jobid) => new SoilingJobId(jobid);
    }
    public class AnonymizationJobId : JobId {
        public AnonymizationJobId(string jobid) :base(jobid){}
        public static implicit operator AnonymizationJobId(string jobid) => new AnonymizationJobId(jobid);
    }
    public class WatermarkJobId : JobId {
        public WatermarkJobId(string jobid) :base(jobid){}
        public static implicit operator WatermarkJobId(string jobid) => new WatermarkJobId(jobid);
    }
    public class VehiclesPedestriansDetectionJobId : JobId {
        public VehiclesPedestriansDetectionJobId(string jobid) :base(jobid){}
        public static implicit operator VehiclesPedestriansDetectionJobId(string jobid) => new VehiclesPedestriansDetectionJobId(jobid);
    }
    public class OrientationJobId : JobId {
        public OrientationJobId(string jobid) :base(jobid){}
        public static implicit operator OrientationJobId(string jobid) => new OrientationJobId(jobid);
    }
    public class FacesAttributesJobId : JobId {
        public FacesAttributesJobId(string jobid) :base(jobid){}
        public static implicit operator FacesAttributesJobId(string jobid) => new FacesAttributesJobId(jobid);
    }
    public class IdentityJobId : JobId {
        public IdentityJobId(string jobid) :base(jobid){}
        public static implicit operator IdentityJobId(string jobid) => new IdentityJobId(jobid);
    }
    public class IdentityRecognizeJobId : JobId {
        public IdentityRecognizeJobId(string jobid) :base(jobid){}
        public static implicit operator IdentityRecognizeJobId(string jobid) => new IdentityRecognizeJobId(jobid);
    }
    public class IdentitySearchJobId : JobId {
        public IdentitySearchJobId(string jobid) :base(jobid){}
        public static implicit operator IdentitySearchJobId(string jobid) => new IdentitySearchJobId(jobid);
    }

}