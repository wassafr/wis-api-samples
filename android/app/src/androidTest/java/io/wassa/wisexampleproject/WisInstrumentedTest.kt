package io.wassa.wisexampleproject

import android.content.Context
import android.util.Log
import androidx.test.ext.junit.runners.AndroidJUnit4
import androidx.test.platform.app.InstrumentationRegistry
import io.wassa.wisexampleproject.data.WisExampleClient
import io.wassa.wisexampleproject.model.*
import org.junit.Assert.*
import org.junit.Test
import org.junit.runner.RunWith
import java.io.File
import java.io.FileOutputStream
import java.nio.file.Files
import java.nio.file.StandardCopyOption
import io.wassa.wisexampleproject.test.R
import java.util.*

/**
 * Instrumented test, which will execute on an Android device.
 *
 * See [testing documentation](http://d.android.com/tools/testing).
 */
@RunWith(AndroidJUnit4::class)
class WisInstrumentedTest {

    val appContext = InstrumentationRegistry.getInstrumentation().targetContext
    val client = WisExampleClient(appContext)

    @Test
    fun testLogin() {
        assert(login() != null)
    }

    @Test
    fun testCongestion() {
        login()
        val jobId = client.congestionCreateJob(
            getFileFromResources(InstrumentationRegistry.getInstrumentation().context, R.raw.congestion), mutableListOf(
                Point(0.0, 0.0), Point(0.8, 0.8)
            ),
            Area(0.0, 0.0, 1.0, 1.0)
        ).blockingGet()
        assert(jobId != null)
        val result = client.congestionGetJobStatus(jobId ?: "").blockingGet()
        assert(result != null)
        assert(result.status == JobStatus.Started || result.status == JobStatus.Sent || result.status == JobStatus.Succeeded)
        Thread.sleep(5000)
        val resultFinished = client.congestionGetJobStatus(jobId ?: "").blockingGet()
        assert(resultFinished != null)
        assert(resultFinished.status == JobStatus.Succeeded)
        assert(resultFinished.vehicles != null)
        assert(resultFinished.vehicles?.size == 7)
        assert(resultFinished.vehicles?.first() == VehicleType.Car)
    }

    @Test
    fun testSoiling() {
        login()
        val jobId = client.soilingCreateJob(
            getFileFromResources(InstrumentationRegistry.getInstrumentation().context, R.raw.soiling), mutableListOf(
                Point(0.0, 0.0), Point(0.8, 0.8), Point(0.0, 0.0)
            )
        ).blockingGet()
        assert(jobId != null)
        val result = client.soilingGetJobStatus(jobId ?: "").blockingGet()
        assert(result != null)
        assert(result.status == JobStatus.Started || result.status == JobStatus.Sent || result.status == JobStatus.Succeeded)
        Thread.sleep(5000)
        val resultFinished = client.soilingGetJobStatus(jobId ?: "").blockingGet()
        assert(resultFinished != null)
        assert(resultFinished.status == JobStatus.Succeeded)
        assert(resultFinished.resultSoiling != null)
        assert(resultFinished.resultSoiling?.dust ?: 1.0 < 0.03)
        assert(resultFinished.resultSoiling?.dirt ?: 1.0 < 0.002)
        assert(resultFinished.resultSoiling?.clod  != null)
        assert(resultFinished.resultSoiling?.gravel != null)
    }

    @Test
    fun testAnonymization() {
        login()
        val jobId = client.anonymizationCreateJob(
            getFileFromResources(InstrumentationRegistry.getInstrumentation().context, R.raw.anonymization), true, true, true, Area(0.0, 0.0, 1.0, 1.0)
        ).blockingGet()
        assert(jobId != null)
        val result = client.anonymizationGetJobStatus(jobId ?: "").blockingGet()
        assert(result != null)
        assert(result.status == JobStatus.Started || result.status == JobStatus.Sent || result.status == JobStatus.Succeeded)
        Thread.sleep(5000)
        val resultFinished = client.anonymizationGetJobStatus(jobId ?: "").blockingGet()
        assert(resultFinished != null)
        assert(resultFinished.status == JobStatus.Succeeded)
        assert(resultFinished.outputJson != null)
        assert(resultFinished.outputMedia != null)
    }

    @Test
    fun testWatermark() {
        login()
        val jobId = client.watermarkCreateJob(
            getFileFromResources(InstrumentationRegistry.getInstrumentation().context, R.raw.input_media), getFileFromResources(InstrumentationRegistry.getInstrumentation().context, R.raw.input_watermark), 0.5, 0.2, WatermarkPreset.UpperRight
        ).blockingGet()
        assert(jobId != null)
        val result = client.watermarkGetJobStatus(jobId ?: "").blockingGet()
        assert(result != null)
        assert(result.status == JobStatus.Started || result.status == JobStatus.Sent || result.status == JobStatus.Succeeded)
        Thread.sleep(5000)
        val resultFinished = client.watermarkGetJobStatus(jobId ?: "").blockingGet()
        assert(resultFinished != null)
        assert(resultFinished.status == JobStatus.Succeeded)
        assert(resultFinished.outputMediaUrl != null)
    }

    @Test
    fun testWatermarkFailed() {
        login()
        val jobId = client.watermarkCreateJob(
            getFileFromResources(InstrumentationRegistry.getInstrumentation().context, R.raw.input_media), getFileFromResources(InstrumentationRegistry.getInstrumentation().context, R.raw.input_watermark), -0.1, 1.0, WatermarkPreset.UpperRight
        ).blockingGet()
        assert(jobId != null)
        Log.d("TAG", "JobId ${jobId}")
        val result = client.watermarkGetJobStatus(jobId ?: "").blockingGet()
        assert(result != null)
        assert(result.status == JobStatus.Started || result.status == JobStatus.Sent || result.status == JobStatus.Succeeded || result.status == JobStatus.Retried)
        Thread.sleep(5000)
        val resultFinished = client.watermarkGetJobStatus(jobId ?: "").blockingGet()
        assert(resultFinished != null)
        assert(resultFinished.status == JobStatus.Failed || resultFinished.status == JobStatus.Retried)
        assert(resultFinished.outputMediaUrl == null)
    }

    @Test
    fun testVehiclePedestrian() {
        login()
        val jobId = client.vehiclesPedestriansDetectionCreateJob(
            getFileFromResources(InstrumentationRegistry.getInstrumentation().context, R.raw.vap),
        ).blockingGet()
        assert(jobId != null)
        val result = client.vehiclesPedestriansDetectionGetJobStatus(jobId ?: "").blockingGet()
        assert(result != null)
        assert(result.status == JobStatus.Started || result.status == JobStatus.Sent || result.status == JobStatus.Succeeded)
        Thread.sleep(5000)
        val resultFinished = client.vehiclesPedestriansDetectionGetJobStatus(jobId ?: "").blockingGet()
        assert(resultFinished != null)
        assert(resultFinished.status == JobStatus.Succeeded)
        assert(resultFinished.objects != null)
        assert(resultFinished.objects?.size == 4)
        assert(resultFinished.objects?.get(0)?.box?.size == 4)
        assert(resultFinished.objects?.get(0)?.score != null)
        assert(resultFinished.objects?.get(0)?.vehicleType != null)
    }

    @Test
    fun testVehiclePedestrianOnlyCar() {
        login()
        val jobId = client.vehiclesPedestriansDetectionCreateJob(
            getFileFromResources(InstrumentationRegistry.getInstrumentation().context, R.raw.input_media), listOf(VehicleType.Car, VehicleType.Truck),
            mutableListOf(
                Point(0.0, 0.0), Point(0.8, 0.8), Point(0.0, 0.0)
            )
        ).blockingGet()
        assert(jobId != null)
        val result = client.vehiclesPedestriansDetectionGetJobStatus(jobId ?: "").blockingGet()
        assert(result != null)
        assert(result.status == JobStatus.Started || result.status == JobStatus.Sent || result.status == JobStatus.Succeeded)
        Thread.sleep(5000)
        val resultFinished = client.vehiclesPedestriansDetectionGetJobStatus(jobId ?: "").blockingGet()
        assert(resultFinished != null)
        assert(resultFinished.status == JobStatus.Succeeded)
        assert(resultFinished.objects?.size == 0)
    }

    @Test
    fun testOrientation() {
        login()
        val jobId = client.orientationCreateJob(
            getFileFromResources(InstrumentationRegistry.getInstrumentation().context, R.raw.orientation),
        ).blockingGet()
        assert(jobId != null)
        val result = client.orientationGetJobStatus(jobId ?: "").blockingGet()
        assert(result != null)
        assert(result.status == JobStatus.Started || result.status == JobStatus.Sent || result.status == JobStatus.Succeeded)
        Thread.sleep(5000)
        val resultFinished = client.orientationGetJobStatus(jobId ?: "").blockingGet()
        assert(resultFinished != null)
        assert(resultFinished.status == JobStatus.Succeeded)
        assert(resultFinished.label != null)
        assert(resultFinished.confidence != null)
    }

    @Test
    fun testFacesAttributes() {
        login()
        val jobId = client.facesAttributesCreateJob(
            getFileFromResources(InstrumentationRegistry.getInstrumentation().context, R.raw.faces_attributes),
        ).blockingGet()
        assert(jobId != null)
        val result = client.facesAttributesJobStatus(jobId ?: "").blockingGet()
        assert(result != null)
        assert(result.status == JobStatus.Started || result.status == JobStatus.Sent || result.status == JobStatus.Succeeded)
        Thread.sleep(5000)
        val resultFinished = client.facesAttributesJobStatus(jobId ?: "").blockingGet()
        assert(resultFinished != null)
        assert(resultFinished.status == JobStatus.Succeeded)
        assert(resultFinished.faces != null)
        assert(resultFinished.faces?.size ?: 0 > 0)
    }

    @Test
    fun testIdentity() {
        login()
        val jobId = client.identityCreateJob(
            getFileFromResources(InstrumentationRegistry.getInstrumentation().context, R.raw.identity1),
            getFileFromResources(InstrumentationRegistry.getInstrumentation().context, R.raw.identity2)
        ).blockingGet()
        assert(jobId != null)
        val result = client.identityGetJobStatus(jobId ?: "").blockingGet()
        assert(result != null)
        assert(result.status == JobStatus.Started || result.status == JobStatus.Sent || result.status == JobStatus.Succeeded || result.status == JobStatus.Unknown)
        Thread.sleep(5000)
        val resultFinished = client.identityGetJobStatus(jobId ?: "").blockingGet()
        assert(resultFinished != null)
        assert(resultFinished.status == JobStatus.Succeeded)
        assert(resultFinished.identityId != null)
    }

    @Test
    fun testIdentityDelete() {
        login()
        val jobId = client.identityCreateJob(
            getFileFromResources(InstrumentationRegistry.getInstrumentation().context, R.raw.identity1),
            getFileFromResources(InstrumentationRegistry.getInstrumentation().context, R.raw.identity2)
        ).blockingGet()
        assert(jobId != null)
        val result = client.identityGetJobStatus(jobId ?: "").blockingGet()
        assert(result != null)
        assert(result.status == JobStatus.Started || result.status == JobStatus.Sent || result.status == JobStatus.Succeeded || result.status == JobStatus.Unknown)
        Thread.sleep(5000)
        val resultFinished = client.identityGetJobStatus(jobId ?: "").blockingGet()
        assert(resultFinished != null)
        assert(resultFinished.status == JobStatus.Succeeded)
        assert(resultFinished.identityId != null)
        client.identityDeleteIdentities(
            resultFinished.identityId ?: ""
        ).blockingAwait()
    }

    @Test
    fun testIdentityAddImage() {
        login()
        var jobId = client.identityCreateJob(
            getFileFromResources(InstrumentationRegistry.getInstrumentation().context, R.raw.identity1),
            getFileFromResources(InstrumentationRegistry.getInstrumentation().context, R.raw.identity2)
        ).blockingGet()
        assert(jobId != null)
        var result = client.identityGetJobStatus(jobId ?: "").blockingGet()
        assert(result != null)
        assert(result.status == JobStatus.Started || result.status == JobStatus.Sent || result.status == JobStatus.Succeeded|| result.status == JobStatus.Unknown)
        Thread.sleep(5000)
        var resultFinished = client.identityGetJobStatus(jobId ?: "").blockingGet()
        Log.d("TAG", "${resultFinished.status}")
        assert(resultFinished != null)
        assert(resultFinished.status == JobStatus.Succeeded || resultFinished.status == JobStatus.Unknown)
        assert(resultFinished.identityId != null)
        jobId = client.identityCreateAddImageJob(
            getFileFromResources(InstrumentationRegistry.getInstrumentation().context, R.raw.identity2),
            identityId = resultFinished.identityId ?: ""
        ).blockingGet()
        assert(jobId != null)
        result = client.identityGetJobStatus(jobId ?: "").blockingGet()
        assert(result != null)
        assert(result.status == JobStatus.Started || result.status == JobStatus.Sent || result.status == JobStatus.Succeeded || resultFinished.status == JobStatus.Unknown)
        Thread.sleep(5000)
        resultFinished = client.identityGetJobStatus(jobId ?: "").blockingGet()
        assert(resultFinished != null)
        assert(resultFinished.status == JobStatus.Succeeded)
    }

    @Test
    fun testSearch() {
        login()
        val jobId = client.identityCreateSearchJob(
            getFileFromResources(InstrumentationRegistry.getInstrumentation().context, R.raw.identity1),
            10
        ).blockingGet()
        assert(jobId != null)
        val result = client.identityGetSearchJobStatus(jobId ?: "").blockingGet()
        assert(result != null)
        assert(result.status == JobStatus.Started || result.status == JobStatus.Sent || result.status == JobStatus.Succeeded)
        Thread.sleep(5000)
        val resultFinished = client.identityGetSearchJobStatus(jobId ?: "").blockingGet()
        assert(resultFinished != null)
        assert(resultFinished.status == JobStatus.Succeeded)
        assert(resultFinished.results != null)
    }

    @Test
    fun testIdentityRecognize() {
        login()
        val jobIdCreate = client.identityCreateJob(
            getFileFromResources(InstrumentationRegistry.getInstrumentation().context, R.raw.identity1),
            getFileFromResources(InstrumentationRegistry.getInstrumentation().context, R.raw.identity2)
        ).blockingGet()
        assert(jobIdCreate != null)
        val resultCreate = client.identityGetJobStatus(jobIdCreate ?: "").blockingGet()
        assert(resultCreate != null)
        assert(resultCreate.status == JobStatus.Started || resultCreate.status == JobStatus.Sent || resultCreate.status == JobStatus.Succeeded || resultCreate.status == JobStatus.Unknown)
        Thread.sleep(5000)
        val resultFinishedCreate = client.identityGetJobStatus(jobIdCreate ?: "").blockingGet()
        assert(resultFinishedCreate != null)
        assert(resultFinishedCreate.status == JobStatus.Succeeded)
        assert(resultFinishedCreate.identityId != null)
        val jobId = client.identityCreateRecognizeJob(
            getFileFromResources(InstrumentationRegistry.getInstrumentation().context, R.raw.identity1),
            resultFinishedCreate.identityId ?: ""
        ).blockingGet()
        assert(jobId != null)
        Thread.sleep(5000)
        val result = client.identityGetRecognizeJobStatus(jobId ?: "").blockingGet()
        assert(result != null)
        assert(result.status == JobStatus.Started || result.status == JobStatus.Sent || result.status == JobStatus.Succeeded)
        Thread.sleep(5000)
        val resultFinished = client.identityGetRecognizeJobStatus(jobId ?: "").blockingGet()
        assert(resultFinished != null)
        assert(resultFinished.status == JobStatus.Succeeded)
        assert(resultFinished.results != null)
    }

    private fun login(): Token {
        return client.login("CLIENT ID", "SECRET ID").blockingGet()
    }

    private fun getFileFromResources(context: Context, fileId: Int): File {
        val testFile = File(InstrumentationRegistry.getInstrumentation().targetContext.cacheDir, "${UUID.randomUUID().toString()}.jpeg")
        Files.copy(context.resources.openRawResource(fileId), testFile.toPath(), StandardCopyOption.REPLACE_EXISTING)
        return testFile
    }
}