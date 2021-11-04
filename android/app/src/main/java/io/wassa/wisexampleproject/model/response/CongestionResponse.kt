package io.wassa.wisexampleproject.model.response

import io.wassa.wisexampleproject.model.JobStatus
import io.wassa.wisexampleproject.model.VehicleType

class CongestionResponse: Response() {
    val vehicles: List<VehicleType>? = null
}
