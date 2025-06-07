package org.example.casemd3.service;

import org.apache.http.HttpResponse;
import org.apache.http.client.HttpClient;
import org.apache.http.client.methods.HttpPost;
import org.apache.http.entity.ContentType;
import org.apache.http.entity.mime.MultipartEntityBuilder;
import org.apache.http.impl.client.HttpClients;
import org.apache.http.util.EntityUtils;
import org.example.casemd3.model.FaceId;
import org.example.casemd3.model.User;
import org.json.JSONArray;
import org.json.JSONObject;

import java.io.IOException;
import java.io.InputStream;
import java.util.List;


public class FaceIdService {
    private final String apiKey = "hZTjbm-rAYWMd7lwV28c8IuA7HqRXekA";
    private final String apiSecret = "X8pvUaVTSnv5z8VV8Sz_LQuxx3rQ5F-N";
    private final String detectUrl = "https://api-us.faceplusplus.com/facepp/v3/detect";
    private final String compareUrl = "https://api-us.faceplusplus.com/facepp/v3/compare";
    private final HttpClient client = HttpClients.createDefault();

    public String detectFaceToken(InputStream imageStream) throws IOException {
        HttpPost detectPost = new HttpPost(detectUrl);
        MultipartEntityBuilder detectBuilder = MultipartEntityBuilder.create();
        detectBuilder.addTextBody("api_key", apiKey);
        detectBuilder.addTextBody("api_secret", apiSecret);
        detectBuilder.addBinaryBody("image_file", imageStream, ContentType.DEFAULT_BINARY, "photo.jpg");
        detectPost.setEntity(detectBuilder.build());

        HttpResponse detectResp = client.execute(detectPost);
        String detectJson = EntityUtils.toString(detectResp.getEntity());
        JSONArray faces = new JSONObject(detectJson).optJSONArray("faces");
        if (faces != null && faces.length() > 0) {
            return faces.getJSONObject(0).getString("face_token");
        }
        return null;
    }

    public FaceId recognizeUser(String faceToken, List<FaceId> FaceId) throws IOException {
        for (FaceId f : FaceId) {
            HttpPost comparePost = new HttpPost(compareUrl);
            MultipartEntityBuilder compBuilder = MultipartEntityBuilder.create();
            compBuilder.addTextBody("api_key", apiKey);
            compBuilder.addTextBody("api_secret", apiSecret);
            compBuilder.addTextBody("face_token1", faceToken);
            compBuilder.addTextBody("face_token2", f.getFaceIdToken());
            comparePost.setEntity(compBuilder.build());

            HttpResponse compareResp = client.execute(comparePost);
            String compareJson = EntityUtils.toString(compareResp.getEntity());
            JSONObject compareObj = new JSONObject(compareJson);
            if (compareObj.has("confidence")) {
                double confidence = compareObj.getDouble("confidence");
                if (confidence >= 90.0) {
                    return f;
                }
            } else {
                System.err.println("Compare error: " + compareJson);
            }
        }
        return null;
    }
}
