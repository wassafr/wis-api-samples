package io.wassa.wisexampleproject.model

import com.google.gson.annotations.SerializedName

class DetectedObject {
    @SerializedName("class_name") val vehicleType: VehicleType? = null
    @SerializedName("score") val score: Double? = null
    @SerializedName("box") val box: List<Point>? = null
}