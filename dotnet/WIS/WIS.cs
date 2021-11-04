using System.Text.Json;
using System.Collections.Generic;
using System.Globalization;
using RestSharp;
using System.Web;

namespace Wassa.InnovationServices
{
    /// <summary>
    /// API Documentation: https://api.services.wassa.io/doc/
    /// WIS (wassa Innovation Services) API is used to interface a client information system,
    /// an application, a webapp, a mobile app etc. with the WIS platform following the
    /// HTTP protocol.
    /// This class is used to call the WIS API
    /// You can get the public methods parameters descriptions on the API documentation.
    /// </summary>
    public class WIS
    {
        private JsonSerializerOptions json_options = new JsonSerializerOptions
        {
            Converters = { new CustomJsonStringEnumConverter() },
            WriteIndented = true,
        };
        private Token connection = null;
        private string url = "https://api.services.wassa.io";

        public WIS(string clientId, string secretId)
        {
            this.Login(clientId, secretId);
        }

        /// <summary>
        /// Uses a clientId and secretId (provided by Wassa) to authenticate.
        /// It will store a Token that will be used for the other methods (creating a job, getting its status ...)
        /// </summary>
        /// <param name="clientId">Client ID provided when subscribe to wassa service</param>
        /// <param name="secretId">Secret ID provided when subscribe to wassa service</param>
        public void Login(string clientId, string secretId)
        {
            var client = new RestClient(this.url + "/login");
            client.Timeout = -1;
            var request = new RestRequest(Method.POST);
            request.AddHeader("Content-Type", "application/json");
            request.AddParameter("application/json", $"{{\"clientId\": \"{clientId}\",\"secretId\": \"{secretId}\"}}",  ParameterType.RequestBody);
            IRestResponse response = client.Execute(request);

            if (response.StatusCode == System.Net.HttpStatusCode.OK)
            {
                this.connection = JsonSerializer.Deserialize<Token>(response.Content, this.json_options);
            }
            else
            {
                Error error = JsonSerializer.Deserialize<Error>(response.Content, this.json_options);
                throw new WISException(error.error);
            }
        }

        /// <summary>
        /// A generic method to create a POST on a service
        ///     It is used to create a job.
        /// </summary>
        /// <param name="request"></param>
        /// <param name="route"></param>
        /// <param name="mediaPaths"></param>
        /// <param name="mediaLabel"></param>
        /// <returns> a dictionary representing the JSON returned by the API (see API documentation)</returns>
        private Dictionary<string, string> PostService(RestRequest request, string route, string[] mediaPaths, string mediaLabel = "input_media")
        {
            var client = new RestClient(this.url + $"/{route}");
            client.Timeout = -1;

            request.AddHeader("Content-Type", "multipart/form-data");
            request.AddHeader("Authorization", $"Bearer {this.connection.token}");
            foreach (string mediaPath in mediaPaths)
            {
                request.AddFile(mediaLabel, mediaPath, MimeTypes.GetMimeType(mediaPath));
            }

            IRestResponse response = client.Execute(request);
            if (response.StatusCode != System.Net.HttpStatusCode.OK)
            {
                System.Console.WriteLine("PostService, response.StatusCode : " + response.StatusCode);
                Error error = JsonSerializer.Deserialize<Error>(response.Content);
                throw new WISException(error.message);
            }

            return JsonSerializer.Deserialize<Dictionary<string, string>>(response.Content);
        }

        /// <summary>
        /// A generic method to get a job status.
        /// </summary>
        /// <param name="jobId"></param>
        /// <param name="label"></param>
        /// <param name="route"></param>
        /// <typeparam name="T"></typeparam>
        /// <returns>a Response child object corresponding to the service response</returns>
        private T GetJobStatus<T>(string jobId, string label, string route) where T : Response
        {
            var client = new RestClient(this.url + $"/{route}?{label}={jobId}");
            client.Timeout = -1;
            var request = new RestRequest(Method.GET);
            request.AddHeader("Authorization", $"Bearer {this.connection.token}");
            IRestResponse response = client.Execute(request);

            if (response.StatusCode != System.Net.HttpStatusCode.OK)
            {
                Error error = JsonSerializer.Deserialize<Error>(response.Content, this.json_options);
                throw new WISException(error.message);
            }
            return JsonSerializer.Deserialize<T>(response.Content, this.json_options);
        }

        /// <summary>
        /// A method to get a result file. (eg: blurit returns an url to the output image, you can get this ouput image by calling this method)
        /// </summary>
        /// <param name="filename"></param>
        /// <returns>A binary content of file</returns>
        public byte[] GetResultFile(string filename)
        {
            var client = new RestClient(this.url + $"/innovation-service/result/{filename}");
            client.Timeout = -1;

            var request = new RestRequest(Method.GET);
            request.AddHeader("Authorization", $"Bearer {this.connection.token}");

            byte[] response = client.DownloadData(request);

            return response;
        }

        /// <summary>
        /// A method to create a Congestion job.
        /// </summary>
        /// <param name="picture"></param>
        /// <param name="congestionLine"></param>
        /// <param name="includedArea"></param>
        /// <returns>a job id</returns>
        public CongestionJobId CongestionCreateJob(string picture, Point[] congestionLine, Box includedArea = null)
        {
            var request = new RestRequest(Method.POST);

            request.AddParameter("congestion_line", JsonSerializer.Serialize(congestionLine, this.json_options));
            if (includedArea != null)
            {
                request.AddParameter("included_area",  JsonSerializer.Serialize(includedArea, this.json_options));
            }

            return this.PostService(request, "innovation-service/congestion", new string[1] { picture }, "picture")["congestion_job_id"];
        }

        /// <summary>
        /// A method to get a Congestion job status (and result/error if the job is ended).
        /// </summary>
        /// <param name="congestionJobId"></param>
        /// <returns>a CongestionResponse</returns>
        public CongestionResponse CongestionGetJobStatus(CongestionJobId congestionJobId)
        {
            return this.GetJobStatus<CongestionResponse>(congestionJobId, "congestion_job_id", "innovation-service/congestion");
        }

        /// <summary>
        ///  A method to create a Soiling job.
        /// </summary>
        /// <param name="picture"></param>
        /// <param name="soilingArea"></param>
        /// <returns>a job id</returns>
        public SoilingJobId SoilingCreateJob(string picture, Point[] soilingArea)
        {
            var request = new RestRequest(Method.POST);

            request.AddParameter("soiling_area", JsonSerializer.Serialize(soilingArea, this.json_options));

            return this.PostService(request, "innovation-service/soiling", new string[1] { picture }, "picture")["soiling_job_id"];
        }

        /// <summary>
        /// A method to get a Soiling job status (and result/error if the job is ended).
        /// </summary>
        /// <param name="soilingJobId"></param>
        /// <returns>a SoilingResponse</returns>
        public SoilingResponse SoilingGetJobStatus(SoilingJobId soilingJobId)
        {
            return this.GetJobStatus<SoilingResponse>(soilingJobId, "soiling_job_id", "innovation-service/soiling");
        }

        /// <summary>
        /// A method to create an Anonymization job.
        /// </summary>
        /// <param name="inputMedia"></param>
        /// <param name="activationFacesBlur"></param>
        /// <param name="activationPlatesBlur"></param>
        /// <param name="outputDetectionsUrl"></param>
        /// <param name="includedArea"></param>
        /// <returns>a job id</returns>
        public AnonymizationJobId AnonymizationCreateJob(string inputMedia, bool activationFacesBlur=true, bool activationPlatesBlur=true, bool outputDetectionsUrl=false, Box includedArea = null)
        {
            var request = new RestRequest(Method.POST);

            request.AddParameter("activation_faces_blur", activationFacesBlur);
            request.AddParameter("activation_plates_blur", activationPlatesBlur);
            request.AddParameter("output_detections_url", outputDetectionsUrl);

            if (includedArea != null)
            {
                request.AddParameter("included_area",  JsonSerializer.Serialize(includedArea, this.json_options));
            }

            return this.PostService(request, "innovation-service/anonymization", new string[1] { inputMedia })["anonymization_job_id"];
        }

        /// <summary>
        /// A method to get an Anonymization job status (and result/error if the job is ended).
        /// </summary>
        /// <param name="anonymizationJobId"></param>
        /// <returns>an AnonymizationResponse</returns>
        public AnonymizationResponse AnonymizationGetJobStatus(AnonymizationJobId anonymizationJobId)
        {
            return this.GetJobStatus<AnonymizationResponse>(anonymizationJobId, "anonymization_job_id", "innovation-service/anonymization");
        }

        /// <summary>
        /// A method to create a Watermark job.
        /// </summary>
        /// <param name="inputMedia"></param>
        /// <param name="inputWatermark"></param>
        /// <param name="watermarkTransparency"></param>
        /// <param name="watermarkRatio"></param>
        /// <param name="watermarkPositionPreset"></param>
        /// <returns>a job id</returns>
        public WatermarkJobId WatermarkCreateJob(string inputMedia, string inputWatermark, double watermarkTransparency, double watermarkRatio, WatermarkPosition watermarkPositionPreset)
        {
            var request = new RestRequest(Method.POST);

            request.AddFile("input_watermark", inputWatermark, MimeTypes.GetMimeType(inputWatermark));
            request.AddParameter("watermark_transparency", watermarkTransparency.ToString("R", CultureInfo.InvariantCulture));
            request.AddParameter("watermark_ratio", watermarkRatio.ToString("R", CultureInfo.InvariantCulture));
            request.AddParameter("watermark_position_preset", watermarkPositionPreset);

            return this.PostService(request, "innovation-service/watermark", new string[1] { inputMedia })["watermark_job_id"];
        }

        /// <summary>
        /// A method to get a Watermark job status (and result/error if the job is ended).
        /// </summary>
        /// <param name="watermarkJobId"></param>
        /// <returns>a WatermarkResponse</returns>
        public WatermarkResponse WatermarkGetJobStatus(WatermarkJobId watermarkJobId)
        {
            return this.GetJobStatus<WatermarkResponse>(watermarkJobId, "watermark_job_id", "innovation-service/watermark");
        }

        /// <summary>
        /// A method to create a Vehicules And Pedestrians job.
        /// </summary>
        /// <param name="inputMedia"></param>
        /// <param name="expectedClassNames"></param>
        /// <param name="detectionArea"></param>
        /// <returns>a job id</returns>
        public VehiclesPedestriansDetectionJobId VehiclesPedestriansDetectionCreateJob(string inputMedia, Vehicle[] expectedClassNames = null, Point[] detectionArea = null)
        {
            var request = new RestRequest(Method.POST);

            if (expectedClassNames is not null)
            {
                request.AddParameter("expected_class_names", JsonSerializer.Serialize(expectedClassNames, this.json_options));
            }
            if (detectionArea is not null)
            {
                request.AddParameter("detection_area", JsonSerializer.Serialize(detectionArea, this.json_options));
            }
            return this.PostService(request, "innovation-service/vehicles-pedestrians-detection", new string[1] { inputMedia })["vehicle_pedestrian_detection_job_id"];
        }

        /// <summary>
        /// A method to get an Vehicules And Pedestrians job status (and result/error if the job is ended).
        /// </summary>
        /// <param name="vehiclesPedestriansDetectionJobId"></param>
        /// <returns>a VehiclesPedestriansDetectionResponse</returns>
        public VehiclesPedestriansDetectionResponse VehiclesPedestriansDetectionGetJobStatus(VehiclesPedestriansDetectionJobId vehiclesPedestriansDetectionJobId)
        {
            return this.GetJobStatus<VehiclesPedestriansDetectionResponse>(vehiclesPedestriansDetectionJobId, "vehicle_pedestrian_detection_job_id", "innovation-service/vehicles-pedestrians-detection");
        }

        /// <summary>
        ///  A method to create an Orientation job.
        /// </summary>
        /// <param name="inputMedia"></param>
        /// <returns>a job id</returns>
        public OrientationJobId OrientationCreateJob(string inputMedia)
        {
            var request = new RestRequest(Method.POST);

            return this.PostService(request, "innovation-service/orientation", new string[1] { inputMedia })["orientation_job_id"];
        }

        /// <summary>
        /// A method to get an Orientation job status (and result/error if the job is ended).
        /// </summary>
        /// <param name="orientationJobId"></param>
        /// <returns>an OrientationResponse</returns>
        public OrientationResponse OrientationGetJobStatus(OrientationJobId orientationJobId)
        {
            return this.GetJobStatus<OrientationResponse>(orientationJobId, "orientation_job_id", "innovation-service/orientation");
        }

        /// <summary>
        /// A method to create a Faces Attributes job.
        /// </summary>
        /// <param name="inputMedia"></param>
        /// <param name="detectionArea"></param>
        /// <returns>a job id</returns>
        public FacesAttributesJobId FacesAttributesCreateJob(string inputMedia, Point[] detectionArea = null)
        {
            var request = new RestRequest(Method.POST);

            if (detectionArea is not null)
            {
                request.AddParameter("detection_area", JsonSerializer.Serialize(detectionArea, this.json_options));
            }
            return this.PostService(request, "innovation-service/faces-attributes", new string[1] { inputMedia })["faces_attributes_job_id"];
        }

        /// <summary>
        /// A method to get a Faces Attributes job status (and result/error if the job is ended).
        /// </summary>
        /// <param name="facesAttributesJobId"></param>
        /// <returns>an FacesAttributesResponse</returns>
        public FacesAttributesResponse FacesAttributesGetJobStatus(FacesAttributesJobId facesAttributesJobId)
        {
            return this.GetJobStatus<FacesAttributesResponse>(facesAttributesJobId, "faces_attributes_job_id", "innovation-service/faces-attributes");
        }

        /// <summary>
        /// A method to create an Identity creation job.
        /// </summary>
        /// <param name="inputImages"></param>
        /// <returns>a job id</returns>
        public IdentityJobId IdentityCreateJob(string[] inputImages)
        {
            var request = new RestRequest(Method.POST);

            return this.PostService(request, "innovation-service/identity", inputImages, "input_images")["job_id"];
        }

        /// <summary>
        /// A method to create a Identity update job.
        /// </summary>
        /// <param name="inputImages"></param>
        /// <param name="identityId"></param>
        /// <returns>a job id</returns>
        public string IdentityCreateAddImageJob(string[] inputImages, string identityId)
        {
            var request = new RestRequest(Method.PUT);

            request.AddParameter("identity_id", identityId);

            return this.PostService(request, "innovation-service/identity", inputImages, "input_images")["job_id"];
        }

        /// <summary>
        /// A method to get an Identity creation/update job status (and result/error if the job is ended).
        /// </summary>
        /// <param name="identityJobId"></param>
        /// <returns>an IdentityResponse</returns>
        public IdentityResponse IdentityGetJobStatus(IdentityJobId identityJobId)
        {
            return this.GetJobStatus<IdentityResponse>(identityJobId, "job_id", "innovation-service/identity");
        }

        /// <summary>
        /// A method to delete an Identity.
        /// </summary>
        /// <param name="identityId"></param>
        public void IdentityDeleteIdentities(string[] identityId)
        {
            var client = new RestClient(this.url + $"/innovation-service/identity");
            client.Timeout = -1;

            var request = new RestRequest(Method.DELETE);
            request.AddHeader("Authorization", $"Bearer {this.connection.token}");


            IDictionary<string, string[]> identities = new Dictionary<string, string[]>();
            identities.Add("identity_id", identityId);
            request.AddParameter("application/json", JsonSerializer.Serialize(identities, this.json_options), ParameterType.RequestBody);

            IRestResponse response = client.Execute(request);

            if (response.StatusCode != System.Net.HttpStatusCode.NoContent)
            {
                Error error = JsonSerializer.Deserialize<Error>(response.Content);
                throw new WISException(error.message);
            }
        }

        /// <summary>
        /// A method to create an Identity search job.
        /// </summary>
        /// <param name="inputImage"></param>
        /// <param name="maxResult"></param>
        /// <returns>a job id</returns>
        public IdentitySearchJobId IdentityCreateSearchJob(string inputImage, int maxResult)
        {
            var request = new RestRequest(Method.POST);

            request.AddParameter("max_result", maxResult);

            return this.PostService(request, "innovation-service/identity/search", new string[1] { inputImage }, "input_image")["job_id"];
        }

        /// <summary>
        /// A method to get an Identity search job status (and result/error if the job is ended).
        /// </summary>
        /// <param name="identitySearchJobId"></param>
        /// <returns>an IdentitySearchResponse</returns>
        public IdentitySearchResponse IdentityGetSearchJobStatus(IdentitySearchJobId identitySearchJobId)
        {
            return this.GetJobStatus<IdentitySearchResponse>(identitySearchJobId, "job_id", "innovation-service/identity/search");
        }

        /// <summary>
        /// A method to create an Identity recognition job.
        /// </summary>
        /// <param name="inputImage"></param>
        /// <param name="identityId"></param>
        /// <returns>a job id</returns>
        public IdentityRecognizeJobId IdentityCreateRecognizeJob(string inputImage, string identityId)
        {
            var request = new RestRequest(Method.POST);

            request.AddParameter("identity_id", identityId);

            return this.PostService(request, "innovation-service/identity/recognize", new string[1] { inputImage }, "input_image")["job_id"];
        }

        /// <summary>
        /// A method to get an Identity recognition job status (and result/error if the job is ended).
        /// </summary>
        /// <param name="identityRecognizeJobId"></param>
        /// <returns>an IdentityRecognizeResponse</returns>
        public IdentityRecognizeResponse IdentityGetRecognizeJobStatus(IdentityRecognizeJobId identityRecognizeJobId)
        {
            return this.GetJobStatus<IdentityRecognizeResponse>(identityRecognizeJobId, "job_id", "innovation-service/identity/recognize");
        }
    }
}