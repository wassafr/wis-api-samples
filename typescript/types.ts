import { AxiosResponse } from "axios";

export interface WisError extends Response {
  code: number | null;
  error: string | null;
  message: string | null;
  details: string | null;
}

export interface Token {
  token: string | null;
  expireTime: number | null;
  refreshToken: string | null;
}

export interface Box {
  left: number | null;
  top: number | null;
  right: number | null;
  bottom: number | null;
}

export interface Point {
  x: number;
  y: number;
}

enum VehicleType {
  car,
  truck,
  pedestrian,
  bus,
  motorcycle,
  bicycle,
}

enum AttributeName {
  age,
  gender,
  mask,
}

enum Orientation {
  normal,
  clockwise,
  counter_clockwise,
  upside_down,
  unknown
}

interface DetectedObject {
  class_name: VehicleType | null;
  score: number | null;
  box: Array<Point> | null;
}

interface FaceAttributes {
  name: AttributeName | null;
  value: any | null;
  confidence: number | null;
}

interface Face {
  confidence: number | null;
  box: Box | null;
  attributes: Array<FaceAttributes> | null;
}

interface IdentitySearchResult {
  identity_id: string | null;
  score: number | null;
  recognition?: boolean | null;
}

interface Soiling {
  dust: number | null;
  dirt: number | null;
  grave: number | null;
  clod: number | null;
}

/*
RESPONSES
*/

enum JobStatus {
  'Sent',
  'Started',
  'Succeeded',
  'Failed',
  'Unknown job',
  'Revoked'
}

interface Response {
  status: JobStatus | null;
}

// ANONYMIZATION

export interface CreateAnonymizationResponse {
  anonymization_job_id: string | null;
}

export interface AnonymizationResponse extends Response {
  output_media: string | null;
  output_json: string | null;
}

// CONGESTION

export interface CreateCongestionResponse {
  congestion_job_id: string | null;
}

export interface CongestionResponse extends Response {
  vehicles: Array<VehicleType>;
}

// SOILING

export interface CreateSoilingResponse {
  soiling_job_id: string | null;
}

export interface SoilingResponse extends Response {
  result_soiling: Soiling | null;
}

// ORIENTATION

export interface CreateOrientationResponse {
  orientation_job_id: string | null;
}

export interface OrientationResponse extends Response {
  label: Orientation | null;
  confidence: number | null;
}

// FACES ATTRIBUTES

export interface CreateFacesAttributesResponse {
  faces_attributes_job_id: string | null;
}

export interface FacesAttributesResponse extends Response {
  faces: Array<Face> | null;
  faces_counting: number | null;
}

// WATERMARK

export interface CreateWatermarkResponse {
  watermark_job_id: string | null;
}

export interface WatermarkResponse extends Response {
  output_image_url: string | null;
}

// VEHICLES PEDESTRIANS DETECTION

export interface CreateVehiclesPedestriansDetectionResponse {
  vehicle_pedestrian_detection_job_id: string | null;
}

export interface VehiclesPedestriansDetectionResponse extends Response {
  vehicles: Array<VehicleType> | null;
}

// RESULT FILE

export interface ResultFileResponse {
  response: File | null;
}

// IDENTITY

export interface CreateIdentityResponse {
  job_id: string | null;
}

export interface IdentityResponse extends Response {
  identity_id: string | null;
}

export interface CreateIdentitySearchResponse {
  job_id: string | null;
}

export interface IdentitySearchResponse extends Response {
  results: Array<IdentitySearchResult> | null;
}

export interface CreateIdentityRecognitionResponse {
  job_id: string | null;
}

export interface IdentityRecognitionResponse extends Response {
  results: Array<IdentitySearchResult> | null;
}