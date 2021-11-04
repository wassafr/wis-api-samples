package io.wassa.wisexampleproject.model

import com.google.gson.annotations.SerializedName

enum class VehicleType {
    @SerializedName("car")
    Car,
    @SerializedName("truck")
    Truck,
    @SerializedName("pedestrian")
    Pedestrian,
    @SerializedName("bus")
    Bus,
    @SerializedName("motorcycle")
    Motorcycle,
    @SerializedName("bicycle")
    Bicycle
}