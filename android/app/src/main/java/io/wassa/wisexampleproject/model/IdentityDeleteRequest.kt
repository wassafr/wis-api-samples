package io.wassa.wisexampleproject.model

import com.google.gson.annotations.SerializedName
import io.wassa.wisexampleproject.model.response.Response

class IdentityDeleteRequest(
    @SerializedName("identity_id") val identityId: List<String>? = null
)
