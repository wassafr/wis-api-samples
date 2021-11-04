package io.wassa.wisexampleproject.data

import android.content.ContentResolver
import android.content.Context
import android.net.Uri
import android.util.Log
import android.webkit.MimeTypeMap
import androidx.core.net.toUri
import com.google.gson.Gson
import com.google.gson.GsonBuilder
import io.reactivex.rxjava3.android.schedulers.AndroidSchedulers
import io.reactivex.rxjava3.core.Completable
import io.reactivex.rxjava3.core.Single
import io.reactivex.rxjava3.schedulers.Schedulers
import io.wassa.wisexampleproject.model.*
import io.wassa.wisexampleproject.model.response.*
import okhttp3.MediaType.Companion.toMediaTypeOrNull
import okhttp3.MultipartBody
import okhttp3.OkHttpClient
import okhttp3.RequestBody
import okhttp3.RequestBody.Companion.asRequestBody
import okhttp3.logging.HttpLoggingInterceptor
import retrofit2.Retrofit
import retrofit2.adapter.rxjava3.RxJava3CallAdapterFactory
import retrofit2.converter.gson.GsonConverterFactory
import retrofit2.http.*
import java.io.File
import java.util.*
import java.util.concurrent.TimeUnit


class WisExampleClient(val appContext: Context) {

    protected var client: WisExampleInterface

    //http interceptor to be able to log the body of the http requests
    private val httpLoggingInterceptor = HttpLoggingInterceptor()
        .setLevel(HttpLoggingInterceptor.Level.BODY)

    protected var token: Token? = null

    /**
     * constructor for Api Client
     */
    init {
        client = initializeRetrofitClient()
    }

    open fun initializeRetrofitClient(): WisExampleInterface {
        val retrofit = Retrofit.Builder()
            .baseUrl("https://api.services.wassa.io")
            .client(
                getOkHttpClient(
                    mapOf(
                        Pair(CONTENT_TYPE_KEY, CONTENT_TYPE_VALUE),
                        Pair(LANGUAGE_TYPE_KEY, Locale.getDefault().language)
                    )
                )
            )
            .addCallAdapterFactory(RxJava3CallAdapterFactory.create())
        retrofit.addConverterFactory(
            GsonConverterFactory
                .create(
                    GsonBuilder()
                        .enableComplexMapKeySerialization()
                        .serializeNulls()
                        .setDateFormat(WASSA_DATE_FORMAT)
                        .setPrettyPrinting().create()
                )
        )
        client = retrofit.build().create(WisExampleInterface::class.java)
        return client
    }

    /**
     * get OkHttpClient
     * sets connection timeout and read timeout with [TIMEOUT_SEC]
     *
     * @param headers          http request headers
     * @return {@link OkHttpClient}
     */
    protected open fun getOkHttpClient(headers: Map<String, String>?): OkHttpClient {

        val builder = OkHttpClient.Builder()
            .readTimeout(TIMEOUT_SEC.toLong(), TimeUnit.SECONDS)
            .connectTimeout(TIMEOUT_SEC.toLong(), TimeUnit.SECONDS)
            .addInterceptor(httpLoggingInterceptor)
            .addInterceptor {
                var request = it.request()
                if (token != null)
                    request = request.newBuilder().addHeader(
                        AUTHORIZATION_KEY,
                        "$BEARER_KEY${token?.token}"
                    ).build()
                it.proceed(request)
            }
            .addInterceptor { chain ->
                val response = chain.proceed(chain.request())
                if (response.code == 401 && chain.request().url.pathSegments.last() != "token") {
                    var userCredential: Token? = null
                    try {
                        response.close()
                        userCredential =
                            refreshToken(token).blockingGet()
                    } catch (e: Exception) {
                        Log.e(TAG, "Unable to refresh token", e)
                    }
                    token = userCredential

                    val request = chain.request().newBuilder()
                        .removeHeader(AUTHORIZATION_KEY)
                        .addHeader(AUTHORIZATION_KEY, "$BEARER_KEY${userCredential?.token}")
                        .build()
                    chain.proceed(request)
                } else
                    response
            }

        onCreateOkHttpClient(builder)

        return builder.build()
    }

    protected open fun onCreateOkHttpClient(builder: OkHttpClient.Builder): OkHttpClient.Builder {
        return builder
    }


    /**
     * /login
     *
     * Auth Mode : No Auth
     *
     * Login to Wassa Innovation Services API.
     * You will retrieve a token that need to be use in all other routes.
     */
    fun login(clientId: String?, secretId: String?): Single<Token> {
        return client.login(Token(clientId, secretId)).map {
            token = it
            it
        }
            .observeOn(AndroidSchedulers.mainThread())
            .subscribeOn(Schedulers.io())
    }

    /**
     * /logout
     * Logout of Wassa Innovation Services API
     *
     * Auth Mode : Bearer
     *
     * Close session from WIS, and invalidate token.
     * If not used, session will close after the timeout returned by login.
     * Notice that you should pass token (even expried) in authentication process as bearer token, as any other routes.
     */
    fun logout(): Single<Void> {
        return client.logout()
            .observeOn(AndroidSchedulers.mainThread())
            .subscribeOn(Schedulers.io())
    }

    /**
     * /token
     * Refresh an expired token
     *
     * Auth Mode : Bearer
     *
     * Refresh the access token of a User
     * The Bearer token can be expired.
     * Notice that you should pass token (even expried) in authentication process as bearer token, as any other routes.
     */
    fun refreshToken(refreshToken: Token?): Single<Token> {
        return client.refreshToken(refreshToken)
            .observeOn(AndroidSchedulers.mainThread())
            .subscribeOn(Schedulers.io())
    }

    /**
     * /innovation-service/congestion
     * Ask to start a congestion job
     *
     * Auth Mode : Bearer
     *
     * This route will create a congestion detection job.
     */
    fun congestionCreateJob(file: File, line: List<Point>, area: Area? = null): Single<String?> {
        val pictureBody: RequestBody = file
            .asRequestBody(getMimeType(file.toUri()).toMediaTypeOrNull())
        val picture = MultipartBody.Part.createFormData("picture", file.name, pictureBody)
        val areaBody = if (area != null)
            MultipartBody.Part.createFormData("included_area", Gson().toJson(area))
        else null
        val lineBody = MultipartBody.Part.createFormData(
            "congestion_line",
            Gson().toJson(line)
        )
        return client.congestionCreateJob(picture, lineBody, areaBody).map {
            it.values.firstOrNull()
        }.observeOn(AndroidSchedulers.mainThread())
            .subscribeOn(Schedulers.io())
    }

    /**
     * /innovation-service/congestion
     * Get the status of a congestion job
     *
     * Auth Mode : Bearer
     *
     * Return the job status.
     * In case of success response will contains a list of detected vehicules
     */
    fun congestionGetJobStatus(jobId: String): Single<CongestionResponse> {
        return client.congestionGetJobStatus(jobId)
            .observeOn(AndroidSchedulers.mainThread())
            .subscribeOn(Schedulers.io())
    }

    /**
     * /innovation-service/soiling
     * Ask to start a soiling detection job
     *
     * Auth Mode : Bearer
     *
     * This route will create a soiling detection job.
     */
    fun soilingCreateJob(file: File, area: List<Point>? = null): Single<String?> {
        val pictureBody: RequestBody = file
            .asRequestBody(getMimeType(file.toUri()).toMediaTypeOrNull())
        val picture = MultipartBody.Part.createFormData("picture", file.name, pictureBody)
        val areaBody = if (area != null)
            MultipartBody.Part.createFormData("soiling_area", Gson().toJson(area))
        else null
        return client.soilingCreateJob(picture, areaBody).map {
            it.values.firstOrNull()
        }.observeOn(AndroidSchedulers.mainThread())
            .subscribeOn(Schedulers.io())
    }

    /**
     * /innovation-service/soiling
     * Get the status of a soiling job
     *
     * Auth Mode : Bearer
     *
     * Return the job status.
     * In case of success response will contains a list of soil scores.
     */
    fun soilingGetJobStatus(jobId: String): Single<SoilingResponse> {
        return client.soilingGetJobStatus(jobId)
            .observeOn(AndroidSchedulers.mainThread())
            .subscribeOn(Schedulers.io())
    }

    /**
     * /innovation-service/anonymization
     * Ask to start a anonymization job
     *
     * Auth Mode : Bearer
     *
     * This route will create a job for bluring faces and/or plates of an image.
     */
    fun anonymizationCreateJob(
        file: File,
        activationFacesBlur: Boolean,
        activationPlatesBlur: Boolean,
        outputDetectionsUrl: Boolean,
        area: Area? = null
    ): Single<String?> {
        val pictureBody: RequestBody = file
            .asRequestBody(getMimeType(file.toUri()).toMediaTypeOrNull())
        val picture = MultipartBody.Part.createFormData("input_media", file.name, pictureBody)
        val activationFacesBlurBody =
            MultipartBody.Part.createFormData("activation_faces_blur", Gson().toJson(activationFacesBlur))
        val activationPlatesBlurBody =
            MultipartBody.Part.createFormData("activation_plates_blur", Gson().toJson(activationPlatesBlur))
        val outputDetectionsUrlBody =
            MultipartBody.Part.createFormData("output_detections_url", Gson().toJson(outputDetectionsUrl))
        val areaBody = if (area != null)
            MultipartBody.Part.createFormData("included_area", Gson().toJson(area))
        else null
        return client.anonymizationCreateJob(picture, activationFacesBlurBody, activationPlatesBlurBody, outputDetectionsUrlBody, areaBody).map {
            it.values.firstOrNull()
        }.observeOn(AndroidSchedulers.mainThread())
            .subscribeOn(Schedulers.io())
    }

    /**
     * /innovation-service/anonymization
     * Get the status of a anonymization job
     *
     * Auth Mode : Bearer
     *
     * Return the job status.
     * In case of success response will contains an url to an image (output_image_url). This image need to be retrieve with /innovation-service/result/{fileName}
     */
    fun anonymizationGetJobStatus(jobId: String): Single<AnonymizationResponse> {
        return client.anonymizationGetJobStatus(jobId)
            .observeOn(AndroidSchedulers.mainThread())
            .subscribeOn(Schedulers.io())
    }

    /**
     * /innovation-service/watermark
     * Ask to start a watermark job
     *
     * Auth Mode : Bearer
     *
     * This route will create a job for overlay an image (watermark) over another image (input media), with a few customisation parameters.
     */
    fun watermarkCreateJob(inputMedia: File,
                           inputWatermark: File,
                           watermarkTransparency: Double,
                           watermarkRatio: Double,
                           watermarkPositionPreset: WatermarkPreset): Single<String?> {
        val mediaBody: RequestBody = inputMedia
            .asRequestBody(getMimeType(inputMedia.toUri()).toMediaTypeOrNull())
        val media = MultipartBody.Part.createFormData("input_media", inputMedia.name, mediaBody)
        val watermarkBody: RequestBody = inputWatermark
            .asRequestBody(getMimeType(inputWatermark.toUri()).toMediaTypeOrNull())
        val watermark = MultipartBody.Part.createFormData("input_watermark", inputWatermark.name, watermarkBody)
        val watermarkTransparencyBody =
            MultipartBody.Part.createFormData("watermark_transparency", Gson().toJson(watermarkTransparency))
        val watermarkRatioBody =
            MultipartBody.Part.createFormData("watermark_ratio", Gson().toJson(watermarkRatio))
        val watermarkPositionPresetBody =
            MultipartBody.Part.createFormData("watermark_position_preset", Gson().toJson(watermarkPositionPreset).replace("\"", ""))
        return client.watermarkCreateJob(media, watermark, watermarkTransparencyBody, watermarkRatioBody, watermarkPositionPresetBody).map {
            it.values.firstOrNull()
        } .observeOn(AndroidSchedulers.mainThread())
            .subscribeOn(Schedulers.io())
    }

    /**
     * /innovation-service/watermark
     * Get the status of a watermark job
     *
     * Auth Mode : Bearer
     *
     * Return the job status.
     * In case of success response will contains an url to an image (output_image_url). This image need to be retrieve with /innovation-service/result/{fileName}
     */
    fun watermarkGetJobStatus(jobId: String): Single<WatermarkResponse> {
        return client.watermarkGetJobStatus(jobId)
            .observeOn(AndroidSchedulers.mainThread())
            .subscribeOn(Schedulers.io())
    }

    /**
     * /innovation-service/vehicles-pedestrians-detection
     * Ask to start a vehicles and pedestrians detection job
     *
     * Auth Mode : Bearer
     *
     * This route will start a job, to detect all pedestrian, bicycle, cars, trucks, busses, motorcycle, present on image.
     * Each result will be associated with coordinates on original image and acuracy.
     */
    fun vehiclesPedestriansDetectionCreateJob(inputMedia: File,expectedClass: List<VehicleType>? = null, area: List<Point>? = null): Single<String?> {
        val mediaBody: RequestBody = inputMedia
            .asRequestBody(getMimeType(inputMedia.toUri()).toMediaTypeOrNull())
        val media = MultipartBody.Part.createFormData("input_media", inputMedia.name, mediaBody)

        val expectedClassBody = if (expectedClass != null)
            MultipartBody.Part.createFormData("expected_class_names", Gson().toJson(expectedClass))
        else null
        val areaBody = if (area != null)
            MultipartBody.Part.createFormData("soiling_area", Gson().toJson(area))
        else null
        return client.vehiclesPedestriansDetectionCreateJob(media, expectedClassBody, areaBody).map {
            it.values.firstOrNull()
        } .observeOn(AndroidSchedulers.mainThread())
            .subscribeOn(Schedulers.io())
    }

    /**
     * /innovation-service/vehicles-pedestrians-detection
     * Get the status of a vehicles and pedestrians detection job
     *
     * Auth Mode : Bearer
     *
     * Return the job status.
     * In case of success response will contains a list of pedestrian and vehicule detected, with position on images, and accuracy scores.
     */
    fun vehiclesPedestriansDetectionGetJobStatus(jobId: String): Single<VehiclePedestrianDetectionResponse> {
        return client.vehiclesPedestriansDetectionGetJobStatus(jobId)
            .observeOn(AndroidSchedulers.mainThread())
            .subscribeOn(Schedulers.io())
    }

    /**
     * /innovation-service/orientation
     * Ask to start a image orientation job
     *
     * Auth Mode : Bearer
     *
     * This route will start an detection of orientation of an image.
     */
    fun orientationCreateJob(inputMedia: File): Single<String?> {
        val mediaBody: RequestBody = inputMedia
            .asRequestBody(getMimeType(inputMedia.toUri()).toMediaTypeOrNull())
        val media = MultipartBody.Part.createFormData("input_media", inputMedia.name, mediaBody)
        return client.orientationCreateJob(media).map {
            it.values.firstOrNull()
        } .observeOn(AndroidSchedulers.mainThread())
            .subscribeOn(Schedulers.io())
    }

    /**
     * /innovation-service/orientation
     * Get orientation result
     *
     * Auth Mode : Bearer
     *
     * Get status of an orientation job. If succeed, get the detected orientation, with a accuracy score.
     */
    fun orientationGetJobStatus(jobId: String): Single<OrientationResponse> {
        return client.orientationGetJobStatus(jobId)
            .observeOn(AndroidSchedulers.mainThread())
            .subscribeOn(Schedulers.io())
    }

    /**
     * /innovation-service/faces-attributes
     * Ask to start a faces attributes detection job
     *
     * Auth Mode : Bearer
     *
     * This route will start a job that will detect all faces in an input image, and detect location of each on image, age and genre of each person, and if they wear a mask or no.
     */
    fun facesAttributesCreateJob(inputMedia: File, area: Area? = null): Single<String?> {
        val mediaBody: RequestBody = inputMedia
            .asRequestBody(getMimeType(inputMedia.toUri()).toMediaTypeOrNull())
        val media = MultipartBody.Part.createFormData("input_media", inputMedia.name, mediaBody)
        val areaBody = if (area != null)
            MultipartBody.Part.createFormData("detection_area", Gson().toJson(area))
        else null
        return client.facesAttributesCreateJob(media, areaBody).map {
            it.values.firstOrNull()
        } .observeOn(AndroidSchedulers.mainThread())
            .subscribeOn(Schedulers.io())
    }

    /**
     * /innovation-service/faces-attributes
     * Get the status of a faces attributes job
     *
     * Auth Mode : Bearer
     *
     * return the job status.
     * In case of success response will contains a list of detected faces and their attributes.
     */
    fun facesAttributesJobStatus(jobId: String): Single<FacesAttributesResponse> {
        return client.facesAttributesJobStatus(jobId)
            .observeOn(AndroidSchedulers.mainThread())
            .subscribeOn(Schedulers.io())
    }

    /**
     * /innovation-service/identity
     * Ask to start an identity creation job
     *
     * Auth Mode : Bearer
     *
     * This route will start a job that will process a maximum of 5 input_images, create associated vectors and register an identity if success.
     */
    fun identityCreateJob(vararg inputMedias: File): Single<String?> {
        val mediaList = mutableListOf<MultipartBody.Part>()
        inputMedias.forEach {
            val mediaBody: RequestBody = it
                .asRequestBody(getMimeType(it.toUri()).toMediaTypeOrNull())
            val media = MultipartBody.Part.createFormData("input_images", it.name, mediaBody)
            mediaList.add(media)
        }
        return client.identityCreateJob(mediaList).map {
            it.values.firstOrNull()
        } .observeOn(AndroidSchedulers.mainThread())
            .subscribeOn(Schedulers.io())
    }

    /**
     * /innovation-service/identity
     * Get the status of a identity creation / update job
     *
     * Auth Mode : Bearer
     *
     * return the job status.
     * In case of success response will contain the status of the creation / update and the identity id of the created / updated identity.
     */
    fun identityGetJobStatus(jobId: String): Single<IdentityResponse> {
        return client.identityGetJobStatus(jobId)
            .observeOn(AndroidSchedulers.mainThread())
            .subscribeOn(Schedulers.io())
    }

    /**
     * /innovation-service/identity
     * Delete many identities
     *
     * Auth Mode : Bearer
     *
     * returns a 204 if success.
     */
    fun identityDeleteIdentities(vararg identitiesId: String): Completable {
        return client.identityDeleteIdentities(IdentityDeleteRequest(identitiesId.toList())).observeOn(AndroidSchedulers.mainThread())
            .subscribeOn(Schedulers.io())
    }

    /**
     * /innovation-service/identity
     * Ask to start an identity update job
     *
     * Auth Mode : Bearer
     *
     * This route will start a job that will process a maximum of 5 input_images, create associated vectors for a specified identity_id.
     */
    fun identityCreateAddImageJob(vararg inputMedias: File, identityId: String): Single<String?> {
        val mediaList = mutableListOf<MultipartBody.Part>()
        inputMedias.forEach {
            val mediaBody: RequestBody = it
                .asRequestBody(getMimeType(it.toUri()).toMediaTypeOrNull())
            val media = MultipartBody.Part.createFormData("input_images", it.name, mediaBody)
            mediaList.add(media)
        }
        val identityIdBody = MultipartBody.Part.createFormData("identity_id", identityId)
        return client.identityCreateAddImageJob(mediaList, identityIdBody).map {
                it.values.firstOrNull()
            }.observeOn(AndroidSchedulers.mainThread())
            .subscribeOn(Schedulers.io())
    }

    /**
     * /innovation-service/identity/search
     * Ask to start an identity search job (match an input against all known identity)
     *
     * Auth Mode : Bearer
     *
     * This route will start a search job. The search job will search in all known identities to matche the input_image. Result ca be 0, 1, or many matching identities. Results are sorted by there trust score.
     */
    fun identityCreateSearchJob(inputMedia: File, maxResult: Int): Single<String?> {
        val mediaBody: RequestBody = inputMedia
            .asRequestBody(getMimeType(inputMedia.toUri()).toMediaTypeOrNull())
        val media = MultipartBody.Part.createFormData("input_image", inputMedia.name, mediaBody)
        val maxResultBody = MultipartBody.Part.createFormData("max_result", maxResult.toString())
        return client.identityCreateSearchJob(media, maxResultBody).map {
            it.values.firstOrNull()
        } .observeOn(AndroidSchedulers.mainThread())
            .subscribeOn(Schedulers.io())
    }

    /**
     * /innovation-service/identity/search
     * Get the status of a identity search job
     *
     * Auth Mode : Bearer
     *
     * If success returns a list of identity id and trust score sorted by the score. Only scores above 0.85 will be returned.
     */
    fun identityGetSearchJobStatus(jobId: String): Single<IdentitySearchResponse> {
        return client.identityGetSearchJobStatus(jobId)
            .observeOn(AndroidSchedulers.mainThread())
            .subscribeOn(Schedulers.io())
    }

    /**
     * /innovation-service/identity/recognize
     * Ask to start an identity recognition job (check if input image match one specific identity)
     *
     * Auth Mode : Bearer
     *
     * This route will start a recognize job. This job will confirm if the input image is matching the input identity_id.
     */
    fun identityCreateRecognizeJob(inputMedia: File, identityId: String): Single<String?> {
        val mediaBody: RequestBody = inputMedia
            .asRequestBody(getMimeType(inputMedia.toUri()).toMediaTypeOrNull())
        val media = MultipartBody.Part.createFormData("input_image", inputMedia.name, mediaBody)
        val identityIdBody = MultipartBody.Part.createFormData("identity_id", identityId)
        return client.identityCreateRecognizeJob(media, identityIdBody).map {
            it.values.firstOrNull()
        } .observeOn(AndroidSchedulers.mainThread())
            .subscribeOn(Schedulers.io())
    }

    /**
     * /innovation-service/identity/recognize
     * Get the status of a identity recognition job
     *
     * Auth Mode : Bearer
     *
     * If success returns a the identity_id, the score of the comparision, and a confirmation boolean
     * This confirmation boolean will be true if the score is above or equal at 0.95 and false if the score is less.
     */
    fun identityGetRecognizeJobStatus(jobId: String): Single<IdentityRecognizeResponse> {
        return client.identityGetRecognizeJobStatus(jobId)
            .observeOn(AndroidSchedulers.mainThread())
            .subscribeOn(Schedulers.io())
    }

    fun getMimeType(uri: Uri?): String {
        var mimeType: String? = null
        mimeType = if (ContentResolver.SCHEME_CONTENT == uri?.getScheme()) {
            val cr: ContentResolver = appContext.getContentResolver()
            cr.getType(uri)
        } else {
            val fileExtension = MimeTypeMap.getFileExtensionFromUrl(
                uri
                    .toString()
            )
            MimeTypeMap.getSingleton().getMimeTypeFromExtension(
                fileExtension.toLowerCase()
            )
        }
        return mimeType ?: ""
    }

    companion object {
        private val TAG: String = this::class.java.simpleName
        private const val TIMEOUT_SEC = 20
        private const val CONNECTED_CACHE_MAX_AGE: Long = 60 * 60 * 24
        private const val UNCONNECTED_CACHE_MAX_AGE = Long.MAX_VALUE
        private const val LANGUAGE_TYPE_KEY = "Content-Language"
        private const val CONTENT_TYPE_KEY = "Content-type"
        private const val CONTENT_TYPE_VALUE = "application/json"
        private const val AUTHORIZATION_KEY = "authorization"
        private const val BEARER_KEY = "Bearer "
        private const val CACHE_CONNECTED_MAX_AGE = 600L // 600 Seconds
        const val WASSA_DATE_FORMAT = "yyyy-MM-dd'T'HH:mm:ss.SSS'Z'"
    }
}