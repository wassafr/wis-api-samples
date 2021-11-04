package io.wassa.wisexampleproject.model

import com.google.gson.annotations.SerializedName

data class Token (
	@SerializedName("clientId") val clientId : String? = null,
	@SerializedName("secretId") val secretId : String? = null,
	@SerializedName("token") val token : String? = null,
	@SerializedName("expireTime") val expireTime : Int? = null,
	@SerializedName("refreshToken") val refreshToken : String? = null
)