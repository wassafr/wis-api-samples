#!/usr/bin/php
<?php

function facesAttributesCreateJob(string $token, string $input_media, string $detection_area = null)
{
    $curl = curl_init();

    $body = array(
        'input_media' => new CURLFILE($input_media, mime_content_type($input_media))
    );

    if ($detection_area != null) $body['detection_area'] = $detection_area;

    curl_setopt_array($curl, array(
        CURLOPT_URL => 'https://api.services.wassa.io/innovation-service/faces-attributes',
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

function facesAttributesGetJobStatus(string $token, string $faces_attributes_job_id)
{
    $curl = curl_init();

    curl_setopt_array($curl, array(
        CURLOPT_URL => 'https://api.services.wassa.io/innovation-service/faces-attributes?faces_attributes_job_id=' . $faces_attributes_job_id,
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
    $jobId = facesAttributesCreateJob(
        '' /* Your bearer token */, 
        'images/faces_attributes.jpg'/* Path to your image: jpg, jpeg, png etc... */,
        '[{"x": 0.1, "y": 0.2}, {"x": 0.1, "y": 0.3}, {"x": 0.1, "y": 0}]'
    );
    var_dump($jobId);
    var_dump(facesAttributesGetJobStatus(
        '' /* Your bearer token */, 
        $jobId->faces_attributes_job_id /* faces_attributes_job_id */));
} catch (Exception $e) {
    echo 'Exception reçue : ',  $e->getMessage(), "\n";
}
?>