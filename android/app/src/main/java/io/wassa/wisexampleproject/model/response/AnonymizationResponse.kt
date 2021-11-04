package io.wassa.wisexampleproject.model.response

import com.google.gson.annotations.SerializedName
import io.wassa.wisexampleproject.model.JobStatus
import io.wassa.wisexampleproject.model.VehicleType

class AnonymizationResponse: Response() {
    @SerializedName("output_media") val outputMedia: String? = null
    @SerializedName("output_json") val outputJson: String? = null
}
