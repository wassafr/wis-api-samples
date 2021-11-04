package io.wassa.wisexampleproject.model

import com.google.gson.annotations.SerializedName

enum class JobStatus {
    Sent,
    Started,
    Succeeded,
    Failed,
    Retried,
    @SerializedName("Unknown Status", alternate = ["Unknown Job"]) Unknown
}