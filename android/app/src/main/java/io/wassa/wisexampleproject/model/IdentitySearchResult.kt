package io.wassa.wisexampleproject.model

import com.google.gson.annotations.SerializedName

data class IdentitySearchResult(
    @SerializedName("identity_id") val identityId: String? = null,
    val score: Double? = null,
    val recognition: Boolean? = null
)
