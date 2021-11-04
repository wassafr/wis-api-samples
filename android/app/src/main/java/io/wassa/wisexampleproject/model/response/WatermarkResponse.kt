package io.wassa.wisexampleproject.model.response

import com.google.gson.annotations.SerializedName

class WatermarkResponse: Response() {
    @SerializedName("output_image_url") val outputMediaUrl: String? = null
}
