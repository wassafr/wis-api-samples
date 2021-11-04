package io.wassa.wisexampleproject.model.response

import com.google.gson.annotations.SerializedName
import io.wassa.wisexampleproject.model.IdentitySearchResult
import io.wassa.wisexampleproject.model.Soiling

class IdentityRecognizeResponse: Response() {
    @SerializedName("results") val results: IdentitySearchResult? = null
}
