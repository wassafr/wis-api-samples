package io.wassa.wisexampleproject.model

import com.google.gson.annotations.SerializedName

enum class Orientation {
    @SerializedName("normal") Normal,
    @SerializedName("clockwise") Clockwise,
    @SerializedName("counter_clockwise") CounterClockwise,
    @SerializedName("upside_down") UpsideDown,
    @SerializedName("unknown") Unknow
}
