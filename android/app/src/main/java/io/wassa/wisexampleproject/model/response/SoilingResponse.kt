package io.wassa.wisexampleproject.model.response

import com.google.gson.annotations.SerializedName
import io.wassa.wisexampleproject.model.Soiling

class SoilingResponse: Response() {
    @SerializedName("result_soiling") val resultSoiling: Soiling? = null
}
