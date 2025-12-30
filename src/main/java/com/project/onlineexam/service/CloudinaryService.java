package com.project.onlineexam.service;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.*;
import org.springframework.stereotype.Service;
import org.springframework.util.LinkedMultiValueMap;
import org.springframework.util.MultiValueMap;
import org.springframework.web.client.RestTemplate;

import java.util.Map;

@Service
public class CloudinaryService {

    @Value("${cloudinary.cloud-name}")
    private String cloudName;

    @Value("${cloudinary.upload-preset}")
    private String uploadPreset;

    private final RestTemplate restTemplate = new RestTemplate();

    public String uploadImage(String base64Image) {
        try {
            String uploadUrl = "https://api.cloudinary.com/v1_1/" + cloudName + "/image/upload";

            HttpHeaders headers = new HttpHeaders();
            headers.setContentType(MediaType.MULTIPART_FORM_DATA);

            MultiValueMap<String, String> body = new LinkedMultiValueMap<>();
            body.add("file", base64Image);
            body.add("upload_preset", uploadPreset);
            body.add("cloud_name", cloudName);

            HttpEntity<MultiValueMap<String, String>> requestEntity = new HttpEntity<>(body, headers);

            ResponseEntity<Map> response = restTemplate.postForEntity(uploadUrl, requestEntity, Map.class);

            if (response.getStatusCode() == HttpStatus.OK && response.getBody() != null) {
                return (String) response.getBody().get("secure_url");
            }
            System.err.println("Cloudinary upload failed with status: " + response.getStatusCode());
            return null;
        } catch (Exception e) {
            System.err.println("Cloudinary upload error: " + e.getMessage());
            e.printStackTrace();
            return null;
        }
    }
}
