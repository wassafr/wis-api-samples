#!/usr/bin/php
<?php

function congestionCreateJob(string $token, string $picture, string $congestion_line, string $include_area = null)
{
    $curl = curl_init();

    $body = array(
        'picture' => new CURLFILE($picture, mime_content_type($picture)), 
        'congestion_line' => $congestion_line);
    
    if ($include_area != null) $body['include_area'] = $include_area; 

    curl_setopt_array($curl, array(
        CURLOPT_URL => 'https://api.services.wassa.io/innovation-service/congestion',
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

function congestionGetJobStatus(string $token, string $congestion_job_id)
{
    $curl = curl_init();

    curl_setopt_array($curl, array(
        CURLOPT_URL => 'https://api.services.wassa.io/innovation-service/congestion?congestion_job_id=' . $congestion_job_id,
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
    $jobId = congestionCreateJob(
        '' /* Your bearer token */, 
        'images/congestion.jpeg'/* Path to your image: jpg, jpeg, png etc... */, 
        '[{"x": 0, "y":0}, {"x": 0.8, "y": 0.8}, {"x":0, "y": 0}]', 
        '{"left": 0, "right": 0.5, "top": 0, "bottom": 1}');
    var_dump($jobId);
    var_dump(congestionGetJobStatus(
        '' /* Your bearer token */, 
        $jobId->congestion_job_id /* congestion_job_id */));
} catch (Exception $e) {
    echo 'Exception reçue : ',  $e->getMessage(), "\n";
}
?>