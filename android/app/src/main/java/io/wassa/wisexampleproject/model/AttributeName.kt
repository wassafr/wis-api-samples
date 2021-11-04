package io.wassa.wisexampleproject.model

import com.google.gson.annotations.SerializedName

enum class AttributeName {
    @SerializedName("age") Age,
    @SerializedName("gender") Gender,
    @SerializedName("mask") Mask
}
