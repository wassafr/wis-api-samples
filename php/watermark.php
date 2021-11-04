#!/usr/bin/php
<?php

function watermarkCreateJob($token, $input_media, $input_watermark, $watermark_transparency, $watermark_ratio, $watermark_position_preset)
{
    $curl = curl_init();

    curl_setopt_array($curl, array(
        CURLOPT_URL => 'https://api.services.wassa.io/innovation-service/watermark',
        CURLOPT_RETURNTRANSFER => true,
        CURLOPT_ENCODING => '',
        CURLOPT_MAXREDIRS => 10,
        CURLOPT_TIMEOUT => 0,
        CURLOPT_FOLLOWLOCATION => true,
        CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
        CURLOPT_CUSTOMREQUEST => 'POST',
        CURLOPT_POSTFIELDS => array(
            'input_media' => new CURLFILE($input_media, mime_content_type($input_media)), 
            'input_watermark' => new CURLFILE($input_watermark, mime_content_type($input_watermark)), 
            'watermark_transparency' => $watermark_transparency, 
            'watermark_ratio' => $watermark_ratio, 
            'watermark_position_preset' => $watermark_position_preset
        ),
        CURLOPT_HTTPHEADER => array(
            'Authorization: Bearer ' . $token
        ),
    ));

    $response = curl_exec($curl);

    $httpCode  = curl_getinfo($curl, CURLINFO_HTTP_CODE);

    $response = json_decode($response);

    if ($httpCode != 200) {
        throw new Exception('request failed with status ' . $httpCode . ' ' . $response->error);
    }
    curl_close($curl);

    return $response;
}

function watermarkGetJobStatus($token, $watermark_job_id)
{
    $curl = curl_init();

    curl_setopt_array($curl, array(
        CURLOPT_URL => 'https://api.services.wassa.io/innovation-service/watermark?watermark_job_id=' . $watermark_job_id,
        CURLOPT_RETURNTRANSFER => true,
        CURLOPT_ENCODING => '',
        CURLOPT_MAXREDIRS => 10,
        CURLOPT_TIMEOUT => 0,
        CURLOPT_FOLLOWLOCATION => true,
        CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
        CURLOPT_CUSTOMREQUEST => 'GET',
        CURLOPT_HTTPHEADER => array(
            'Authorization: Bearer ' . $token
        ),
      ));

    $response = curl_exec($curl);

    $httpCode  = curl_getinfo($curl, CURLINFO_HTTP_CODE);

    $response = json_decode($response);

    if ($httpCode != 200) {
        throw new Exception('request failed with status ' . $httpCode . ' ' . $response->error);
    }
    curl_close($curl);

    return $response;
}

try {
    $jobId = watermarkCreateJob(
        '' /* Your bearer token */, 
        'images/watermark/input_media.jpeg'/* Path to your image: jpg, jpeg, png etc... */, 
        'images/watermark/input_watermark.jpeg'/* Path to your image Watermark: jpg, jpeg, png etc... */, 
        '0.5', 
        '0.2',
        'upper_right');
    var_dump($jobId);
    var_dump(watermarkGetJobStatus(
        '' /* Your bearer token */,
        $jobId->watermark_job_id /* watermark_job_id */));
} catch (Exception $e) {
    echo 'Exception reçue : ',  $e->getMessage(), "\n";
}
?>