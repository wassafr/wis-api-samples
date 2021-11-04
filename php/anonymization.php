#!/usr/bin/php
<?php

function anonymizationCreateJob(string $token, string $input_media, string $activation_faces_blur = null, string $output_detections_url = null, string $included_area = null)
{
    $curl = curl_init();

    $body = array(
        'input_media' => new CURLFILE($input_media, mime_content_type($input_media)), 
        );
        if ($activation_faces_blur != null) $body['activation_faces_blur'] = $activation_faces_blur;
        if ($output_detections_url != null) $body['output_detections_url'] = $output_detections_url; 
        if ($included_area != null) $body['included_area'] = $included_area;

    curl_setopt_array($curl, array(
        CURLOPT_URL => 'https://api.services.wassa.io/innovation-service/anonymization',
        CURLOPT_RETURNTRANSFER => true,
        CURLOPT_ENCODING => '',
        CURLOPT_MAXREDIRS => 10,
        CURLOPT_TIMEOUT => 0,
        CURLOPT_FOLLOWLOCATION => true,
        CURLOPT_HTTP_VERSION => CURL_HTTP_VERSION_1_1,
        CURLOPT_CUSTOMREQUEST => 'POST',
        CURLOPT_POSTFIELDS => $body,
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

function anonymizationGetJobStatus(string $token, string $anonymization_job_id)
{
    $curl = curl_init();

    curl_setopt_array($curl, array(
        CURLOPT_URL => 'https://api.services.wassa.io/innovation-service/anonymization?anonymization_job_id=' . $anonymization_job_id,
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
    $jobId = anonymizationCreateJob(
        '' /* Your bearer token */, 
        'images/anonymization.jpeg'/* Path to your image: jpg, jpeg, png etc... */, 
        'true', 
        'true', 
        '{"left": 0, "right": 0.5, "top": 0, "bottom": 1}');
    var_dump($jobId);
    var_dump(anonymizationGetJobStatus(
        '' /* Your bearer token */,
        $jobId->anonymization_job_id /* anonymization_job_id */));
} catch (Exception $e) {
    echo 'Exception reçue : ',  $e->getMessage(), "\n";
}
?>