#!/usr/bin/php
<?php

function getResultFile($token, $fileName)
{
    $curl = curl_init();

    curl_setopt_array($curl, array(
        CURLOPT_URL => $fileName,
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

    if ($httpCode != 200) {
        throw new Exception('request failed with status ' . $httpCode . ' ' . $response->error);
    }
    curl_close($curl);

    return $response;
}

try {
    var_dump(getResultFile(
        '' /* Your bearer token */,
        '' /* Url of your result */
    ));
} catch (Exception $e) {
    echo 'Exception reçue : ',  $e->getMessage(), "\n";
}
?>