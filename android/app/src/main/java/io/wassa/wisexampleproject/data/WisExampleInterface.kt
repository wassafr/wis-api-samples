package io.wassa.wisexampleproject.data

import io.reactivex.rxjava3.core.Completable
import io.reactivex.rxjava3.core.Single
import io.wassa.wisexampleproject.model.IdentityDeleteRequest
import io.wassa.wisexampleproject.model.Token
import io.wassa.wisexampleproject.model.response.*
import okhttp3.MultipartBody
import okhttp3.RequestBody
import okhttp3.ResponseBody
import retrofit2.http.*

interface WisExampleInterface {

    @POST("/login")
    fun login(
        @Body token: Token?
    ): Single<Token>

    @POST("/logout")
    fun logout(): Single<Void>

    @POST("/token")
    fun refreshToken(@Body token: Token?): Single<Token>

    @POST("/innovation-service/congestion")
    @Multipart
    fun congestionCreateJob(
        @Part picture: MultipartBody.Part,
        @Part congestionLine: MultipartBody.Part,
        @Part includedArea: MultipartBody.Part?
    ): Single<Map<String, String>>

    @GET("/innovation-service/congestion")
    fun congestionGetJobStatus(@Query("congestion_job_id") congestionJobId: String): Single<CongestionResponse>

    @POST("/innovation-service/soiling")
    @Multipart
    fun soilingCreateJob(
        @Part picture: MultipartBody.Part,
        @Part soilingArea: MultipartBody.Part?
    ): Single<Map<String, String>>

    @GET("/innovation-service/soiling")
    fun soilingGetJobStatus(@Query("soiling_job_id") soilingJobId: String): Single<SoilingResponse>

    @POST("/innovation-service/anonymization")
    @Multipart
    fun anonymizationCreateJob(
        @Part picture: MultipartBody.Part,
        @Part activationFacesBlur: MultipartBody.Part?,
        @Part activationPlatesBlur: MultipartBody.Part?,
        @Part outputDetectionsUrl: MultipartBody.Part?,
        @Part includedArea: MultipartBody.Part?
    ): Single<Map<String, String>>

    @GET("/innovation-service/anonymization")
    fun anonymizationGetJobStatus(@Query("anonymization_job_id") anonymizationJobId: String): Single<AnonymizationResponse>

    @POST("/innovation-service/watermark")
    @Multipart
    fun watermarkCreateJob(
        @Part picture: MultipartBody.Part,
        @Part inputWatermark: MultipartBody.Part,
        @Part watermarkTransparency: MultipartBody.Part,
        @Part watermarkRatio: MultipartBody.Part,
        @Part watermarkPositionPreset: MultipartBody.Part
    ): Single<Map<String, String>>

    @GET("/innovation-service/watermark")
    fun watermarkGetJobStatus(@Query("watermark_job_id") watermarkJobId: String): Single<WatermarkResponse>

    @POST("/innovation-service/vehicles-pedestrians-detection")
    @Multipart
    fun vehiclesPedestriansDetectionCreateJob(
        @Part picture: MultipartBody.Part,
        @Part expectedClassNames: MultipartBody.Part?,
        @Part detectionArea: MultipartBody.Part?
    ): Single<Map<String, String>>

    @GET("/innovation-service/vehicles-pedestrians-detection")
    fun vehiclesPedestriansDetectionGetJobStatus(@Query("vehicle_pedestrian_detection_job_id") vehiclePedestrianDetectionJobId: String): Single<VehiclePedestrianDetectionResponse>

    @POST("/innovation-service/orientation")
    @Multipart
    fun orientationCreateJob(@Part picture: MultipartBody.Part): Single<Map<String, String>>

    @GET("/innovation-service/orientation")
    fun orientationGetJobStatus(@Query("orientation_job_id") orientationJobId: String): Single<OrientationResponse>

    @POST("/innovation-service/faces-attributes")
    @Multipart
    fun facesAttributesCreateJob(
        @Part picture: MultipartBody.Part,
        @Part detectionArea: MultipartBody.Part?
    ): Single<Map<String, String>>

    @GET("/innovation-service/faces-attributes")
    fun facesAttributesJobStatus(@Query("faces_attributes_job_id") facesAttributesJobId: String): Single<FacesAttributesResponse>

    @POST("/innovation-service/identity")
    @Multipart
    fun identityCreateJob(@Part inputImages: List<MultipartBody.Part>): Single<Map<String, String>>

    @GET("/innovation-service/identity")
    fun identityGetJobStatus(@Query("job_id") jobId: String): Single<IdentityResponse>

    @HTTP(method = "DELETE", path = "/innovation-service/identity", hasBody = true)
    fun identityDeleteIdentities(@Body body: IdentityDeleteRequest): Completable

    @PUT("/innovation-service/identity")
    @Multipart
    fun identityCreateAddImageJob(
        @Part inputImages: List<MultipartBody.Part>,
        @Part identityId: MultipartBody.Part
    ): Single<Map<String, String>>

    @POST("/innovation-service/identity/search")
    @Multipart
    fun identityCreateSearchJob(
        @Part inputImages: MultipartBody.Part,
        @Part maxResult: MultipartBody.Part
    ): Single<Map<String, String>>

    @GET("/innovation-service/identity/search")
    fun identityGetSearchJobStatus(@Query("job_id") jobId: String): Single<IdentitySearchResponse>

    @POST("/innovation-service/identity/recognize")
    @Multipart
    fun identityCreateRecognizeJob(
        @Part inputImages: MultipartBody.Part,
        @Part identityId: MultipartBody.Part
    ): Single<Map<String, String>>

    @GET("/innovation-service/identity/recognize")
    fun identityGetRecognizeJobStatus(@Query("job_id") jobId: String): Single<IdentityRecognizeResponse>

}