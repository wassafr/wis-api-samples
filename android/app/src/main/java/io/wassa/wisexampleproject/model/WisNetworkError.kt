package io.wassa.wisexampleproject.model

import com.google.gson.annotations.SerializedName

data class WisNetworkError (
	@SerializedName("code", alternate = ["statusCode"]) val code : Int? = null,
	@SerializedName("error") val error : String? = null,
	@SerializedName("message") val message : String? = null,
	@SerializedName("details") val details : String? = null
)