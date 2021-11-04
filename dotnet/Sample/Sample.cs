using RestSharp;
using System;
using System.Collections.Generic;
using System.Threading;
using System.Text.Json;
using System.Linq;
using System.IO;

namespace Wassa.InnovationServices
{
    class Program
    {
        static Program(){
            Program.WaitStatuses = new List<JobStatus>();
            Program.WaitStatuses.Add(JobStatus.SENT);
            Program.WaitStatuses.Add(JobStatus.STARTED);
            Program.WaitStatuses.Add(JobStatus.RETRIED);
        }

        private static readonly List<JobStatus> WaitStatuses;

        static void Main(string[] args)
        {
            string clientId = "YOUR_CLIENT_ID_HERE";
            string secretId = "YOUR_SECRET_ID_HERE";

            WIS wisConnection = new WIS(clientId, secretId);


            Program.CongestionDemo(wisConnection);
            Program.IdentityDemo(wisConnection);
            Program.FaceAttributesDemo(wisConnection);
            Program.SoilingDemo(wisConnection);
            AnonymizationResponse result = Program.AnonymizationDemo(wisConnection);
            string resultFileName = result.outputMedia.Split('/').Last();
            Program.GetResultFile(wisConnection,resultFileName);
            Program.WatermarkDemo(wisConnection);
            Program.VehiclesPedestriansDemo(wisConnection);

        }

        public static void CongestionDemo(WIS wisConnection){
            // Create a line that crosses the image from bottom midle to midle top right
            Point[] line = new Point[] { new Point(0.5, 1), new Point(0.9, 0.3) };

            // Create a box selectin the right half part of the image
            Box includingBox = new Box(0.5, 0, 1, 1);

            // Apply congestion job to the right half part of the image
            CongestionJobId jobId = wisConnection.CongestionCreateJob("images/street.jpg", line, includingBox);
            line = null;

            CongestionResponse result = null;
            // Pulling the job status until it is ended
            while (result is null || Program.WaitStatuses.Contains(result.status))
            {
                Thread.Sleep(1000);
                result = wisConnection.CongestionGetJobStatus(jobId);
                Console.WriteLine($"Congestion {result.status}");
            }

            // print every detected vehicles in the image
            Console.WriteLine($"Vehicles: {string.Join(", ", result.vehicles)}");
        }

        public static void IdentityDemo(WIS wisConnection) {
             // Create an identity job.
            IdentityJobId jobId = wisConnection.IdentityCreateJob(
                new string[3] {
                    "images/identity/profil1_face1.png",
                    "images/identity/profil1_face2.png",
                    "images/identity/profil1_face3.png"
                }
            );

            IdentityResponse identityResult = null;
            // Pulling the job status until it is ended
            while (identityResult is null || Program.WaitStatuses.Contains(identityResult.status))
            {
                Thread.Sleep(1000);
                identityResult = wisConnection.IdentityGetJobStatus(jobId);
                Console.WriteLine($"Identity Create {identityResult.status}");
            }
            Console.WriteLine($"Created identity {identityResult.identityId}");

            // Create an identity update job (adds images to the identity)
            jobId = wisConnection.IdentityCreateAddImageJob(
                new string[2] {
                    "images/identity/profil1_face4.png",
                    "images/identity/profil1_face5.png"
                },
                identityResult.identityId
            );

            identityResult = null;
            // Pulling the job status until it is ended
            while (identityResult is null || Program.WaitStatuses.Contains(identityResult.status))
            {
                Thread.Sleep(1000);
                identityResult = wisConnection.IdentityGetJobStatus(jobId);
                Console.WriteLine($"Identity Update {identityResult.status}");
            }
            Console.WriteLine($"Updated identity {identityResult.identityId}");

            // Search an identity based on an image (max results: 1)
            IdentitySearchJobId searchJobId = wisConnection.IdentityCreateSearchJob("images/identity/profil1_face6.png", 1);

            IdentitySearchResponse identitySearchResult = null;
            // Pulling the job status until it is ended
            while (identitySearchResult is null || Program.WaitStatuses.Contains(identitySearchResult.status))
            {
                Thread.Sleep(1000);
                identitySearchResult = wisConnection.IdentityGetSearchJobStatus(searchJobId);
                Console.WriteLine($"Identity Search {identitySearchResult.status}");
            }
            // print the best found identity
            Console.WriteLine($"Best found identity {identitySearchResult.results[0].identityId} (score: {identitySearchResult.results[0].score})");

            // test if an image matches to a given identity
            IdentityRecognizeJobId recogJobId = wisConnection.IdentityCreateRecognizeJob("images/identity/profil1_face6.png", identityResult.identityId);

            IdentityRecognizeResponse identityRecognizeResult = null;
            // Pulling the job status until it is ended
            while (identityRecognizeResult is null || Program.WaitStatuses.Contains(identityRecognizeResult.status))
            {
                Thread.Sleep(1000);
                identityRecognizeResult = wisConnection.IdentityGetRecognizeJobStatus(recogJobId);
                Console.WriteLine($"Identity Recognize {identityRecognizeResult.status}");
            }
            // print the result of Recognize
            Console.WriteLine($"Identity {identityRecognizeResult.results.identityId} matching: {identityRecognizeResult.results.recognition} (score: {identityRecognizeResult.results.score})");

            // delete the identity
            wisConnection.IdentityDeleteIdentities(new string[1] { identityResult.identityId });
            Console.WriteLine($"Deleted identity {identityResult.identityId}");
        }

        public static void FaceAttributesDemo(WIS wisConnection) {
            // Process only the left half of the image
            Point[] detectionArea = new Point[] {
                new Point(0, 0),
                new Point(0.5, 0),
                new Point(0.5, 1),
                new Point(0, 1)
            };
            // Create an faces attributes job.
            FacesAttributesJobId jobId = wisConnection.FacesAttributesCreateJob("images/people.jpg", detectionArea);

            Response result = null;
            // Pulling the job status until it is ended
            while (result is null || Program.WaitStatuses.Contains(result.status))
            {
                Thread.Sleep(1000);
                result = wisConnection.FacesAttributesGetJobStatus(jobId);
                Console.WriteLine($"Faces Attributes {result.status}");
            }
            FacesAttributesResponse facesResult = (FacesAttributesResponse)result;

        }

        public static void SoilingDemo(WIS wisConnection){

            // create soiling area
            Point[] detectionArea = new Point[] {
                new Point(0, 0.7),
                new Point(1, 0.7),
                new Point(1, 1),
                new Point(0, 1)
            };

            SoilingJobId jobId = wisConnection.SoilingCreateJob("images/street.jpg", detectionArea);

            SoilingResponse result = null;
            // Pulling the job status until it is ended
            while (result is null || Program.WaitStatuses.Contains(result.status))
            {
                Thread.Sleep(1000);
                result = wisConnection.SoilingGetJobStatus(jobId);
                Console.WriteLine($"Soiling {result.status}");
            }

            // print every type of soiling values
            Console.WriteLine($"dust: {result.soilingResult.dust}, dirt: {result.soilingResult.dirt}, gravel: {result.soilingResult.gravel}, clod: {result.soilingResult.clod}");

        }

        public static AnonymizationResponse AnonymizationDemo(WIS wisConnection){

            // Create a box selecting the right half part of the image
            Box includingBox = new Box(0.5, 0, 1, 1);

            // Create a plates + faces anonymization job, on the right half of the image. It will also export the detections list as a JSON file.
            AnonymizationJobId jobId = wisConnection.AnonymizationCreateJob("images/street.jpg", true, true, true, includingBox);

            AnonymizationResponse  result = null;
            // Pulling the job status until it is ended
            while (result is null || Program.WaitStatuses.Contains(result.status))
            {
                Thread.Sleep(1000);
                result = wisConnection.AnonymizationGetJobStatus(jobId);
                Console.WriteLine($"Anonymization {result.status}");
            }

            // print output files URLs
            Console.WriteLine($"Anonymized image: {result.outputMedia}\nDetections JSON: {result.outputJson}");
            return result;
        }

        public static void GetResultFile(WIS wisConnection, string resultFileName){
            // This function will get the whole file in ram before writing it.
            // You should better use a stream for downloading files.
            // You can look at this function implementation to understand how to call the files results route.
            byte[] file = wisConnection.GetResultFile(resultFileName);
            // Write bytes in a file
            File.WriteAllBytes($"/tmp/{resultFileName}", file);
            Console.WriteLine($"Downloaded anonymized image /tmp/{resultFileName}");
        }

        public static void WatermarkDemo(WIS wisConnection){
            // Create a watermark job.
            WatermarkJobId jobId = wisConnection.WatermarkCreateJob("images/street.jpg", "images/logo-wassa.png", 0.8, 0.1, WatermarkPosition.lower_right);

            WatermarkResponse result = null;
            // Pulling the job status until it is ended
            while (result is null || Program.WaitStatuses.Contains(result.status))
            {
                Thread.Sleep(1000);
                result = wisConnection.WatermarkGetJobStatus(jobId);
                Console.WriteLine($"Watermark {result.status}");
            }

            // print output files URLs
            Console.WriteLine($"Watermarked image: {result.outputImageUrl}");
        }

        public static void VehiclesPedestriansDemo(WIS wisConnection)
        {
            // Select every type of vehicles + pedestrians
            Vehicle[] vehicules = new Vehicle[] {
                Vehicle.pedestrian,
                Vehicle.car,
                Vehicle.truck,
                Vehicle.bus,
                Vehicle.motorcycle,
                Vehicle.bicycle
            };
            // Process only the right half of the image
            Point[] detectionArea = new Point[] {
                new Point(0.5, 0),
                new Point(1, 0),
                new Point(1, 1),
                new Point(0.5, 1)
            };
            // Create a vehicules & pedestrians detection job.
            VehiclesPedestriansDetectionJobId jobId = wisConnection.VehiclesPedestriansDetectionCreateJob("images/street.jpg", vehicules, null);

            VehiclesPedestriansDetectionResponse result = null;
            // Pulling the job status until it is ended
            while (result is null || Program.WaitStatuses.Contains(result.status))
            {
                Thread.Sleep(1000);
                result = wisConnection.VehiclesPedestriansDetectionGetJobStatus(jobId);
                Console.WriteLine($"Vehicules & Pedestrians {result.status}");
            }
            VPDObjectCounting result_vap = result.objectCounting;

            // print objects countings
            Console.WriteLine($"pedestrian: {result_vap.pedestrian}, bicycle: {result_vap.bicycle}, car: {result_vap.car}, motorcycle: {result_vap.motorcycle}, bus: {result_vap.bus}, truck: {result_vap.truck}");

        }

        public static void OrientationDemo(WIS wisConnection)
        {
            OrientationJobId jobId = wisConnection.OrientationCreateJob("images/street.jpg");

            OrientationResponse result = null;
            // Pulling the job status until it is ended
            while (result is null || Program.WaitStatuses.Contains(result.status))
            {
                Thread.Sleep(1000);
                result = wisConnection.OrientationGetJobStatus(jobId);
                Console.WriteLine($"Orientation {result.status}");
            }
            // print objects countings
            Console.WriteLine($"Orientation: {result.label}");
        }

        }

}
