package io.wassa.wisexampleproject.model

import com.google.gson.annotations.SerializedName

enum class WatermarkPreset {
    @SerializedName("upper_right") UpperRight,
    @SerializedName("lower_right") LowerRight,
    @SerializedName("upper_left") UpperLeft,
    @SerializedName("lower_left") LowerLeft,
    @SerializedName("center_right") CenterRight,
    @SerializedName("center_left") CenterLeft,
    @SerializedName("center") Center,
    @SerializedName("lower") Lower
}