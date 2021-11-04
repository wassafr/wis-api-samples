package io.wassa.wisexampleproject.model.response

import com.google.gson.annotations.SerializedName
import io.wassa.wisexampleproject.model.Soiling

class IdentityResponse: Response() {
    @SerializedName("identity_id") val identityId: String? = null
}
